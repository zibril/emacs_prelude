; (use-package rust-mode
;   :bind ( :map rust-mode-map
;                (("C-c C-t" . racer-describe)
;                 ([?\t] .  company-indent-or-complete-common)))
;   :config
;   (progn
;     ;; add flycheck support for rust (reads in cargo stuff)
;     ;; https://github.com/flycheck/flycheck-rust
;     (use-package flycheck-rust)

;     ;; cargo-mode for all the cargo related operations
;     ;; https://github.com/kwrooijen/cargo.el
;     (use-package cargo
;       :hook (rust-mode . cargo-minor-mode)
;       :bind
;       ("C-c C-c C-n" . cargo-process-new)) ;; global binding

;     ;;; separedit ;; via https://github.com/twlz0ne/separedit.el
;     (use-package separedit
;       ;:straight 
;       ;(separedit :type git :host github :repo "idcrook/separedit.el")
;       :config
;       (progn
;         (define-key prog-mode-map (kbd "C-c '") #'separedit)
;         (setq separedit-default-mode 'markdown-mode)))


;     ;;; racer-mode for getting IDE like features for rust-mode
;     ;; https://github.com/racer-rust/emacs-racer
;     (use-package racer
;       :hook (rust-mode . racer-mode)
;       :config
;       (progn
;         ;; package does this by default ;; set racer rust source path environment variable
;         ;; (setq racer-rust-src-path (getenv "RUST_SRC_PATH"))
;         (defun my-racer-mode-hook ()
;           (set (make-local-variable 'company-backends)
;                '((company-capf company-files)))
;           (setq company-minimum-prefix-length 1)
;           (setq indent-tabs-mode nil))

;         (add-hook 'racer-mode-hook 'my-racer-mode-hook)

;         ;; enable company and eldoc minor modes in rust-mode (racer-mode)
;         (add-hook 'racer-mode-hook #'company-mode)
;         (add-hook 'racer-mode-hook #'eldoc-mode)))

;     (add-hook 'rust-mode-hook 'flycheck-mode)
;     (add-hook 'flycheck-mode-hook 'flycheck-rust-setup)

;     ;; format rust buffers on save using rustfmt
;     (add-hook 'before-save-hook
;               (lambda ()
;                 (when (eq major-mode 'rust-mode)
;                   (rust-format-buffer))))))


(use-package rustic
  :ensure
  :bind (:map rustic-mode-map
              ("M-j" . lsp-ui-imenu)
              ("M-?" . lsp-find-references)
              ("C-c C-c l" . flycheck-list-errors)
              ("C-c C-c a" . lsp-execute-code-action)
              ("C-c C-c r" . lsp-rename)
              ("C-c C-c q" . lsp-workspace-restart)
              ("C-c C-c Q" . lsp-workspace-shutdown)
              ("C-c C-c s" . lsp-rust-analyzer-status))
  :config
  ;; uncomment for less flashiness
  ;; (setq lsp-eldoc-hook nil)
  ;; (setq lsp-enable-symbol-highlighting nil)
  ;; (setq lsp-signature-auto-activate nil)
  
  ;; comment to disable rustfmt on save
  ;(setq rustic-format-on-save t) ; 이걸 사용하면 저장시 hang됨
  (add-hook 'rustic-mode-hook 'rk/rustic-mode-hook))

(defun rk/rustic-mode-hook ()
  ;; so that run C-c C-c C-r works without having to confirm, but don't try to
  ;; save rust buffers that are not file visiting. Once
  ;; https://github.com/brotzeit/rustic/issues/253 has been resolved this should
  ;; no longer be necessary.
  (when buffer-file-name
    (setq-local buffer-save-without-query t)))

(use-package lsp-mode
  :ensure
  :commands lsp
  :custom
  ;; what to use when checking on-save. "check" is default, I prefer clippy
  (lsp-rust-analyzer-cargo-watch-command "clippy")
  (lsp-eldoc-render-all t)
  (lsp-idle-delay 0.5)
  ;; enable / disable the hints as you prefer:
  (lsp-rust-analyzer-server-display-inlay-hints t)
  (lsp-rust-analyzer-display-lifetime-elision-hints-enable "skip_trivial")
  (lsp-rust-analyzer-display-chaining-hints t)
  (lsp-rust-analyzer-display-lifetime-elision-hints-use-parameter-names t)
  (lsp-rust-analyzer-display-closure-return-type-hints t)
  (lsp-rust-analyzer-display-parameter-hints t)
  (lsp-rust-analyzer-display-reborrow-hints nil)
  :config
  (add-hook 'lsp-mode-hook 'lsp-ui-mode))


(setq lsp-prefer-capf t)
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024)) ;; 1mb

(use-package lsp-ui
  :ensure
  :commands lsp-ui-mode
  :custom
  (lsp-ui-peek-always-show t)
  (lsp-ui-sideline-show-hover t)
  (lsp-ui-doc-enable t))

(use-package company
  :ensure
  :custom
  (company-idle-delay 0.5) ;; how long to wait until popup
  ;; (company-begin-commands nil) ;; uncomment to disable popup
  :bind
  (:map company-active-map
    ("C-n". company-select-next)
    ("C-p". company-select-previous)
    ("M-<". company-select-first)
    ("M->". company-select-last)
    ("<tab>". tab-indent-or-complete)
    ("TAB". tab-indent-or-complete)))

(use-package yasnippet
  :ensure
  :config
  (yas-reload-all)
  (add-hook 'prog-mode-hook 'yas-minor-mode)
  (add-hook 'text-mode-hook 'yas-minor-mode))

(defun company-yasnippet-or-completion ()
  (interactive)
  (or (do-yas-expand)
      (company-complete-common)))

(defun check-expansion ()
  (save-excursion
    (if (looking-at "\\_>") t
      (backward-char 1)
      (if (looking-at "\\.") t
        (backward-char 1)
        (if (looking-at "::") t nil)))))

(defun do-yas-expand ()
  (let ((yas/fallback-behavior 'return-nil))
    (yas/expand)))

(defun tab-indent-or-complete ()
  (interactive)
  (if (minibufferp)
      (minibuffer-complete)
    (if (or (not yas/minor-mode)
            (null (do-yas-expand)))
        (if (check-expansion)
            (company-complete-common)
          (indent-for-tab-command)))))

(use-package flycheck :ensure)

; (use-package exec-path-from-shell
;   :ensure
;   :init (exec-path-from-shell-initialize))

(use-package dap-mode
  :ensure
  :config
  (dap-ui-mode)
  (dap-ui-controls-mode 1)

  (require 'dap-lldb)
  (require 'dap-gdb-lldb)
  ;; installs .extension/vscode
  (dap-gdb-lldb-setup)
  (dap-register-debug-template
   "Rust::LLDB Run Configuration"
   (list :type "lldb"
         :request "launch"
         :name "LLDB::Run"
   :gdbpath "rust-lldb"
         :target nil
         :cwd nil)))

(dap-register-debug-template "Rust::GDB Run Configuration"
                             (list :type "gdb"
                                   :request "launch"
                                   :name "GDB::Run"
                                   :gdbpath "rust-gdb"
                                   :target nil
                                   :cwd nil))