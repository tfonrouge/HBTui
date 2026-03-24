# HBTui Event System Guide

## Overview

HBTui uses an event-driven architecture built on top of Harbour's `Inkey()` function and the CT (Clipper Tools) window system. The central component is `HTEventLoop`, a singleton that provides unified input polling, mouse tracking, and task scheduling.

```
User Input (keyboard/mouse)
     │
     ▼
HTEventLoop:poll()         ← unified polling: Inkey + mouse movement + tasks
     │
     ├── HTApplication:exec()      ← main window event routing
     │    ├── Mouse click → route to window under cursor
     │    ├── Keyboard    → route to active (focused) window
     │    └── Process priority queue: HIGH → NORMAL → LOW
     │
     ├── HTDialog:exec()           ← modal dialog event loop
     │    └── HTEventLoop:run(dialog, condition)
     │
     └── HTComboBox/MessageBox     ← modal poll loops
          └── HTEventLoop:poll() in DO WHILE
```

## HTEventLoop (Singleton)

### poll( nTimeout ) → HTEvent or NIL

Checks for input events in this order:
1. Runs `HTToast():checkExpired()` to dismiss expired toasts
2. Runs `runPendingTasks()` to execute scheduled callbacks
3. Detects mouse movement by comparing `mRow(.T.)/mCol(.T.)` with stored position
4. Calls `Inkey(nTimeout)` for keyboard and mouse click events
5. Intercepts `HB_K_RESIZE` (terminal resize) — calls `handleResize()` which updates desktop dimensions, resets CT board, repaints all windows, and resets mouse tracking.

Returns an `HTMouseEvent` or `HTKeyEvent`, or NIL if no input.

```harbour
LOCAL event := HTEventLoop():poll( 0.1 )  /* 100ms timeout */
IF event != NIL
    IF event:className() == "HTMOUSEEVENT"
        ? "Mouse event:", event:nKey
    ELSEIF event:className() == "HTKEYEVENT"
        ? "Key event:", event:key
    ENDIF
ENDIF
```

### run( oTarget, bCondition )

Core event loop. Polls for events and dispatches them to the target widget until the condition returns `.F.`

```harbour
/* Run until dialog closes */
HTEventLoop():run( oDialog, {|| oDialog:isRunning() } )

/* Run until flag is cleared */
LOCAL lRunning := .T.
HTEventLoop():run( oWidget, {|| lRunning } )
```

Events are dispatched via `oTarget:event(event)` which routes to the appropriate handler based on event type (keyEvent, mouseEvent, paintEvent, etc.).

### schedule( bTask, nDelayMs ) → nTaskId

Schedules a one-shot callback to execute after a delay. Returns a task ID for cancellation.

```harbour
/* Show a message after 5 seconds */
LOCAL nId := HTEventLoop():schedule( {|| HTToast():show("Reminder!") }, 5000 )

/* Cancel before it fires */
HTEventLoop():cancelTask( nId )
```

Tasks execute inside `poll()` on each event loop iteration. Resolution is ~50ms (the default poll timeout). Tasks run on the main thread — they should be fast and non-blocking.

### scheduleRepeat( bTask, nIntervalMs ) → nTaskId

Schedules a repeating callback at a fixed interval.

```harbour
/* Auto-refresh data every 30 seconds */
LOCAL nId := HTEventLoop():scheduleRepeat( {|| brw:refreshAll() }, 30000 )

/* Stop the repeating task */
HTEventLoop():cancelTask( nId )
```

### cancelTask( nTaskId )

Cancels a pending scheduled or repeating task by its ID.

## Event Types

All events inherit from `HTEvent` (which uses `HB_CLS_NOTOBJECT` for lightweight instances). Check event type with `event:className()`:

