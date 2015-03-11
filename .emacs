;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Package Handler
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "https://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))

(setq package-enable-at-startup nil)
(package-initialize)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; OS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; ---- Check if system is Darwin/Mac OS X
(defun system-type-is-darwin ()
  "Return true if system is darwin-based (Mac OS X)"
  (string-equal system-type "darwin"))

;;;; ---- Check if system is GNU/Linux
(defun system-type-is-gnu ()
  "Return true if system is GNU/Linux-based"
  (string-equal system-type "gnu/linux"))

;;; ---- Check if system is Windows
(defun system-type-is-win ()
  "Return true if system is Windows based"
  (string-equal system-type "windows-nt"))

(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Fonts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(if (system-type-is-gnu) (set-default-font "-misc-fixed-medium-r-semicondensed-*-*-120-*-*-c-*-iso8859-1"))
(if (system-type-is-darwin)
    (if (> (x-display-pixel-width) 1280)
        (set-default-font
         "-apple-monaco-medium-r-normal--12-0-72-72-m-0-iso10646-1")
      (set-default-font
       "-apple-monaco-medium-r-normal--10-0-72-72-m-0-iso10646-1")))
(if (system-type-is-win) (set-default-font "-bitstream-bitstream vera sans mono-medium-r-*--*-90-*--*--*-"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Text input
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Make Emacs UTF-8 compatible for both display and editing:
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Misc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Avoid jumpy scolling
(setq scroll-step 1)

;; Show trailing whitespaces
(setq-default show-trailing-whitespace t)

;; Used for fill-paragraph
(setq-default fill-column 80)

;; Pending delete (typing erases selected region)
(delete-selection-mode t)

;; Show column-number in the mode line
(column-number-mode 1)

;; Do not indent with tabs.
(setq-default indent-tabs-mode nil)

;; Reload buffer automatically if changed elsewhere
(global-auto-revert-mode 1)

;;; ---- Mini buffer

;; Interactive completion in minibuffer
(require 'icomplete)

;; Make the y or n suffice for a yes or no question
(fset 'yes-or-no-p 'y-or-n-p)

;; Key bindings xref
(global-set-key (kbd "C-c C-f") 'flymake-display-err-menu-for-current-line)

;; Goto line
(global-set-key "\C-c\C-j" 'goto-line)

;;Uncomment region
(global-set-key "\C-c\C-y" 'uncomment-region)

;; Switch windows with s-a
(global-set-key (kbd "s-a") 'other-window)

;; Indent region
(global-set-key (kbd "s-i") 'indent-region)

;;; ---- Move lines with M-p (up) and M-n (down)
(global-set-key "\M-p" 'move-line-up)
(global-set-key "\M-n" 'move-line-down)

(defun move-line (&optional n)
   "Move current line N (1) lines up/down leaving point in place."
   (interactive "p")
   (when (null n)
     (setq n 1))
   (let ((col (current-column)))
     (beginning-of-line)
     (next-line 1)
     (transpose-lines n)
     (previous-line 1)
     (forward-char col)))

(defun move-line-up (n)
   "Moves current line N (1) lines up leaving point in place."
   (interactive "p")
   (move-line (if (null n) -1 (- n))))

(defun move-line-down (n)
   "Moves current line N (1) lines down leaving point in place."
   (interactive "p")
   (move-line (if (null n) 1 n)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Emacs look and feel
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; ---- Color theme
(defun my-theme ()
  (interactive)
  (color-theme-install
   '(my-theme
      ((background-color . "#2b2b2b")
      (background-mode . light)
      (border-color . "#2e2e2e")
      (cursor-color . "#525252")
      (foreground-color . "#e5e5e5")
      (mouse-color . "black"))
     (fringe ((t (:background "#2e2e2e"))))
     (mode-line ((t (:foreground "#8f8f8f" :background "#303030"))))
     (region ((t (:background "#424242"))))
     (flymake-errline ((((class color)) (:background "LightPink" :foreground "black"))))
     (flymake-warnline ((((class color)) (:background "LightBlue2" :foreground "black"))))
     (font-lock-builtin-face ((t (:foreground "#ffb885"))))
     (font-lock-comment-face ((t (:foreground "#525252"))))
     (font-lock-function-name-face ((t (:foreground "#f359a0"))))
     (font-lock-keyword-face ((t (:foreground "#fdda08"))))
     (font-lock-string-face ((t (:foreground "#9edd4b"))))
     (font-lock-type-face ((t (:foreground"#ff8fad"))))
     (font-lock-variable-name-face ((t (:foreground "#5dc0f4"))))
     (minibuffer-prompt ((t (:foreground "#adadad" :bold t))))
     (font-lock-warning-face ((t (:foreground "Red" :bold t))))
     )))
(provide 'my-theme)
(require 'color-theme)
(my-theme)

;;; ---- Decorations
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)
;; Don't show any startup message
(setq inhibit-startup-message t)
;; Set a better title
(setq frame-title-format '("%b" (buffer-file-name ": %f")))

;;; ---- Mouse
(mouse-wheel-mode t)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Flymake
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;(require 'flymake)
;;
;;(defun flymake-ruby-init ()
;;  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
;;                       'flymake-create-temp-inplace))
;;	 (local-file  (file-relative-name
;;                       temp-file
;;                       (file-name-directory buffer-file-name))))
;;    (list "/opt/boxen/rbenv/versions/1.9.3-p448/bin/ruby" (list "-c" local-file))))
;;
;;(push '(".+\\.rb$" flymake-ruby-init) flymake-allowed-file-name-masks)
;;(push '("Rakefile$" flymake-ruby-init) flymake-allowed-file-name-masks)
;;
;;(push '("^\\(.*\\):\\([0-9]+\\): \\(.*\\)$" 1 2 nil 3) flymake-err-line-patterns)
;;
;;(add-hook 'ruby-mode-hook
;;          '(lambda ()
;;
;;	     ;; Don't want flymake mode for ruby regions in rhtml files and also on read only files
;;	     (if (and (not (null buffer-file-name)) (file-writable-p buffer-file-name))
;;		 (flymake-mode))
;;	     ))
;;
;;(require 'flymake-coffee)
;;(add-hook 'coffee-mode-hook 'flymake-coffee-load)
;;
;;(require 'flymake-haml)
;;(add-hook 'haml-mode-hook 'flymake-haml-load)

(add-hook 'prog-mode-hook #'flycheck-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Helm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'helm)
(require 'helm-config)

;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

(when (executable-find "curl")
  (setq helm-google-suggest-use-curl-p t))

(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
;;      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t)

(helm-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Project Stuff
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(projectile-global-mode)
(setq projectile-enable-caching t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Coding Visuals
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; ---- highlight-parentheses
(require 'highlight-parentheses)
(add-hook 'prog-mode-hook #'highlight-parentheses-mode)

;;; ---- rainbow-delimiters
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;;; ---- smartparens-config
(require 'smartparens-config)

;;; ---- multiple-cursors
(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)

(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;;; ---- rainbow-delimiters
(require 'multiple-cursors)
(add-hook 'prog-mode-hook #'auto-complete-mode)

(ac-config-default)
(add-hook 'objc-mode-common-hook 'ac-cc-mode-setup)

(define-key ac-completing-map "\M-n" 'ac-next)
(define-key ac-completing-map "\M-p" 'ac-previous)
(define-key ac-completing-map [down] [down])
(define-key ac-completing-map [up] [up])

(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

(require 'drag-stuff)
(add-hook 'prog-mode-hook #'drag-stuff-mode)

(require 'highlight-symbol)
(add-hook 'prog-mode-hook #'highlight-symbol-mode)

(require 'sublimity)
(require 'sublimity-scroll)
;;(require 'sublimity-map)
;;(require 'sublimity-attractive)
(sublimity-mode 1)

(require 'indent-guide)
(add-hook 'prog-mode-hook #'indent-guide-mode)

(require 'rainbow-mode)
(add-hook 'prog-mode-hook #'rainbow-mode)

(require 'undo-tree)
(add-hook 'prog-mode-hook #'undo-tree-mode)

(require 'powerline)
(powerline-default-theme)
;;(add-hook 'prog-mode-hook #'linum-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Language Specifics
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;(autoload 'enh-ruby-mode "enh-ruby-mode" "Major mode for ruby files" t)
;;(remove-hook 'enh-ruby-mode-hook 'erm-define-faces)
;;(add-to-list 'auto-mode-alist '("\\.rb$" . enh-ruby-mode))
;;(add-to-list 'interpreter-mode-alist '("ruby" . enh-ruby-mode))

;; coffe-mode indentaion fix
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(coffee-tab-width 2)
 '(git-gutter:added-sign "☀")
 '(git-gutter:deleted-sign "☂")
 '(git-gutter:modified-sign "☁")
 '(git-gutter:window-width 2)
 '(package-selected-packages
   (quote
    (yaml-mode sass-mode projectile powerline json-mode undo-tree web magit git-gutter imgix rainbow-mode rspec-mode enh-ruby-mode indent-guide helm-dash sublimity helm highlight-symbol drag-stuff expand-region auto-complete flycheck multiple-cursors highlight-parentheses smartparens anaconda-mode rainbow-delimiters haml-mode flymake-haml exec-path-from-shell flymake-ruby flymake-coffee ruby-test-mode js2-mode color-theme coffee-mode))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Git
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'git-gutter)
(global-git-gutter-mode +1)
(global-set-key (kbd "C-q") 'git-gutter:next-diff)

(global-set-key (kbd "C-0") 'magit-status)
(global-set-key (kbd "C-9") 'magit-blame-mode)

(global-set-key (kbd "C-x C-b") 'helm-buffers-list)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; OWN PACKAGES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'load-path "~/.emacs.g/")
;; load the packaged named xyz.
(load "mapillary")
(require 'mapillary)
(global-set-key (kbd "C-x g") 'mapillary-image)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; File handling
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; ---- iswitchb
;;(iswitchb-mode 1)

;; ignore * files
;;(setq iswitchb-buffer-ignore '("^\\*"))
;;(setq iswitchb-buffer-ignore '("\*"))

;;(defun iswitchb-local-keys ()
;;  (mapc (lambda (K)
;;	  (let* ((key (car K)) (fun (cdr K)))
;;	    (define-key iswitchb-mode-map (edmacro-parse-keys key) fun)))
;;	'(("C-p" . iswitchb-next-match)
;;	  ("C-n"  . iswitchb-prev-match)
;;	  ("<up>"    . ignore             )
;;	  ("<down>"  . ignore             ))))
;;(add-hook 'iswitchb-define-mode-map-hook 'iswitchb-local-keys)

;;; ---- temporary files
;; Put autosave files (ie #foo#) in one place, *not* scattered all over the
;; file system! (The make-autosave-file-name function is invoked to determine
;; the filename of an autosave file.)
(defvar autosave-dir (concat "/tmp/emacs_autosaves/" (user-login-name) "/"))
(make-directory autosave-dir t)
(defun auto-save-file-name-p (filename) (string-match "^#.*#$" (file-name-nondirectory filename)))
(defun make-auto-save-file-name () (concat autosave-dir (if buffer-file-name (concat "#" (file-name-nondirectory buffer-file-name) "#") (expand-file-name (concat "#%" (buffer-name) "#")))))

(setq backup-directory-alist (quote ((".*" . "~/.emacs.d/backups/"))))

(setq version-control nil)

;;; ---- Open old opened files when emacs is closed and reopened
(desktop-save-mode 1)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
