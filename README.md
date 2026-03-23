# HBTui

Text User Interface controls library for the [Harbour](https://harbour.github.io/) compiler. Uses the CT (Clipper Tools) window system for windowing with viewport-based coordinate isolation, giving each widget its own local coordinate space.

## Features

**25+ widgets** covering forms, data display, navigation, and feedback:

| Category | Widgets |
|----------|---------|
| Windows | HTMainWindow, HTDesktop, HTDialog (modal + button bar), HTMessageBox |
| Input | HTLineEdit (selection + clipboard), HTGet (full PICTURE/VALID/WHEN), HTTextEdit (multi-line editor), HTSpinner, HTCheckList |
| Buttons | HTPushButton, HTCheckBox, HTRadioButton |
| Lists | HTListBox, HTComboBox (type-to-filter), HTBrowse (TBrowse wrapper, inline editing) |
| Menus | HTMenuBar, HTMenu, HTContextMenu (right-click popup), HTAction |
| Layout | HTVBoxLayout, HTHBoxLayout, HTGridLayout (row/column spans), stretch, spacing |
| Display | HTLabel, HTFrame, HTProgressBar, HTStatusBar, HTSeparator, HTScrollBar, HTTabWidget, HTToolBar |
| Feedback | HTToast (non-blocking notifications, auto-dismiss, stacking) |

**Event system** -- `HTEventLoop` singleton with unified input polling, priority queue (HIGH/NORMAL/LOW), mouse tracking, and task scheduling (`schedule`, `scheduleRepeat`, `cancelTask`). See [docs/EVENT_SYSTEM.md](docs/EVENT_SYSTEM.md) for the full guide.

**Theme system** -- `HTTheme` singleton with 50+ color categories and four built-in themes: Default, Dark, High Contrast, Mono.

**Layout managers** -- Automatic widget arrangement with `HTVBoxLayout`, `HTHBoxLayout`, and `HTGridLayout`. Support for stretch factors, fixed spacing, nested layouts, and min/max size policies.

**Signal/callback model** -- Harbour code blocks on widget properties: `btn:onClicked := {|| Save() }`, `brw:onActivated := {|r,c| Edit(r,c) }`.

## Quick Start

```bash
# Clone
git clone https://github.com/tfonrouge/HBTui

# Build the library
hbmk2 hbtui.hbp

# Build and run the Hello World sample
cd samples/hello && hbmk2 hello.prg hbmk.hbm && ./hello
```

## Samples

| Sample | Description |
|--------|-------------|
| `hello` | Minimal Hello World -- HTMainWindow + HTLabel |
| `dialog` | Modal HTDialog + HTMessageBox (info/question/custom) |
| `browse` | HTBrowse data grid with context menu and navigation |
| `controls` | PushButton, CheckBox, RadioButton, Spinner, ComboBox, ListBox |
| `get` | HTGet demo -- string, numeric, date PICTURE, validation |
| `grid_layout` | HTGridLayout 2D form arrangement |
| `editor` | HTLineEdit + HTTextEdit with clipboard support |
| `layout` | HTVBoxLayout demo -- spacing, stretch, nesting |
| `menu` | HTMenuBar + HTMenu + HTAction with keyboard shortcuts |
| `theme` | Theme switching demo -- 4 themes, F-keys + buttons |
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
  HTObject (parent/child tree, destroy/removeChild)
    HTWidget (rendering, events, focus, viewport, context menu, size policies)
      HTMainWindow, HTDesktop, HTDialog, HTMessageBox, HTToast
      HTLabel, HTLineEdit, HTTextEdit, HTGet, HTSpinner, HTCheckList
      HTListBox, HTComboBox, HTBrowse
      HTPushButton, HTCheckBox, HTRadioButton
      HTFrame, HTProgressBar, HTStatusBar, HTSeparator, HTScrollBar
      HTMenuBar, HTMenu, HTContextMenu, HTTabWidget, HTToolBar
      HTTheme (singleton, 4 themes)
    HTAction (menu item with callback)
    HTLayout -> HTHBoxLayout, HTVBoxLayout, HTGridLayout

HTEventLoop (singleton -- input polling + task scheduling)

HTEvent -> HTKeyEvent, HTMouseEvent, HTFocusEvent, HTPaintEvent,
           HTCloseEvent, HTShowEvent, HTResizeEvent, HTMoveEvent
```

Each widget paints inside a CT `wFormat()` viewport, seeing `(0,0)` as its top-left corner. Events flow from `HTEventLoop:poll()` through `HTApplication:exec()` to the target widget, with unhandled events bubbling up the parent chain.

For design details see [CLAUDE.md](CLAUDE.md). For the event system see [docs/EVENT_SYSTEM.md](docs/EVENT_SYSTEM.md).

## Testing

Six headless test suites run without a display (using `gttrm`). Exit code 0 means pass.

```bash
cd tests
for t in test_basic test_layout test_theme test_widgets test_browse test_get; do
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

## License

No license file is currently included in this repository.