| Event Class | Type Constant | Dispatched To |
|-------------|--------------|---------------|
| `HTKeyEvent` | `HT_EVENT_TYPE_KEYBOARD` | `widget:keyEvent(event)` |
| `HTMouseEvent` | `HT_EVENT_TYPE_MOUSE` | `widget:mouseEvent(event)` |
| `HTPaintEvent` | `HT_EVENT_TYPE_PAINT` | `widget:paintEvent(event)` |
| `HTFocusEvent` | `HT_EVENT_TYPE_FOCUSIN/OUT` | `widget:focusInEvent/focusOutEvent(event)` |
| `HTCloseEvent` | `HT_EVENT_TYPE_CLOSE` | `widget:closeEvent(event)` |
| `HTMoveEvent` | `HT_EVENT_TYPE_MOVE` | `widget:moveEvent(event)` |
| `HTResizeEvent` | `HT_EVENT_TYPE_RESIZE` | `widget:resizeEvent(event)` |
| `HTShowEvent` | `HT_EVENT_TYPE_SHOW` | `widget:showEvent(event)` |

### HTKeyEvent Properties

| Property | Description |
|----------|-------------|
| `key` | Harbour key code (K_UP, K_ENTER, K_ESC, etc.) |
| `nKey` | Same as `key` (alias) |

### HTMouseEvent Properties

| Property | Description |
|----------|-------------|
| `nKey` | Mouse event code (K_LBUTTONDOWN, K_LBUTTONUP, K_MOUSEMOVE, etc.) |
| `mouseRow` | Row relative to the CT window selected when the event was created (READWRITE — recaptured by the application relative to the target window) |
| `mouseCol` | Column relative to the CT window selected when the event was created (READWRITE — recaptured by the application relative to the target window) |
| `mouseAbsRow` | Screen-absolute row captured at creation, immune to wFormat margin state |
| `mouseAbsCol` | Screen-absolute column captured at creation, immune to wFormat margin state |

## Event Routing

### Main Application Loop

`HTApplication:exec()` routes events from `poll()` to the correct top-level window:

- **Mouse clicks** (K_LBUTTONDOWN, K_LBUTTONUP, K_RBUTTONDOWN): routed to the window under the cursor via `ht_windowAtMousePos()`. The CT window system determines which window is at the mouse position. Clicks falling on unregistered CT windows (e.g., menu dropdown windows) fall back to the active window.
- **Keyboard events**: routed to the active (focused) window via `HTApplication():activeWindow()`.
- **Mouse movement** (K_MOUSEMOVE): routed to the active window (not the window under cursor).

ALL mouse events (clicks and moves) have their `mouseRow`/`mouseCol` recaptured using screen-absolute coordinates: `event:mouseRow := event:mouseAbsRow - wRow()`, `event:mouseCol := event:mouseAbsCol - wCol()`. This is immune to wFormat margin state from stale wSelect context.

### Event Priority Queue

Events are processed by priority each frame:

| Priority | Constant | Used For |
|----------|----------|----------|
| HIGH (1) | `HT_EVENT_PRIORITY_HIGH` | System events (close, maximize) |
| NORMAL (2) | `HT_EVENT_PRIORITY_NORMAL` | User input (keyboard, mouse) |
| LOW (3) | `HT_EVENT_PRIORITY_LOW` | Deferred events (initial paint, focus, show) |

`widget:show()` queues paint, focus, and show events at LOW priority so that any pending move/resize events are processed first.

### Widget Event Dispatch

When a widget receives an event via `widget:event(event)`:

1. The event type determines the handler method (keyEvent, mouseEvent, etc.)
2. If the handler doesn't accept the event, it **propagates to the parent** widget
3. This enables event bubbling — unhandled keys travel up the widget tree

## Keyboard Event Flow

```
keyEvent(event) on top-level window
  │
  ├── 1. Menu bar gets first chance (F10, Alt+letter shortcuts)
  │
  ├── 2. Per-window key bindings (registered via onKey())
  │      win:onKey( K_F1, {|| ShowHelp() } )
  │
  ├── 3. Tab/Shift+Tab → focusNextChild()/focusPrevChild()
  │      Sends focusOutEvent to old widget, focusInEvent to new widget
  │      VALID blocks can reject focus change (keeps current widget)
  │
  └── 4. Dispatch to focused child widget
         child:keyEvent(event)
         └── Child can accept or let it propagate back up
```

## Mouse Event Flow

