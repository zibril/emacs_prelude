; 시행 착오용 파일을 열기 위한 설정
(require 'open-junk-file)
; C-x C-z로 시행 착오 파일을 연다
(global-set-key (kbd "C-x C-z") 'open-junk-file)

; 평가 결과를 주석하기 위한 설정
(require 'lispxmp)
; emacs-lisp-mode에서 C-c C-d를 누르면 주석처리
(define-key emacs-lisp-mode-map (kbd "C-c C-d") 'lispxmp)

; 괄호 대응을 유지하고 편집하는 설정
(require 'paredit)
(add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)
(add-hook 'lisp-mode-hook 'enable-paredit-mode)
(add-hook 'ielm-mode-hook 'enable-paredit-mode)

; 자동 바이트 컴파일을 하지 않는 파일명을 정규표현
(require 'auto-async-byte-compile)
(setq auto-async-byte-compile-exclude-files-regexp "/junk/")
(add-hook 'emacs-lisp-mode-hook 'enable-auto-async-byte-compile-mode)
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)
(setq eldoc-idle-delay 0.2)			; 바로 표시하고 싶다
(setq eldoc-minor-mode-string "")	; 모드 라인에 ElDoc이라고 표시하지 않기

; 서로 맞는 괄호를 하이라이트
(show-paren-mode 1)

; 개행과 동시에 인덴트
(global-set-key "\C-m" 'newline-and-indent)

; find-function을 키에 할당
(find-function-setup-keys)