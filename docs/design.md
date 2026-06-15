# Minimal Doom Emacs Design

## Goal

Build a personal, minimal Doom Emacs fork that keeps Doom's core editing model
and keybinding ergonomics while removing language modules and Python tooling that
are not part of the user's workflow.

This fork is expected to diverge from upstream Doom Emacs. Compatibility with
future upstream module additions is not a design goal.

## Kept Behavior

- Keep Doom leader bindings, including `SPC`.
- Keep `doom-localleader-key` configured as `,`.
- Keep Evil as the primary editing model.
- Keep the default Doom binding/smartparens layer.
- Keep Org mode.
- Keep completion modules:
  - `company`
  - `corfu`
  - `vertico`
- Keep UI modules:
  - `doom`
  - `hl-todo`
  - `indent-guides`
  - `ligatures`
  - `modeline`
  - `ophints`
  - `popup`
  - `unicode`
  - `vi-tilde-fringe`
  - `workspaces`
- Keep checker modules:
  - `syntax`
- Keep editor modules:
  - `evil`
  - `fold`
  - `format`
  - `multiple-cursors`
  - `snippets`
- Keep no input modules.
- Keep no app modules.
- Keep language support for:
  - C/C++ (`cc`)
  - Go (`go`)
  - Julia (`julia`)
  - LaTeX (`latex`)
  - Python (`python`)
  - Racket (`racket`)
  - Rust (`rust`)

## Removed Behavior

- Remove language module source directories that are not explicitly listed
  above.
- Remove Doom's email module family entirely.
- Remove unneeded tool modules:
  - `ansible`
  - `biblio`
  - `collab`
  - `ein`
  - `pass`
  - `pdf`
  - `terraform`
  - `upload`
- Remove unused completion modules:
  - `helm`
  - `ido`
  - `ivy`
- Remove unused UI modules:
  - `dashboard`
  - `doom-dashboard`
  - `deft`
  - `doom-quit`
  - `emoji`
  - `minimap`
  - `nav-flash`
  - `neotree`
  - `smooth-scroll`
  - `tabs`
  - `treemacs`
  - `vc-gutter`
  - `window-select`
  - `zen`
- Remove unused input modules:
  - `bidi`
  - `chinese`
  - `japanese`
  - `layout`
- Remove unused app modules:
  - `calendar`
  - `emms`
  - `everywhere`
  - `irc`
  - `rss`
- Remove unused checker modules:
  - `grammar`
  - `spell`
- Remove unused editor modules:
  - `file-templates`
  - `god`
  - `lispy`
  - `objed`
  - `parinfer`
  - `rotate-text`
  - `whitespace`
  - `word-wrap`
- Remove Doom Python integration for package/environment managers other than
  `uv`.
- Remove Python test framework helpers that are not part of the requested
  minimal baseline.

## Python Scope

The Python module keeps:

- Built-in `python-mode` / `python-ts-mode` integration.
- REPL helpers.
- `+uv` support through `uv-mode`.
- LSP integration through Doom's existing `:tools lsp +eglot` path.

The Python module removes:

- `pip-requirements`
- `pipenv`
- `pyvenv`
- `pyenv-mode`
- `conda`
- `poetry`
- `nose`
- `python-pytest`
- `cython-mode`
- `flycheck-cython`

## Verification

The change is considered valid when:

- `init.el` enables only the requested language modules.
- `/Users/hal/.config/emacs/modules/lang` contains only the kept language
  module directories plus root metadata files.
- The Python module no longer references removed package managers or test helper
  packages in package declarations, configuration, autoloads, or doctor checks.
- `doom sync` completes successfully.
