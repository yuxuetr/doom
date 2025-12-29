;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;;;; Identity
(setq user-full-name "yuxuetr"
      user-mail-address "54.yeying@gmail.com")

;;;; UI & Fonts
(setq doom-theme 'doom-monokai-pro)
(setq display-line-numbers-type 'relative)

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

(setq org-superstar-headline-bullets-list '("☰" "☱" "☲" "☳" "☴" "☵" "☶" "☷"))

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

(use-package! org-pomodoro
  :after org
  :config
  (setq org-pomodoro-length 45
        org-pomodoro-short-break-length 5
        org-pomodoro-long-break-length 15
        org-pomodoro-long-break-frequency 4))

;;;; Keybindings
(setq doom-localleader-key ",")
(setq doom-localleader-alt-key "M-,")

;;;; Languages & Tools

(use-package! treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode)
  ;; Ensure typescript and tsx grammars are installed
  (setq treesit-language-source-alist
        '((typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
          (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")))
  )

;; Protobuf
(use-package! protobuf-mode
  :mode "\.proto\'"
  :config
  (setq c-basic-offset 2
        indent-tabs-mode nil))

;; Copilot
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :config
  ;; Disable indentation inference to prevent warnings/lag
  (setq copilot-indentation-alist nil)
  (setq copilot-indent-offset 2)
  (advice-add 'copilot--infer-indentation-offset :override (lambda (&optional _) 2))

  ;; Suppress warnings
  (setq copilot-show-warning nil)
  (dolist (warning '("copilot--infer-indentation-offset found no mode-specific indentation offset"
                     "copilot.*indentation"
                     "Copilot.*indentation"))
    (add-to-list 'warning-suppress-types (cons warning t)))

  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)))

;; Eglot + Inlay Hints
(setq gc-cons-threshold 100000000) ;; 100MB GC threshold

(use-package! eglot
  :hook ((rust-mode rust-ts-mode
          python-mode python-ts-mode
          typescript-mode tsx-ts-mode) . eglot-ensure)
  :config
  (add-hook 'eglot-managed-mode-hook #'eglot-inlay-hints-mode)

  ;; Language Server Configurations
  (setq eglot-workspace-configuration
        '(:rust-analyzer
          (:diagnostics (:disabled ["unlinked-file"])
           :inlayHints
           (:bindingModeHints t
            :typeHints t
            :parameterHints t
            :chainingHints t
            :closureReturnTypeHints "always"
            :maxLength nil))
          :pyright
          (:inlayHints
           (:parameterNames t
            :variableTypes t
            :functionReturnTypes t
            :functionParameterTypes t
            :propertyDeclarationTypes t))
          :typescript
          (:preferences
           (:includeInlayParameterNameHints "all"
            :includeInlayFunctionParameterTypeHints t
            :includeInlayVariableTypeHints t
            :includeInlayFunctionLikeReturnTypeHints t
            :includeInlayEnumMemberValueHints t))))

  ;; TypeScript/TSX Setup
  (add-to-list 'eglot-server-programs
               '((typescript-mode tsx-ts-mode typescript-ts-mode) .
                 ("typescript-language-server" "--stdio" :initializationOptions
                  (:preferences
                   (:includeInlayParameterNameHints "all"
                    :includeInlayFunctionParameterTypeHints t
                    :includeInlayVariableTypeHints t
                    :includeInlayFunctionLikeReturnTypeHints t
                    :includeInlayEnumMemberValueHints t)))))

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
                      :propertyDeclarationTypes t)))))))

  ;; Force update for Rust Analyzer inlay hints
  (defun my/eglot-inlay-hints-setup-rust ()
    (when (and (boundp 'eglot--current-server)
               (string-match "rust-analyzer" (symbol-name (eglot--current-server))))
      (jsonrpc-request (eglot--current-server)
                       :workspace/didChangeConfiguration
                       `(:settings (:rust-analyzer
                                    (:inlayHints
                                     (:bindingModeHints t
                                      :typeHints t
                                      :parameterHints t
                                      :chainingHints t
                                      :closureReturnTypeHints "always"
                                      :maxLength nil)))))))
  (add-hook 'eglot-managed-mode-hook #'my/eglot-inlay-hints-setup-rust))