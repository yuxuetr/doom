;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;;;; Identity
(setq user-full-name "yuxuetr"
      user-mail-address "54.yeying@gmail.com")

;;;; UI & Fonts
(setq doom-theme 'doom-monokai-pro)
(setq display-line-numbers-type t)

(setq doom-font (font-spec :family "Monaco Nerd Font" :size 20)
      doom-variable-pitch-font (font-spec :family "Monaco Nerd Font")
      doom-symbol-font (font-spec :family "Monaco Nerd Font" :size 16)
      doom-big-font (font-spec :family "Monaco Nerd Font" :size 18))

;; 解决图标显示为随机汉字的问题
(defun setup-font-symbols (frame)
  (set-fontset-font t '(#xe000 . #xf8ff) (font-spec :family "Monaco Nerd Font") frame 'prepend)
  (set-fontset-font t '(#xf0000 . #xfffff) (font-spec :family "Monaco Nerd Font") frame 'prepend))

(add-hook 'after-make-frame-functions #'setup-font-symbols)
;; 同时也为当前已经打开的 frame 设置
(setup-font-symbols nil)

(after! org-modern
  (setq org-modern-star 'replace
        org-modern-checkbox nil
        ;; org-modern-replace-stars '("ஐ" "൬" "က" "ಇ" "დ" "๓")
        org-modern-replace-stars '("❀" "♪" "♩" "の")))

;; Frame Settings
(after! doom
  (setq initial-frame-alist
        '((right . 0)
          (top . 0)
          (width . 120)
          (height . 80))))

;;;; Editor & Indentation
(setq-default tab-width 2
              standard-indent 2
              indent-tabs-mode nil
              electric-indent-mode t
              auto-fill-function 'do-auto-fill)

(setq default-directory "~/")

;;;; Recent Files
(after! recentf
  ;; `SPC f r' is `consult-recent-file' under Vertico. Preload recentf shortly
  ;; after startup so the key press does not pay the load/read cost.
  (setq recentf-auto-cleanup 'never
        recentf-max-saved-items 100)
  (add-to-list 'recentf-exclude
               (rx (or "/.git/" "/.local/cache/" "/.local/state/"))))

(add-hook! 'doom-first-input-hook
  (defun my/preload-recent-file-ui-h ()
    "Warm up recent file UI after startup."
    (run-with-idle-timer
     1 nil
     (lambda ()
       (require 'recentf)
       (recentf-mode 1)))
    (run-with-idle-timer
     2 nil
     (lambda ()
       (require 'consult nil t)))))

;; Evil Mode Tweaks
(after! evil
  (setq evil-shift-width 2
        evil-indent-level 2
        evil-auto-indent t
        evil-esc-delay 0.01
        evil-backspace-join-lines nil))
(setq evil-snipe-override-evil-repeat-keys nil)

;; Apply 2-space indentation to all programming modes
(setq-hook! 'prog-mode-hook
  tab-width 2
  evil-shift-width 2
  evil-indent-level 2)

;; Fix 'o' command indentation in evil
(after! evil
  (defun my/evil-open-below-with-indent ()
    "Open a new line below with proper indentation."
    (interactive)
    (let ((indent (current-indentation)))
      (end-of-line)
      (newline)
      (indent-to indent)
      (evil-insert-state)))

(evil-define-key 'normal 'prog-mode-map "o" #'my/evil-open-below-with-indent)
  (evil-define-key 'normal 'text-mode-map "o" #'my/evil-open-below-with-indent))

;;;; Org Mode
(setq org-directory "~/org/")

(defun my/org-week-start-time (&optional time)
  "Return the Monday start time for TIME's ISO week."
  (let* ((time (or time (current-time)))
         (weekday (string-to-number (format-time-string "%u" time))))
    (time-subtract time (days-to-time (1- weekday)))))

(defun my/org-week-date (week-start day-offset)
  "Return an Org date string for DAY-OFFSET from WEEK-START."
  (format-time-string "%Y-%m-%d" (time-add week-start (days-to-time day-offset))))

(defun my/org-weekly-task-file (&optional time)
  "Return this week's task file path, creating it if needed."
  (let* ((week-id (format-time-string "%G-W%V" (or time (current-time))))
         (week-dir (expand-file-name "weeks" org-directory))
         (file (expand-file-name (concat week-id ".org") week-dir)))
    (unless (file-exists-p file)
      (make-directory week-dir t)
      (write-region (my/org-weekly-task-template week-id (or time (current-time))) nil file))
    file))

(defun my/org-weekly-task-template (week-id time)
  "Build a weekly task template for WEEK-ID around TIME."
  (format "#+title: 真男人迷恋自律
#+startup: overview
#+todo: TODO(t) NEXT(n) WAIT(w) | DONE(d) CANCELLED(c)
#+tags: work(w) deep(d) admin(a) meeting(m) review(r) blocked(b)

* TODO 待办事项
"))

(defun my/org-goto-heading (heading)
  "Open this week's task file and move point to HEADING."
  (find-file (my/org-weekly-task-file))
  (goto-char (point-min))
  (unless (re-search-forward (format "^\\*+ %s$" (regexp-quote heading)) nil t)
    (goto-char (point-max))
    (unless (bolp)
      (insert "\n"))
    (insert "\n* " heading "\n"))
  (org-end-of-subtree t t))

(defun my/org-capture-weekly-inbox ()
  "Capture into this week's Inbox."
  (my/org-goto-heading "Inbox"))

(defun my/org-capture-this-week ()
  "Capture into this week's task list."
  (my/org-goto-heading "This Week"))

(defun my/open-weekly-tasks ()
  "Open this week's task file."
  (find-file (my/org-weekly-task-file))
  (setq-local default-directory (expand-file-name "~/")))

(add-hook 'emacs-startup-hook #'my/open-weekly-tasks)

(after! org
  (setq org-agenda-files (list (my/org-weekly-task-file))
        org-log-done 'time
        org-log-into-drawer t
        org-clock-persist 'history
        org-clock-report-include-clocking-task t
        org-enforce-todo-checkbox-dependencies t
        org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "WAIT(w@/!)" "|" "DONE(d!)" "CANCELLED(c@)"))
        org-refile-targets
        '((org-agenda-files :maxlevel . 3))
        org-capture-templates
        '(("t" "Task inbox" entry
           (function my/org-capture-weekly-inbox)
           "* TODO %?\n  %U\n  :PROPERTIES:\n  :Effort:   0:25\n  :END:\n")
          ("w" "This week task" entry
           (function my/org-capture-this-week)
           "* TODO %?\n  %U\n  :PROPERTIES:\n  :Effort:   0:45\n  :END:\n")))

  (org-clock-persistence-insinuate))

(use-package! org-pomodoro
  :after org
  :config
  (setq org-pomodoro-length 45
        org-pomodoro-short-break-length 5
        org-pomodoro-long-break-length 15
        org-pomodoro-long-break-frequency 4))

;;;; Languages & Tools

(after! treesit
  ;; Doom installs grammars under its profile data dir, but making the path
  ;; explicit keeps Emacs 30 able to find already-built grammars like Rust.
  (add-to-list 'treesit-extra-load-path
               (expand-file-name ".local/cache/tree-sitter" doom-emacs-dir))
  ;; Level 4 is visually rich but can be noticeably heavier in large Rust files.
  (setq treesit-font-lock-level 3))

(use-package! treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (dolist (grammar '((rust "https://github.com/tree-sitter/tree-sitter-rust")
                     (julia "https://github.com/tree-sitter/tree-sitter-julia")))
    (cl-pushnew grammar treesit-language-source-alist :test #'eq :key #'car))
  (treesit-auto-add-to-auto-mode-alist)
  (global-treesit-auto-mode))

(defun my/rust-cargo-deny ()
  "Run cargo deny for the current project."
  (interactive)
  (rustic-run-cargo-command "cargo deny check"))

(defmacro my/rust-cargo-localleader-bindings! (keymap)
  "Add Doom Rust localleader bindings to KEYMAP."
  `(progn
     (map! :map ,keymap
           :localleader
           (:prefix ("b" . "build")
            :desc "cargo audit"      "a" #'+rust/cargo-audit
            :desc "cargo build"      "b" #'rustic-cargo-build
            :desc "cargo bench"      "B" #'rustic-cargo-bench
            :desc "cargo check"      "c" #'rustic-cargo-check
            :desc "cargo clippy"     "C" #'rustic-cargo-clippy
            :desc "cargo doc"        "d" #'rustic-cargo-build-doc
            :desc "cargo doc --open" "D" #'rustic-cargo-doc
            :desc "cargo fmt"        "f" #'rustic-cargo-fmt
            :desc "cargo new"        "n" #'rustic-cargo-new
            :desc "cargo outdated"   "o" #'rustic-cargo-outdated
            :desc "cargo run"        "r" #'rustic-cargo-run
            :desc "cargo deny"       "y" #'my/rust-cargo-deny)
           (:prefix ("t" . "cargo test")
            :desc "all"              "a" #'rustic-cargo-test
            :desc "current test"     "t" #'rustic-cargo-current-test))
     (map! :map ,keymap
           :n "SPC m b a" #'+rust/cargo-audit
           :n "SPC m b b" #'rustic-cargo-build
           :n "SPC m b B" #'rustic-cargo-bench
           :n "SPC m b c" #'rustic-cargo-check
           :n "SPC m b C" #'rustic-cargo-clippy
           :n "SPC m b d" #'rustic-cargo-build-doc
           :n "SPC m b D" #'rustic-cargo-doc
           :n "SPC m b f" #'rustic-cargo-fmt
           :n "SPC m b n" #'rustic-cargo-new
           :n "SPC m b o" #'rustic-cargo-outdated
           :n "SPC m b r" #'rustic-cargo-run
           :n "SPC m b y" #'my/rust-cargo-deny
           :n "SPC m t a" #'rustic-cargo-test
           :n "SPC m t t" #'rustic-cargo-current-test)))

(after! rust-mode
  (my/rust-cargo-localleader-bindings! rust-mode-map))

(after! rust-ts-mode
  (my/rust-cargo-localleader-bindings! rust-ts-mode-map)

  ;; Emacs 30.2 expands some Rust font-lock predicates into queries that fail
  ;; against the local Rust grammar/runtime. Keep Rust on `rust-ts-mode' by
  ;; moving those text checks into Lisp-side capture functions.
  (defun my-rust-ts-fontify-matching-text (node override start end face regexp)
    "Fontify NODE with FACE when its text matches REGEXP."
    (when (string-match-p regexp (treesit-node-text node t))
      (treesit-fontify-with-override
       (treesit-node-start node) (treesit-node-end node)
       face override start end)))

  (defun my-rust-ts-fontify-builtin-macro (node override start end &rest _)
    "Fontify built-in Rust macro identifiers."
    (my-rust-ts-fontify-matching-text
     node override start end 'font-lock-builtin-face
     (rx-to-string `(seq bol (or ,@rust-ts-mode--builtin-macros) eol))))

  (defun my-rust-ts-fontify-option-result (node override start end &rest _)
    "Fontify Rust Option and Result variant identifiers."
    (my-rust-ts-fontify-matching-text
     node override start end 'font-lock-type-face
     (rx bos (or "Err" "Ok" "None" "Some") eos)))

  (defun my-rust-ts-fontify-macro-keyword (node override start end &rest _)
    "Fontify keyword-looking identifiers inside macro bodies."
    (my-rust-ts-fontify-matching-text
     node override start end 'font-lock-keyword-face
     (rx bos (or "else" "in" "move") eos)))

  (defun my-rust-ts-fontify-uppercase-type (node override start end &rest _)
    "Fontify uppercase identifiers as Rust types."
    (my-rust-ts-fontify-matching-text
     node override start end 'font-lock-type-face
     (rx bos upper)))

  (defun my-rust-ts-fontify-primitive-scope (node override start end &rest _)
    "Fontify Rust primitive identifiers in scoped paths."
    (my-rust-ts-fontify-matching-text
     node override start end 'font-lock-type-face
     (rx bos
         (or "u8" "u16" "u32" "u64" "u128" "usize"
             "i8" "i16" "i32" "i64" "i128" "isize"
             "char" "str")
         eos)))

  (defun my-rust-ts-fontify-uppercase-constant (node override start end &rest _)
    "Fontify all-caps identifiers as Rust constants."
    (my-rust-ts-fontify-matching-text
     node override start end 'font-lock-constant-face
     (rx bos upper (* (or upper digit "_")) eos)))

  (setq rust-ts-mode--font-lock-settings
        (append
         (cl-remove-if
          (lambda (setting)
            (memq (nth 2 setting) '(builtin keyword type constant)))
          rust-ts-mode--font-lock-settings)
         (treesit-font-lock-rules
          :language 'rust
          :feature 'builtin
          '((macro_invocation
             macro: (identifier) @my-rust-ts-fontify-builtin-macro)
            (identifier) @my-rust-ts-fontify-option-result)

          :language 'rust
          :feature 'keyword
          `([,@rust-ts-mode--keywords] @font-lock-keyword-face
            (identifier) @my-rust-ts-fontify-macro-keyword)

          :language 'rust
          :feature 'type
          '((scoped_use_list path: (identifier) @font-lock-constant-face)
            (scoped_use_list
             path: (scoped_identifier
                    name: (identifier) @font-lock-constant-face))
            (use_as_clause alias: (identifier) @my-rust-ts-fontify-uppercase-type)
            (use_as_clause path: (identifier) @my-rust-ts-fontify-uppercase-type)
            (use_list (identifier) @my-rust-ts-fontify-uppercase-type)
            (use_wildcard
             [(identifier) @rust-ts-mode--fontify-scope
              (scoped_identifier
               name: (identifier) @rust-ts-mode--fontify-scope)])
            (enum_variant name: (identifier) @font-lock-type-face)
            (match_arm
             pattern: (match_pattern (_ type: (identifier) @font-lock-type-face)))
            (match_arm
             pattern: (match_pattern
                       (_ type: (scoped_identifier
                                 path: (identifier) @font-lock-type-face))))
            (mod_item name: (identifier) @font-lock-constant-face)
            [(fragment_specifier) (primitive_type) (type_identifier)] @font-lock-type-face
            (scoped_identifier name: (identifier) @rust-ts-mode--fontify-tail)
            (scoped_identifier path: (identifier) @my-rust-ts-fontify-primitive-scope)
            (scoped_identifier path: (identifier) @rust-ts-mode--fontify-scope)
            (scoped_type_identifier
             path: (identifier) @rust-ts-mode--fontify-scope))

          :language 'rust
          :feature 'constant
          '((boolean_literal) @font-lock-constant-face
            (identifier) @my-rust-ts-fontify-uppercase-constant)))))

;;;; Racket
(add-hook! '(racket-mode-hook racket-hash-lang-mode-hook racket-repl-mode-hook)
  (defun my/racket-defaults-h ()
    "Apply local editing defaults for Racket buffers."
    (setq-local tab-width 2
                standard-indent 2
                indent-tabs-mode nil
                evil-shift-width 2
                evil-indent-level 2)))

(defun my/racket-repl-window ()
  "Return the visible Racket REPL window, if any."
  (cl-find-if
   (lambda (window)
     (with-current-buffer (window-buffer window)
       (or (derived-mode-p 'racket-repl-mode)
           (string-prefix-p "*Racket REPL" (buffer-name)))))
   (window-list nil 'no-minibuf)))

(defun my/racket-quit-repl-window ()
  "Hide the visible Racket REPL window without killing its buffer."
  (interactive)
  (when-let ((window (my/racket-repl-window)))
    (quit-window nil window)
    t))

(defun my/racket-escape-or-quit-repl-window ()
  "Hide a visible Racket REPL window, or fall back to Doom's ESC behavior."
  (interactive)
  (unless (my/racket-quit-repl-window)
    (if (and (bound-and-true-p evil-mode)
             (memq evil-state '(insert replace visual operator)))
        (evil-force-normal-state)
      (doom/escape 'interactive))))

(add-hook! 'doom-escape-hook
  (defun my/racket-quit-repl-window-h ()
    "Let ESC hide a visible Racket REPL window first."
    (when (my/racket-repl-window)
      (my/racket-quit-repl-window))))

(after! racket-mode
  (add-hook 'racket-mode-hook #'racket-unicode-input-method-enable)
  (add-hook 'racket-hash-lang-mode-hook #'racket-unicode-input-method-enable)
  (add-hook 'racket-repl-mode-hook #'racket-unicode-input-method-enable)
  (after! evil
    (evil-define-key* '(normal insert emacs motion)
      racket-mode-map [escape] #'my/racket-escape-or-quit-repl-window)
    (when (boundp 'racket-hash-lang-mode-map)
      (evil-define-key* '(normal insert emacs motion)
        racket-hash-lang-mode-map [escape] #'my/racket-escape-or-quit-repl-window))
    (evil-define-key* '(normal insert emacs motion)
      racket-repl-mode-map [escape] #'my/racket-quit-repl-window)
    (evil-define-key* 'normal racket-repl-mode-map "q" #'quit-window)))

(set-eglot-client! 'racket-mode '("racket" "-l" "racket-langserver"))

(after! indent-bars
  (add-hook! '+indent-guides-inhibit-functions
    (defun my/disable-indent-guides-in-rust-p ()
      (derived-mode-p 'rust-mode 'rust-ts-mode 'rustic-mode))))

(add-hook! '(rust-mode-hook rust-ts-mode-hook rustic-mode-hook)
  (defun my/rust-performance-defaults-h ()
    "Prefer cheaper redisplay defaults in Rust buffers."
    (setq-local display-line-numbers t))

  (defun my/rust-eglot-deferred-h ()
    "Start Eglot for Rust after the buffer has had a chance to display."
    (run-with-idle-timer
     2 nil
     (lambda (buffer)
       (when (buffer-live-p buffer)
         (with-current-buffer buffer
           (when (and (require 'eglot nil t)
                      (derived-mode-p 'rust-mode 'rust-ts-mode 'rustic-mode)
                      (not (eglot-current-server)))
             (eglot-ensure)))))
     (current-buffer))))

;; Eglot + Inlay Hints
(setq gc-cons-threshold 100000000) ;; 100MB GC threshold

(use-package! eglot
  :hook ((python-mode . eglot-ensure)
         (python-ts-mode . eglot-ensure))
  :config
  ;; Keep diagnostics out of Flymake to avoid per-buffer diagnostic overlays.
  (add-to-list 'eglot-stay-out-of 'flymake)

  (add-hook 'eglot-managed-mode-hook
            (defun my/enable-rust-inlay-hints-h ()
              "Enable rust-analyzer inlay hints in Rust buffers."
              (when (derived-mode-p 'rust-mode 'rust-ts-mode 'rustic-mode)
                (eglot-inlay-hints-mode 1))))

  ;; Language Server Configurations
  (setq eglot-workspace-configuration
        '(:rust-analyzer
          (:diagnostics (:disabled ["unlinked-file"])
           :inlayHints
           (:bindingModeHints (:enable t)
            :typeHints (:enable t)
            :parameterHints (:enable t)
            :chainingHints (:enable t)
            :closureReturnTypeHints (:enable "always")
            :maxLength nil))
          :pyright
          (:inlayHints
           (:parameterNames t
            :variableTypes t
            :functionReturnTypes t
            :functionParameterTypes t
            :propertyDeclarationTypes t))))

  ;; Python Setup
  (add-to-list 'eglot-server-programs
               '((python-mode python-ts-mode) .
                 ("pyright-langserver" "--stdio" :initializationOptions
                  (:python
                   (:analysis
                    (:inlayHints
                     (:parameterNames t
                      :variableTypes t
                      :functionReturnTypes t
                      :functionParameterTypes t
                      :propertyDeclarationTypes t))))))))
;;
;;; Global Formatting Configuration
(after! apheleia
  ;; Force rustfmt to use the global config
  (set-formatter! 'rustfmt '("rustfmt" "--config-path" "~/.rustfmt.toml" "--emit" "stdout") :modes '(rust-mode rustic-mode rust-ts-mode))
  ;; Force black to use the global config
  (set-formatter! 'black '("black" "--config" "~/.config/black" "-q" "-") :modes '(python-mode python-ts-mode)))

;; Force 2-space indentation globally in Emacs
(setq-default tab-width 2
              indent-tabs-mode nil)
