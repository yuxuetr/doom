;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "yuxuetr"
      user-mail-address "54.yeying@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-monokai-pro)
;; (setq doom-theme 'doom-one-light)
;; (setq doom-theme 'doom-dracula)
;; (setq doom-theme 'doom-tomorrow-day)
;; (setq doom-theme 'doom-spacegrey)
;; (setq doom-theme 'doom-solarized-light)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
(setq doom-font (font-spec :family "Monaco Nerd Font" :size 20)
      doom-variable-pitch-font (font-spec :family "Monaco Nerd Font")
      doom-symbol-font (font-spec :family "Monaco Nerd Font" :size 16)
      doom-big-font (font-spec :family "Monaco Nerd Font" :size 18))

(use-package! org-pomodoro
  :after org
  :config
  (setq org-pomodoro-length 45
        org-pomodoro-short-break-length 5
        org-pomodoro-long-break-length 15
        org-pomodoro-long-break-frequency 4))


;; (use-package! copilot
;;   :hook (prog-mode . copilot-mode)
;;   :bind (:map copilot-completion-map
;;               ("<tab>" . 'copilot-accept-completion)
;;               ("TAB" . 'copilot-accept-completion)
;;               ("C-TAB" . 'copilot-accept-completion-by-word)
;;               ("C-<tab>" . 'copilot-accept-completion-by-word)))

;; (use-package! tree-sitter
;;   :config
;;   (require 'tree-sitter-langs)
;;   (global-tree-sitter-mode)
;;   (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (defvar my-screen-height (frame-height))
;; (defvar my-screen-width (frame-width))
;; (set-frame-size (selected-frame) 120 my-screen-height t)
;; (add-to-list 'initial-frame-alist '(fullscreen . maximized))
(after! doom
  (setq initial-frame-alist
        '((right . 0)
          (top . 0)
          (width . 120)
          (height . 80))))
(setq-default electric-indent-mode t)
(setq-default auto-fill-function 'do-auto-fill)
(setq evil-auto-indent 2)
(setq-default evil-shift-width 2)
(add-hook 'text-mode-hook (lambda () (setq tab-width 2)))
;; (add-hook 'prog-mode-hook (lambda () (setq tab-width 2)))

(setq-default tab-width 2        ; 设置 Tab 大小为 2
              indent-tabs-mode nil ; 使用空格代替 Tab（如果希望使用 Tab，请将其设置为 t）
              standard-indent 2)   ; 设置标准缩进为 2

;; 使所有编程模式遵循此配置
(add-hook 'prog-mode-hook
          (lambda ()
            (setq tab-width 2
                  standard-indent 2
                  indent-tabs-mode nil)))  ; 如果希望使用 tab 缩进，请将其设置为 t


(setq org-superstar-headline-bullets-list '("☰" "☷" "☳" "☴" "☵" "☲" "☶" "☱"))

(setq evil-snipe-override-evil-repeat-keys nil)
(setq doom-localleader-key ",")
(setq doom-localleader-alt-key "M-,")

(find-file
 (concat "~/org/days/" (format-time-string "%Y-%m-%d") ".org"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;ProtoBuf;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path "~/.config/doom/lisp/")

;; Load protobuf-mode
(require 'protobuf-mode)

;; Optionally, add hooks or customizations
(add-hook 'protobuf-mode-hook
          (lambda ()
            (setq c-basic-offset 2
                  indent-tabs-mode nil)))

;;; Minuet AI Configuration

(use-package! minuet
  :commands (minuet-complete-with-minibuffer minuet-show-suggestion)
  :bind
  (("M-y" . minuet-complete-with-minibuffer) ;; 使用 minibuffer 进行补全
   ("M-i" . minuet-show-suggestion)) ;; 使用 overlay 进行补全
  :hook (prog-mode . minuet-auto-suggestion-mode) ;; 在编程模式启用自动补全
  :config
  ;; 选择 DeepSeek 作为补全提供商
  (setq minuet-provider 'openai-fim-compatible)

  ;; 设置 API 端点和 DeepSeek 相关配置
  (plist-put minuet-openai-fim-compatible-options :end-point "https://api.deepseek.com/beta/completions")
  (plist-put minuet-openai-fim-compatible-options :api-key "DEEPSEEK_API_KEY") ;; 需要在环境变量中设置
  (plist-put minuet-openai-fim-compatible-options :name "DeepSeek")
  (plist-put minuet-openai-fim-compatible-options :model "deepseek-coder-v2") ;; DeepSeek 编码模型
  (plist-put minuet-openai-fim-compatible-options :max_tokens 256) ;; 限制最大生成 token

  ;; 设定补全相关选项
  (setq minuet-n-completions 3) ;; 设为 3 以获取多种补全建议
  (setq minuet-context-window 16000) ;; 适用于 DeepSeek 的大上下文窗口
  (setq minuet-context-ratio 0.75) ;; 75% 上下文在光标之前
  (setq minuet-request-timeout 3) ;; 超时限制

  (map! :map prog-mode-map
        "TAB" #'minuet-show-suggestion))

(add-hook 'minuet-active-mode-hook #'evil-normalize-keymaps)

(setq gc-cons-threshold 100000000); 100M,设置GC不那么频繁

;; Doom Emacs Eglot + Inlay Hints Configuration
(use-package! eglot
  :hook ((rust-mode rust-ts-mode
                    python-mode python-ts-mode
                    typescript-mode tsx-ts-mode) . eglot-ensure)
  :config
  ;; 启用 eglot 的 inlay hints 模式（自动显示类型提示和参数提示）
  (add-hook 'eglot-managed-mode-hook #'eglot-inlay-hints-mode)

  ;; 设置各语言服务器的 inlay hints 配置
  (setq eglot-workspace-configuration
        '(
          ;; Rust 配置：使用 rust-analyzer
          :rust-analyzer
          (:diagnostics (:disabled ["unlinked-file"])  ;; 禁用 unlinked-file 警告
           :inlayHints
           (:bindingModeHints t      ;; 启用绑定模式提示
            :typeHints t            ;; 变量/表达式类型提示
            :parameterHints t       ;; 函数参数提示
            :chainingHints t        ;; 方法链提示
            :closureReturnTypeHints "always"  ;; 闭包返回类型提示
            :maxLength nil))
          ;; Python 配置：使用 pyright
          :pyright
          (:inlayHints
           (:parameterNames t        ;; 启用参数名称提示
            :variableTypes t         ;; 启用变量类型提示
            :functionReturnTypes t   ;; 启用函数返回值类型提示
            :functionParameterTypes t ;; 启用函数参数类型提示
            :propertyDeclarationTypes t))
          ;; TypeScript 配置：使用 typescript-language-server
          :typescript
          (:preferences
           (:includeInlayParameterNameHints "all"  ;; 启用所有参数名称提示
            :includeInlayFunctionParameterTypeHints t ;; 启用函数参数类型提示
            :includeInlayVariableTypeHints t           ;; 启用变量类型提示
            :includeInlayFunctionLikeReturnTypeHints t   ;; 启用函数返回类型提示
            :includeInlayEnumMemberValueHints t))))     ;; 启用枚举成员值提示

  ;; 为 TypeScript 启用 TSX 支持
  (add-to-list 'eglot-server-programs
               '((typescript-mode tsx-ts-mode typescript-ts-mode) .
                 ("typescript-language-server" "--stdio" :initializationOptions
                  (:preferences
                   (:includeInlayParameterNameHints "all"
                    :includeInlayFunctionParameterTypeHints t
                    :includeInlayVariableTypeHints t
                    :includeInlayFunctionLikeReturnTypeHints t
                    :includeInlayEnumMemberValueHints t)))))

  ;; Python：使用 pyright 作为 LSP 服务器，并启用 inlay hints（类型提示）
  (add-to-list 'eglot-server-programs
               '((python-mode python-ts-mode) .
                 ("pyright-langserver" "--stdio" :initializationOptions
                  (:python
                   (:analysis
                    (:inlayHints
                     (:parameterNames t         ;; 启用参数名称提示
                      :variableTypes t          ;; 启用变量类型提示
                      :functionReturnTypes t    ;; 启用函数返回类型提示
                      :functionParameterTypes t ;; 启用函数参数类型提示
                      :propertyDeclarationTypes t)))))))  ;; 启用类属性声明类型提示

  ;; 当进入 Python 模式时自动启动 eglot 和 inlay hints 模式
  (add-hook 'python-mode-hook #'eglot-ensure)
  (add-hook 'python-mode-hook #'eglot-inlay-hints-mode)

  ;; （可选）针对 rust-analyzer，发送配置更新请求，确保设置生效
  (defun my/eglot-inlay-hints-setup-rust ()
    "为 rust-analyzer 发送更新 inlay hints 配置的请求."
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

(setq default-directory "~/")
