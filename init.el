;;; init.el -*- lexical-binding: t; -*-

;; Configure leader keys before Doom initializes keymaps.
(setq doom-localleader-key ","
      doom-localleader-alt-key "M-,")

;; This file controls what Doom modules are enabled and what order they load
;; in. Remember to run 'doom sync' after modifying it!

;; NOTE Press 'SPC h d h' (or 'C-h d h' for non-vim users) to access Doom's
;;      documentation. There you'll find a link to Doom's Module Index where all
;;      of our modules are listed, including what flags they support.

;; NOTE Move your cursor over a module's name (or its flags) and press 'K' (or
;;      'C-c c k' for non-vim users) to view its documentation. This works on
;;      flags as well (those symbols that start with a plus).
;;
;;      Alternatively, press 'gd' (or 'C-c c d') on a module to browse its
;;      directory (for easy access to its source code).

(doom! :input
       :completion
       (company +childframe)           ; the ultimate code completion backend
       (vertico +icons)           ; the search engine of the future

       :ui
       doom              ; what makes DOOM look the way it does
       hl-todo           ; highlight TODO/FIXME/NOTE/DEPRECATED/HACK/REVIEW
       indent-guides     ; highlighted indent columns
       modeline          ; snazzy, Atom-inspired modeline, plus API
       ophints           ; highlight the region an operation acts on
       (popup +defaults)   ; tame sudden yet inevitable temporary windows
       unicode           ; extended unicode support for various languages
       (vc-gutter +pretty) ; vcs diff in the fringe
       vi-tilde-fringe   ; fringe tildes to mark beyond EOB
       ;;window-select     ; visually switch windows
       workspaces        ; tab emulation, persistence & separate workspaces
       ;;zen               ; distraction-free coding or writing

       :editor
       (evil +everywhere); come to the dark side, we have cookies
       fold              ; (nigh) universal code folding
       (format +onsave)  ; automated prettiness
       multiple-cursors  ; editing in many places at once
       ;;snippets          ; snippet expansion

       :emacs
       dired             ; making dired pretty [functional]
       ;; electric          ; smarter, keyword-based electric-indent
       ;;ibuffer         ; interactive buffer management
       undo              ; persistent, smarter undo for your inevitable mistakes
       ;;vc                ; version-control and Emacs, sitting in a tree

       :term
       ;; eshell            ; the elisp shell that works everywhere
       ;;shell             ; simple shell REPL for Emacs
       ;;term              ; basic terminal emulator for Emacs
       ;; vterm             ; the best terminal emulation in Emacs

       :checkers
       ;; (syntax +flymake)

       :tools
       editorconfig      ; let someone else argue about tabs vs spaces
       (eval +overlay)   ; run code, run (also, repl) ; gives gr/gR send-to-eval
       lookup              ; navigate your code and its documentation
       (lsp +eglot)               ; M-x vscode
       magit             ; a git porcelain for Emacs

       :os
       (:if IS-MAC macos)  ; improve compatibility with macOS
       tty               ; improve the terminal Emacs experience

       :lang
       (cc
        +lsp
        )
       (go
        +lsp
        )
       (julia
        +lsp
        )
       (latex
        +fold
        +lsp
        )
       (org
        +pretty
        +pomodoro
       )
       (python
        +uv
        )
       (racket
        +lsp
        )
       (rust
        +lsp
        )

       :app

       :config
       ;;literate
       (default +bindings +smartparens))
