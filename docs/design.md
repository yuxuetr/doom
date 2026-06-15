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