```
mouseEvent(event) on top-level window
  │
  ├── K_LBUTTONDOWN
  │    ├── Check if dropdown menu is open → route ALL clicks to menuBar:handleMouseClick()
  │    ├── Check menu bar click (content row 0) → menuBar:handleClick()
  │    ├── Check system buttons (close ■, hide ■, maximize ■)
  │    ├── Check title bar → start window drag (FwinSysBtnMove)
  │    ├── Hit-test children via childAt(row, col)
  │    │    └── Reverse order, recurses into layout containers
  │    ├── Transfer focus to clicked child
  │    └── Dispatch mouse event to child (with translated coords)
  │
  ├── K_LBUTTONUP
  │    ├── Fire close/hide/maximize if button was pressed
  │    └── Reset all button state flags
  │
  ├── K_MOUSEMOVE
  │    └── If FwinSysBtnMove: wMove(mouseAbsRow - clickOffsetY, mouseAbsCol - clickOffsetX)
  │         (screen-absolute positioning, no delta accumulation)
  │
  └── K_RBUTTONDOWN
       └── Show context menu on child or self
```

### Menu Bar Mouse Support

The menu bar responds to mouse clicks in addition to F10/keyboard:

- **Click on menu title**: `menuBar:handleClick(nRow, nCol)` opens/closes the dropdown
- **Click on dropdown item**: `menuBar:handleMouseClick(nAbsRow, nAbsCol)` triggers the action
- **Click outside**: closes the dropdown

When a dropdown is open, ALL mouse clicks are intercepted by `handleMouseClick()` before normal child hit-testing. Clicks on unregistered CT windows (the dropdown window) fall back to the active window in `HTApplication:exec()`.

## Focus System

### Focus Chain

```
HTApplication → activeWindow() → window:focusWidget() → child:focusWidget() → ...
                                                          (skips layout containers)
```

Each widget tracks its focused child via `FfocusWidget`. `hasFocus()` walks up the parent chain to the first ancestor with a CT window (`windowId != NIL`), skipping layout containers which don't participate in the focus system.

`focusableChildren()` recurses into layout containers (children with no `windowId`) to find nested focusable widgets. Similarly, `childAt()` recurses into containers for mouse hit-testing.

### Focus Policies

| Policy | Constant | Tab? | Click? |
|--------|----------|------|--------|
| None | `HT_FOCUS_NONE` | No | No |
| Tab only | `HT_FOCUS_TAB` | Yes | No |
| Click only | `HT_FOCUS_CLICK` | No | Yes |
| Strong | `HT_FOCUS_STRONG` | Yes | Yes |

### Focus Transfer

**Tab navigation:**
1. `focusOutEvent` fires on old widget (with `FfocusWidget := NIL` so `hasFocus()` returns `.F.` during repaint)
2. If VALID block returns `.F.`, focus stays on current widget (re-activated via `focusInEvent`)
3. Otherwise, `focusInEvent` fires on new widget

**Mouse click:**
1. Same flow but VALID blocks are bypassed (Clipper convention — mouse always transfers focus)

## Modal Dialogs

### HTDialog

```harbour
LOCAL dlg := HTDialog():new()
dlg:setWindowTitle( " Confirm " )
dlg:move( 10, 5 )
dlg:resize( 30, 8 )

HTLabel():new( "Are you sure?", dlg ):setGeometry( 2, 2, 20, 1 )
dlg:addButtonBar( "OK", "Cancel" )

IF dlg:exec() == HT_DIALOG_ACCEPTED
    /* User clicked OK or pressed Enter */
ENDIF
```

**Important:** Use `setGeometry()` (not `move()`/`resize()`) for child widgets inside a dialog — `move()`/`resize()` queue events that won't be processed before the dialog paints.

`exec()` uses `HTEventLoop:run()` which provides full mouse tracking, keyboard handling, and task scheduling. Dialog windows can be dragged by their title bar.

### HTMessageBox

```harbour
HTMessageBox():information( "Title", "Message" )
HTMessageBox():warning( "Title", "Warning text" )

IF HTMessageBox():question( "Title", "Proceed?" ) == HT_DIALOG_ACCEPTED
    /* User clicked OK */
ENDIF
```

