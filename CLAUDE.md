# HBTui - Harbour TUI Framework

Text User Interface controls library for the Harbour compiler. Uses CT (Clipper Tools) window system for windowing, with `wFormat()` viewport-based child widget coordinate isolation.

## Build

```bash
# Build the library
hbmk2 hbtui.hbp

# Build a sample
cd samples/showcase && hbmk2 showcase.prg hbmk.hbm
```

Requires: Harbour compiler at `~/git/core`, hbct contrib library.

GT driver: `gtxwc` on Linux (X11 window), `gtwvt` on Windows.

Compiler flags: `-w3 -es2` (warnings level 3, warnings as errors).

## Architecture

### Class Hierarchy

```
HTBase
  HTObject (parent/child tree, menubar)
    HTWidget (rendering, events, focus, viewport painting)
      HTMainWindow, HTDesktop, HTDialog
      HTLabel, HTLineEdit, HTListBox, HTComboBox
      HTBrowse (TBrowse wrapper), HTEditor (legacy)
      HTAbstractButton → HTPushButton, HTCheckBox, HTRadioButton
      HTFrame, HTProgressBar, HTStatusBar, HTSeparator
      HTMenuBar, HTMenu
      HTMessageBox (singleton)
    HTAction (menu item with onTriggered callback)
    HTLayout → HTBoxLayout → HTHBoxLayout, HTVBoxLayout
               HTGridLayout
  HTLayoutItem (alignment mixin)

HTEvent (standalone, HB_CLS_NOTOBJECT)
  HTFocusEvent, HTPaintEvent, HTCloseEvent, HTShowEvent, HTHideEvent
  HTMoveEvent, HTResizeEvent, HTMaximizeEvent
  HTInputEvent → HTKeyEvent, HTMouseEvent

HTPoint, HTSize (value types, HB_CLS_NOTOBJECT)
```

### Key Design Patterns

**Viewport painting**: `paintChild()` uses `wFormat(margins)` to create a coordinate viewport per child widget. The child sees `(0,0)` to `(MaxRow(), MaxCol())` as its world. CT library transparently remaps all `DispOutAt()`/`SetPos()` calls. TBrowse works inside viewports with zero translation code.

**wFormat() is additive**: calling `wFormat(t,l,b,r)` adds to current margins. `wFormat()` with no args resets to (0,0,0,0). After `paintTopLevelWindow()`, margins are always 0. Each `paintChild()` sets margins, paints, resets.

**Event flow**: `HTApplication:exec()` → `getEvent()` (Inkey) → queue by priority (HIGH/NORMAL/LOW) → `widget:event()` → type-based dispatch → handler method. Keyboard events go to `activeWindow()`, mouse events to window under cursor.

**Focus chain**: `HTWidget:FfocusWidget` tracks the focused child. Tab/Shift+Tab cycles via `focusNextChild()`/`focusPrevChild()`. Mouse click focuses via `childAt()` hit-testing. Focus policy: NONE/TAB/CLICK/STRONG.

**Signal/callbacks**: Harbour code blocks on widget properties. `btn:onClicked := {|| Save() }`, `chk:onToggled := {|l| ... }`, `cmb:onChanged := {|n| ... }`, `brw:onActivated := {|r,c| ... }`, `action:onTriggered := {|| ... }`.

**Targeted repaint**: `parent:repaintChild(self)` repaints a single child without clearing the entire window. Used by all controls for state changes.

### Coordinate Convention

`move(x, y)` where **x = column, y = row**. `HTPoint(x, y)` same. `wOpen(top, left, bottom, right)` takes row-first. In `paintTopLevelWindow()`, `wOpen(::Fx, ::Fy, ...)` passes x(col) as top(row) — this works because `move()` stores x=col in Fx, and the window position happens to be correct, but the naming is misleading.

### Property System

`include/property.ch` defines PROPERTY macros. Key patterns:
- `PROPERTY name INIT value` → read-only with DATA Fname PROTECTED
- `PROPERTY name WRITE setter INIT value` → WRITE keyword BEFORE INIT
- `PROPERTY name READ getter WRITE setter` → custom accessors

### Harbour Gotchas

- `LOCAL` declarations MUST come before any executable statements
- `wFormat()` without args resets margins (gets current, negates, adds back)
- `wFormat()` with args is additive to current margins
- `DATA Ftype INIT value` in subclass overrides parent's INIT value
- `-es2` flag treats warnings as errors — unused variables/params will fail build
- `K_HOME = K_CTRL_A = 1` — same key code, can't have both in SWITCH

## Source Layout

```
include/          hbtui.ch (constants), property.ch (macros)
src/              Core classes, layouts, C API
src/HTEvent/      Event classes
src/HTWidget/     Widget classes
src/types/        HTPoint, HTSize, HT
samples/          Demo applications
  showcase/       Full controls demo (showcase.prg)
  controls/       Controls demos (controls_01, controls_02)
  hello/          Basic window
  menu/           Menu demo
```
