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
- Keep Org mode (`+pretty +pomodoro`).
- Keep completion modules:
  - `company` (`+childframe`)
  - `vertico` (`+icons`)
- Keep UI modules:
  - `doom`
  - `hl-todo`
  - `indent-guides`
  - `modeline`
  - `ophints`
  - `popup`
  - `unicode`
  - `vi-tilde-fringe`
  - `workspaces`
- Keep editor modules:
  - `evil`
  - `fold`
  - `format`
  - `multiple-cursors`
- Keep tool modules:
  - `editorconfig`
  - `lookup`
  - `lsp` (`+eglot`)
  - `magit`
- Keep no checker modules. In-editor diagnostics are intentionally disabled:
  `:checkers syntax` is off and Eglot stays out of Flymake. Errors are surfaced
  by running `cargo check`/`clippy` and other build commands manually.
- Keep no input modules.
- Keep no app modules.
- Keep language support, all using their classic (non-tree-sitter) major modes:
  - C/C++ (`cc`) -> `c-mode` / `c++-mode`
  - Go (`go`) -> `go-mode`
  - Julia (`julia`) -> `julia-mode`
  - LaTeX (`latex`)
  - Python (`python`) -> `python-mode`
  - Racket (`racket`) -> `racket-mode`
  - Rust (`rust`) -> `rustic-mode`

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
  - `ligatures`
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
  - `syntax` (no in-editor diagnostics; see "Keep no checker modules" above)
- Remove unused editor modules:
  - `file-templates`
  - `god`
  - `lispy`
  - `objed`
  - `parinfer`
  - `rotate-text`
  - `snippets`
  - `whitespace`
  - `word-wrap`
- Remove unused tool modules:
  - `debugger`
  - `direnv`
  - `docker`
  - `eval`
  - `llm`
  - `make`
  - `tmux`
  - `tree-sitter`
- Remove tree-sitter entirely (the `:tools tree-sitter` module and every
  language's `+tree-sitter` flag). This Emacs links against
  `libtree-sitter >= 0.25` (homebrew 0.26), which is incompatible with Emacs
  30.2's `treesit.c`: every `#match`/`#equal` query predicate fails to compile,
  breaking `*-ts-mode` font-lock for all grammars. Tree-sitter is an external
  tool whose version keeps drifting and re-breaking this pairing, so instead of
  carrying per-language Lisp workarounds, every language uses its classic regex
  `font-lock` major mode. The color theme styles the same faces, and LSP still
  provides all semantics (completion, navigation, inlay hints).
- Remove Doom Python integration for package/environment managers other than
  `uv`.
- Remove Python test framework helpers that are not part of the requested
  minimal baseline.

## Python Scope

The Python module keeps:

- Built-in `python-mode` / `python-ts-mode` integration.
- REPL helpers.
- `+uv` support through `uv-mode`.

The Python module is intentionally `+uv` only (no `+lsp`). Doom's LSP startup
hooks are removed in `config.el` and Python is dropped from
`eglot-server-programs`, so no language server starts for Python buffers.
Editing relies on built-in completion plus `uv run`.

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