### HTToast (Non-blocking Notifications)

```harbour
HTToast():show( "Saved!", 3000, HT_CLR_TOAST_SUCCESS )
HTToast():show( "Error!", 5000, HT_CLR_TOAST_ERROR )
HTToast():dismissAll()
```

Toasts auto-dismiss after the specified duration. Multiple toasts stack vertically from the bottom-right corner. They don't steal focus.

## Task Scheduling

Use `HTEventLoop` for deferred and repeating tasks:

```harbour
/* One-shot: run after 2 seconds */
HTEventLoop():schedule( {|| RefreshStatus() }, 2000 )

/* Repeating: run every 10 seconds */
LOCAL nTimerId := HTEventLoop():scheduleRepeat( {|| PollServer() }, 10000 )

/* Cancel a repeating task */
HTEventLoop():cancelTask( nTimerId )
```

**Task resolution:** Tasks are checked on each `poll()` call (~50ms default timeout). Precision is ±50ms for one-shot tasks and ±50ms jitter for repeating tasks.

**Thread safety:** All tasks run on the main thread. Keep task callbacks fast — long-running tasks block the event loop and freeze the UI.

### Common Patterns

**Debounced search:**
```harbour
STATIC nSearchTask := 0

PROCEDURE OnSearchChanged( cText )
    /* Cancel previous search, schedule new one */
    IF nSearchTask > 0
        HTEventLoop():cancelTask( nSearchTask )
    ENDIF
    nSearchTask := HTEventLoop():schedule( {|| RunSearch( cText ) }, 500 )
RETURN
```

**Auto-save:**
```harbour
HTEventLoop():scheduleRepeat( {|| SaveDraft() }, 60000 )  /* every 60 seconds */
```

**Progress animation:**
```harbour
LOCAL nAnim := HTEventLoop():scheduleRepeat( {|| ;
    oProgress:setValue( oProgress:value + 1 ), ;
    IF( oProgress:value >= 100, HTEventLoop():cancelTask( nAnim ), NIL ) ;
}, 100 )
```

## Coordinate Spaces

| Space | Functions | Range | Use |
|-------|-----------|-------|-----|
| Screen absolute | `mRow(.T.)`, `wRow()`, `wCol()` | 0..MaxRow/MaxCol | Window positioning (wOpen, wMove) |
| Window-relative | `mRow()`, `mCol()` (with wSelect) | 0..window dims | Hit-testing, mouse event coords |
| Content-area | `child:x`, `child:y` | Inside border | Widget positioning in parent |
| Viewport | `MaxRow()`, `MaxCol()` in `wFormat()` | Varies | Widget painting inside paintChild |

**Key rules:**
- `wFormat()` with no args resets margins to (0,0,0,0)
- `wFormat(t,l,b,r)` is **additive** to current margins
- `wMove(row, col)` takes **absolute** screen position (not delta)
- After `wBox()` + `wFormat()` reset, window margins are (0,0,0,0)
- `HTMouseEvent:mouseRow/mouseCol` are captured at event creation time, relative to the window selected at that moment

**Viewport stack (`ht_wFormatPush()`/`ht_wFormatPop()`):** CT's `wFormat()` no-args reset destroys ALL margins including parent viewports. `ht_wFormatPush`/`Pop` provides proper nested viewport stacking — push adds margins and saves them on a stack, pop undoes only the last push. Used by `paintChild()` for nested widget viewports. Includes stack underflow detection via debug log.

**Container margins:** Layout containers (widgets without a CT window, created by `addLayout()`) use zero-based margins in `paintChild()` — no +1 border offset. Their `displayLayout()` uses full `Fwidth`/`Fheight` instead of subtracting 2 for borders. `repaintChild()` delegates upward to the parent window since containers have no CT window to select.

## Debug Logging

Enable debug output to trace event flow:

```harbour
HTApplication():setDebug( .T. )
```

Run with stderr capture:
```bash
./myapp 2>debug.log
```

Log messages include timestamps and trace widget lifecycle, event dispatch, and error conditions.
