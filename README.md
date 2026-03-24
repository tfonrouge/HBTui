# HBTui

Text User Interface controls library for the [Harbour](https://harbour.github.io/) compiler. Uses the CT (Clipper Tools) window system for windowing with viewport-based coordinate isolation, giving each widget its own local coordinate space.

## Features

**25+ widgets** covering forms, data display, navigation, and feedback:

| Category | Widgets |
|----------|---------|
| Windows | HTMainWindow, HTDesktop, HTDialog (modal + button bar + draggable), HTMessageBox |
| Input | HTLineEdit (selection + clipboard), HTGet (full PICTURE/VALID/WHEN), HTTextEdit (multi-line editor with multi-line selection), HTSpinner (mouse-clickable arrows), HTCheckList |
| Buttons | HTPushButton (keyboard + mouse click), HTCheckBox, HTRadioButton |
| Lists | HTListBox, HTComboBox (type-to-filter, modal dropdown), HTBrowse (TBrowse wrapper, inline editing, mouse column selection) |
| Menus | HTMenuBar (mouse-clickable), HTMenu (mouse item selection), HTContextMenu (right-click popup), HTAction |
| Layout | HTVBoxLayout, HTHBoxLayout (nested via addLayout), HTGridLayout (row/column spans), stretch, spacing |
| Display | HTLabel (left/center/right alignment), HTFrame, HTProgressBar, HTStatusBar, HTSeparator, HTScrollBar, HTTabWidget, HTToolBar |
| Feedback | HTToast (non-blocking notifications, auto-dismiss, stacking, 4 styles) |

**Event system** -- `HTEventLoop` singleton with unified input polling, priority queue (HIGH/NORMAL/LOW), mouse tracking with screen-absolute coordinate translation, task scheduling (`schedule`, `scheduleRepeat`, `cancelTask`), and terminal resize handling (`HB_K_RESIZE`). See [docs/EVENT_SYSTEM.md](docs/EVENT_SYSTEM.md).

**Viewport system** -- `ht_wFormatPush()`/`ht_wFormatPop()` provide proper nested viewport stacking for layout containers. CT's `wFormat()` is additive but its no-args reset destroys parent viewports; push/pop correctly preserves margins at any nesting depth.

**Theme system** -- `HTTheme` singleton with 55 color categories and four built-in themes: Default, Dark, High Contrast, Mono.

**Layout managers** -- Automatic widget arrangement with `HTVBoxLayout`, `HTHBoxLayout`, and `HTGridLayout`. Support for stretch factors, fixed spacing, nested layouts (via `addLayout` with automatic widget reparenting), and min/max size policies. Container widgets (no CT window) use zero-based margins and delegate repaint/focus upward.

**Focus system** -- Keyboard (Tab/Shift+Tab) and mouse focus traversal. `focusableChildren()` and `childAt()` recurse into layout containers. `hasFocus()` walks up to the top-level window (skipping containers). VALID blocks on HTGet enforce Tab navigation, bypass on mouse clicks (Clipper behavior).

**Window dragging** -- Screen-absolute `wMove(mouseAbsRow - clickOffsetY, mouseAbsCol - clickOffsetX)` for smooth, jitter-free window repositioning. HTDialog overrides with delta-based drag for modal windows.

**Signal/callback model** -- Harbour code blocks on widget properties: `btn:onClicked := {|| Save() }`, `brw:onActivated := {|r,c| Edit(r,c) }`, `get:onChanged := {|v| Validate(v) }`.

**Debug logging** -- `HTApplication():setDebug(.T.)` enables `ht_debugLog()` output to stderr. Capture with `./myapp 2>debug.log`.

## Quick Start

```bash
# Build the library
hbmk2 hbtui.hbp

# Build and run the Hello World sample
cd samples/hello && hbmk2 hello.prg hbmk.hbm && ./hello
```

## Samples

15 samples demonstrating individual features and a full showcase:

| Sample | Description |
|--------|-------------|
| `hello` | Minimal Hello World -- HTMainWindow + HTLabel + ESC to quit |
| `dialog` | Modal HTDialog + HTMessageBox (info/question/custom) with toast results |
| `browse` | HTBrowse data grid with inline editing, mouse column selection, context menu |
| `controls` | PushButton, CheckBox, RadioButton, Spinner (clickable ▲▼), ComboBox, ListBox |
| `get` | HTGet -- string, numeric, date PICTURE, VALID/WHEN validation |
| `grid_layout` | HTGridLayout 2D form arrangement |
| `hbox_layout` | HTHBoxLayout horizontal button bar (nested layout demo) |
| `editor` | HTLineEdit + HTTextEdit with multi-line selection and clipboard |
| `layout` | HTVBoxLayout -- spacing, stretch, nesting |
| `menu` | HTMenuBar + HTMenu -- F10, mouse click on titles and items |
| `progress` | Animated HTProgressBar with scheduleRepeat() and toast on complete |
| `helpline` | Per-widget help text in status bar via setHelpLineWidget() |
| `theme` | Theme switching -- 4 themes, F-keys + clickable buttons |
| `toast` | HTToast non-blocking notifications -- 4 styles, stacking |
| `showcase` | Full controls demo with all features |

Build any sample:

```bash
cd samples/<name> && hbmk2 <name>.prg hbmk.hbm && ./<name>
```

## Requirements

- **Harbour compiler** at `~/git/core`
- **hbct** contrib library (Clipper Tools)
- **GT driver**: `gtxwc` on Linux (X11 window), `gtwvt` on Windows
- Compiler flags: `-w3 -es2` (warnings level 3, warnings as errors)

## Architecture

```
HTBase
  HTObject (parent/child tree, addChild/removeChild public)
    HTWidget (rendering, events, focus, viewport, context menu, size policies)
      HTMainWindow, HTDesktop, HTDialog, HTMessageBox, HTToast
      HTLabel, HTLineEdit, HTTextEdit, HTGet, HTGetBackend, HTSpinner, HTCheckList
      HTListBox, HTComboBox, HTBrowse (TBrowse:hitTest for column detection)
      HTPushButton, HTCheckBox, HTRadioButton
      HTFrame, HTProgressBar, HTStatusBar, HTSeparator, HTScrollBar
      HTMenuBar (handleClick + handleMouseClick), HTMenu, HTContextMenu
      HTTabWidget, HTToolBar
      HTTheme (singleton, 4 themes, 55 colors)
    HTAction (menu item with callback)
    HTLayout -> HTHBoxLayout, HTVBoxLayout, HTGridLayout
  HTLayoutItem (alignment mixin)

HTEventLoop (singleton -- input polling + task scheduling + resize handling)
HTGetBackend (TGet subclass, suppresses display() for viewport rendering)

HTEvent (standalone, HB_CLS_NOTOBJECT)
  HTFocusEvent, HTPaintEvent, HTCloseEvent, HTShowEvent, HTHideEvent
  HTMoveEvent, HTResizeEvent, HTMaximizeEvent
  HTInputEvent -> HTKeyEvent, HTMouseEvent (mouseAbsRow/Col for screen-absolute)

HTPoint, HTSize (value types)
```

**Key patterns:**
- Each widget paints inside a CT `wFormat()` viewport via `ht_wFormatPush()`/`ht_wFormatPop()`, seeing `(0,0)` as its top-left corner
- Events flow from `HTEventLoop:poll()` through `HTApplication:exec()` to the target widget, with mouse coordinates recaptured using screen-absolute positions (`mouseAbsCol - wCol()`)
- Layout containers (no CT window) use zero-based margins in `paintChild()`, delegate `repaintChild()` upward, and reparent nested widgets via `addLayout()`
- `focusableChildren()` and `childAt()` recurse into containers for Tab navigation and mouse hit-testing

For design details see [CLAUDE.md](CLAUDE.md). For the event system see [docs/EVENT_SYSTEM.md](docs/EVENT_SYSTEM.md).

## Testing

8 headless test suites run without a display (using `gtnul`). Exit code 0 means pass.

```bash
cd tests
for t in test_basic test_layout test_theme test_widgets test_browse test_get test_eventloop test_integration; do
    hbmk2 $t.prg hbmk.hbm && ./$t
done
```

| Test | Covers |
|------|--------|
| `test_basic` | HTPoint, HTSize, all HTEvent subclasses |
| `test_layout` | HTBoxLayout, HTGridLayout item management |
| `test_theme` | HTTheme singleton, all 4 themes, invalid index fallback |
| `test_widgets` | HTLabel, HTLineEdit, HTCheckBox, HTPushButton, HTListBox, HTComboBox, HTCheckList, HTSpinner, HTProgressBar, HTScrollBar, HTTextEdit, HTContextMenu |
| `test_browse` | HTBrowse column management, navigation blocks, callbacks |
| `test_get` | HTGet setup/getValue/setValue, label/picture/width, readOnly |
| `test_eventloop` | HTEventLoop singleton, schedule, scheduleRepeat, cancelTask, runPendingTasks |
| `test_integration` | Nested layout focus, Tab cycle, reparenting, geometry, repaintChild delegation |

## License

No license file is currently included in this repository.
