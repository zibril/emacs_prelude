(add-to-list 'default-frame-alist '(font . "Monaco-10"))
;(add-to-list 'default-frame-alist '(fullscreen . maximized))
(add-to-list 'default-frame-alist '(height . 50))
(add-to-list 'default-frame-alist '(width . 150))
(when window-system
  (set-file-name-coding-system 'cp949-dos))

(setq initial-frame-alist default-frame-alist)
(setq special-display-frame-alist default-frame-alist)

;(setq prelude-theme 'tango-dark)
;(setq prelude-theme 'Zenburn)
;(setq prelude-whitespace nil)

(set-language-environment "Korean")
(prefer-coding-system 'utf-8)
(global-set-key (kbd "<Hangul>") 'toggle-input-method)

(key-chord-define-global "xx" 'helm-M-x)

; line number
(setq display-line-numbers-type 'relative)

;scroll
(setq mouse-wheel-scroll-amount '(1 ((shift) . 3) ((control)))
      scroll-conservatively 3
      scroll-margin 3
      maximum-scroll-margin 0.2)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

; (use-package counsel
  ; :config
  ; (ivy-configure 'counsel-M-x :initial-input ""))

(use-package moe-theme
	:ensure t
	:functions moe-light
	:config
	(setq moe-theme-highlight-buffer-id t)
	(setq moe-theme-mode-line-color 'blue)
	(moe-light))

(use-package powerline
	:ensure t
	:config
	(setq moe-theme-highlight-buffer-id t)
	(powerline-moe-theme))
	

(use-package nyan-mode
	:ensure t
	:config
	(setq nyan-animate-nyancat t)
	(setq nyan-wavy-trail t)
	(nyan-mode))

;; Resize titles (optional).
; (setq moe-theme-resize-title-markdown '(1.5 1.4 1.3 1.2 1.0 1.0))
; (setq moe-theme-resize-title-org '(1.5 1.4 1.3 1.2 1.1 1.0 1.0 1.0 1.0))
; (setq moe-theme-resize-title-rst '(1.5 1.4 1.3 1.2 1.1 1.0))

(use-package mini-frame :ensure t)
(setq x-gtk-resize-child-frames 'resize-mode)
(custom-set-variables
 '(mini-frame-show-parameters
   '((top . 400)
     (width . 0.7)
     (left . 0.5))))
(mini-frame-mode 1)	

;; Custom functions/hooks for persisting/loading frame geometry upon save/load
(defun save-frameg ()
	"Gets the current frame's geometry and saves to ~/.emacs.frameg."
	(let ((frameg-font (frame-parameter (selected-frame) 'font))
	(frameg-left (frame-parameter (selected-frame) 'left))
	(frameg-top (frame-parameter (selected-frame) 'top))
	(frameg-width (frame-parameter (selected-frame) 'width))
	(frameg-height (frame-parameter (selected-frame) 'height))
	(frameg-file (expand-file-name "~/.emacs.frameg")))
	(with-temp-buffer
	;; Turn off backup for this file
	(make-local-variable 'make-backup-files)
	(setq make-backup-files nil)
	(insert
	";;; This file stores the previous emacs frame's geometry.\n"
	";;; Last generated " (current-time-string) ".\n"
	"(setq initial-frame-alist\n"
	;; " '((font . \"" frameg-font "\")\n"
	" '("
	(format " (top . %d)\n" (max frameg-top 0))
	(format " (left . %d)\n" (max frameg-left 0))
	(format " (width . %d)\n" (max frameg-width 0))
	(format " (height . %d)))\n" (max frameg-height 0)))
	(when (file-writable-p frameg-file)
	(write-file frameg-file)))))

(defun load-frameg ()
	"Loads ~/.emacs.frameg which should load the previous frame's geometry."
	(let ((frameg-file (expand-file-name "~/.emacs.frameg")))
	(when (file-readable-p frameg-file)
	(load-file frameg-file))))

;; Special work to do ONLY when there is a window system being used
(if window-system
	(progn
	(add-hook 'after-init-hook 'load-frameg)
	(add-hook 'kill-emacs-hook 'save-frameg)))