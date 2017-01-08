(setq default-frame-alist
  '((top . 200) (left . 400)
    (width . 80) (height . 40)
    (cursor-color . "green")
    (cursor-type . box)
))
 
(setq initial-frame-alist '((top . 10) (left . 30)))

;Make dabbrev commands case sensitive
(setq dabbrev-case-fold-search nil)
 
;Line breaks at white spaces instead of anywhere
(setq-default word-wrap t)

;Move backup files to ~/.saves
(setq backup-directory-alist `(("." . "~/.saves")))
(setq backup-by-copying t)
;(setq backup-by-copying-when-linked t)
 
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-fill-mode nil)
 '(column-number-mode t)
 '(custom-safe-themes
   (quote
    ("8b9f12f744659b89e85a47826f8513154fce3a5e087be767fa34fbd57ed5a81c" default)))
 '(custom-theme-directory "~/.emacs.d/custom_themes")
 '(dabbrev-check-all-buffers t)
 '(delete-selection-mode nil)
 '(global-font-lock-mode t)
 '(inhibit-startup-screen t)
 '(menu-bar-mode nil)
 '(scroll-bar-mode nil)
 '(scroll-margin 2)
 '(scroll-step 1)
 '(show-paren-mode t)
 '(text-mode-hook (quote (turn-on-auto-fill text-mode-hook-identify)))
 '(tool-bar-mode nil))
 
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(add-to-list 'load-path "~/.emacs.d/cscope")

;Set theme. Create new themes by running the "customize-themes" command
(load-theme 'mywombat2)
(global-hl-line-mode 1)

(require 'xcscope)
(setq cscope-do-not-update-database 1)
(setq cscope-edit-single-match nil)
(define-key cscope:map "\C-csd" 'cscope-find-global-definition-no-prompting)
(define-key cscope:map "\C-csD" 'cscope-find-global-definition)
(define-key cscope:map "\C-csc" 'cscope-find-functions-calling-this-function-no-prompting)
(define-key cscope:map "\C-csC" 'cscope-find-functions-calling-this-function)
(define-key cscope:map "\C-css" 'cscope-find-this-symbol-no-prompting)
(define-key cscope:map "\C-csS" 'cscope-find-this-symbol)

(when (>= emacs-major-version 23) 
;Fixa problem med att S-up inte alltid fungerar som den ska
;(if (equal "xterm" (tty-type))
  (define-key input-decode-map "\e[1;2A" [S-up]);)

;(defadvice terminal-init-xterm (after select-shift-up activate)
;      (define-key input-decode-map "\e[1;2A" [S-up]))
)

;För att kunna byta fönster med shift-pil
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings)
  ;Wrappa runt
  (setq windmove-wrap-around t)
  ;Shift up. Kombinationen hittades genom kommandot C-q som returnerar ^[[1;2A byt ut ^[ mot \e
  (global-set-key "\e[1;2A" 'windmove-up)) ; kanske är överflödig nu?

(define-key key-translation-map (kbd "<select>") (kbd "<end>")) ;För jobbet. End-knappen fungerar inte

;Auto-complete (utifrån innehållet i filen). Bindas till C-SPC (men @ är SPC typ?)
(global-set-key (kbd "C-@") 'dabbrev-completion-all)
(global-set-key (kbd "C-n") 'set-mark-command)

(require 'view)
(global-set-key (kbd "M-v") 'View-scroll-half-page-backward)
(global-set-key (kbd "C-v") 'View-scroll-half-page-forward)
(global-set-key (kbd "M-b") (lambda () (interactive) (scroll-down 1)))
(global-set-key (kbd "C-b") (lambda () (interactive) (scroll-up 1)))

(define-key key-translation-map (kbd "<A-up>") (kbd "<M-up>")) ;Rebinda knapparna eftersom dessa av någon anledning ibland visas som <A-up> osv.
(define-key key-translation-map (kbd "<A-down>") (kbd "<M-down>"))
(define-key key-translation-map (kbd "<A-right>") (kbd "<M-right>"))
(define-key key-translation-map (kbd "<A-left>") (kbd "<M-left>"))

;Man kan nu ändra storlek på fönstrena genom alt-pil
(global-set-key (kbd "<M-up>")    'enlarge-window)
(global-set-key (kbd "<M-right>") 'enlarge-window-horizontally)
(global-set-key (kbd "<M-left>")  'shrink-window-horizontally)
(global-set-key (kbd "<M-down>")  'shrink-window)
 
;; handle tmux's xterm-keys
;; put the following line in your ~/.tmux.conf:
;;   setw -g xterm-keys on
(if (getenv "TMUX")
    (progn
      (let ((x 2) (tkey ""))
        (while (<= x 8)
          ;; shift
          (if (= x 2)
              (setq tkey "S-"))
          ;; alt
          (if (= x 3)
              (setq tkey "M-"))
          ;; alt + shift
          (if (= x 4)
              (setq tkey "M-S-"))
          ;; ctrl
          (if (= x 5)
              (setq tkey "C-"))
          ;; ctrl + shift
          (if (= x 6)
              (setq tkey "C-S-"))
          ;; ctrl + alt
          (if (= x 7)
              (setq tkey "C-M-"))
          ;; ctrl + alt + shift
          (if (= x 8)
              (setq tkey "C-M-S-"))
 
          ;Till skillnad mot kbd verkar read-kbd-macro evaluera sina argument
          ;"Från-knapparna" visades exakt så här när man använde C-h c kommandot
          ;; arrows
          (define-key key-translation-map (read-kbd-macro (format "M-[ 1 ; %d A" x)) (read-kbd-macro (format "%s<up>" tkey)))
          (define-key key-translation-map (read-kbd-macro (format "M-[ 1 ; %d B" x)) (read-kbd-macro (format "%s<down>" tkey)))
          (define-key key-translation-map (read-kbd-macro (format "M-[ 1 ; %d C" x)) (read-kbd-macro (format "%s<right>" tkey)))
          (define-key key-translation-map (read-kbd-macro (format "M-[ 1 ; %d D" x)) (read-kbd-macro (format "%s<left>" tkey)))
          ;; home
          (define-key key-translation-map (read-kbd-macro (format "M-[ 1 ; %d H" x)) (read-kbd-macro (format "%s<home>" tkey)))
          ;; end
          (define-key key-translation-map (read-kbd-macro (format "M-[ 1 ; %d F" x)) (read-kbd-macro (format "%s<end>" tkey)))
          ;; page up
          (define-key key-translation-map (read-kbd-macro (format "M-[ 5 ; %d ~" x)) (read-kbd-macro (format "%s<prior>" tkey)))
          ;; page down
          (define-key key-translation-map (read-kbd-macro (format "M-[ 6 ; %d ~" x)) (read-kbd-macro (format "%s<next>" tkey)))
          ;; insert
          (define-key key-translation-map (read-kbd-macro (format "M-[ 2 ; %d ~" x)) (read-kbd-macro (format "%s<delete>" tkey)))
          ;; delete
          (define-key key-translation-map (read-kbd-macro (format "M-[ 3 ; %d ~" x)) (read-kbd-macro (format "%s<delete>" tkey)))
          ;; f1
          (define-key key-translation-map (read-kbd-macro (format "M-[ 1 ; %d P" x)) (read-kbd-macro (format "%s<f1>" tkey)))
          ;; f2
          (define-key key-translation-map (read-kbd-macro (format "M-[ 1 ; %d Q" x)) (read-kbd-macro (format "%s<f2>" tkey)))
          ;; f3
          (define-key key-translation-map (read-kbd-macro (format "M-[ 1 ; %d R" x)) (read-kbd-macro (format "%s<f3>" tkey)))
          ;; f4
          (define-key key-translation-map (read-kbd-macro (format "M-[ 1 ; %d S" x)) (read-kbd-macro (format "%s<f4>" tkey)))
          ;; f5
          (define-key key-translation-map (read-kbd-macro (format "M-[ 15 ; %d ~" x)) (read-kbd-macro (format "%s<f5>" tkey)))
          ;; f6
          (define-key key-translation-map (read-kbd-macro (format "M-[ 17 ; %d ~" x)) (read-kbd-macro (format "%s<f6>" tkey)))
          ;; f7
          (define-key key-translation-map (read-kbd-macro (format "M-[ 18 ; %d ~" x)) (read-kbd-macro (format "%s<f7>" tkey)))
          ;; f8
          (define-key key-translation-map (read-kbd-macro (format "M-[ 19 ; %d ~" x)) (read-kbd-macro (format "%s<f8>" tkey)))
          ;; f9
          (define-key key-translation-map (read-kbd-macro (format "M-[ 20 ; %d ~" x)) (read-kbd-macro (format "%s<f9>" tkey)))
          ;; f10
          (define-key key-translation-map (read-kbd-macro (format "M-[ 21 ; %d ~" x)) (read-kbd-macro (format "%s<f10>" tkey)))
          ;; f11
          (define-key key-translation-map (read-kbd-macro (format "M-[ 23 ; %d ~" x)) (read-kbd-macro (format "%s<f11>" tkey)))
          ;; f12
          (define-key key-translation-map (read-kbd-macro (format "M-[ 24 ; %d ~" x)) (read-kbd-macro (format "%s<f12>" tkey)))
          ;; f13
          (define-key key-translation-map (read-kbd-macro (format "M-[ 25 ; %d ~" x)) (read-kbd-macro (format "%s<f13>" tkey)))
          ;; f14
          (define-key key-translation-map (read-kbd-macro (format "M-[ 26 ; %d ~" x)) (read-kbd-macro (format "%s<f14>" tkey)))
          ;; f15
          (define-key key-translation-map (read-kbd-macro (format "M-[ 28 ; %d ~" x)) (read-kbd-macro (format "%s<f15>" tkey)))
          ;; f16
          (define-key key-translation-map (read-kbd-macro (format "M-[ 29 ; %d ~" x)) (read-kbd-macro (format "%s<f16>" tkey)))
          ;; f17
          (define-key key-translation-map (read-kbd-macro (format "M-[ 31 ; %d ~" x)) (read-kbd-macro (format "%s<f17>" tkey)))
          ;; f18
          (define-key key-translation-map (read-kbd-macro (format "M-[ 32 ; %d ~" x)) (read-kbd-macro (format "%s<f18>" tkey)))
          ;; f19
          (define-key key-translation-map (read-kbd-macro (format "M-[ 33 ; %d ~" x)) (read-kbd-macro (format "%s<f19>" tkey)))
          ;; f20
          (define-key key-translation-map (read-kbd-macro (format "M-[ 34 ; %d ~" x)) (read-kbd-macro (format "%s<f20>" tkey)))
 
          (setq x (+ x 1))
          ))
      )
  )

(global-set-key (kbd "C-x 7") 'toggle-current-window-dedication)

(global-set-key [(shift f4)] 'my-top-of-page)
(global-set-key [(C-f4)] 'my-bottom-of-page)
(global-set-key [(f4)] 'my-middle-of-page)
(global-set-key [home] 'smart-beginning-of-line)
(global-set-key "\C-a" 'smart-beginning-of-line)
(global-set-key [(f1)] (lambda () (interactive) (manual-entry (current-word))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; AUTOMATICALLY CLOSE BRACES ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq skeleton-pair t)
(setq skeleton-pair-alist
      '((?\( _ ?\))
        (?[  _ ?])
        (?{  _ ?})
        (?\" _ ?\"))) ;"
(setq skeleton-newline-pair-alist
      '((?{  _ ?})))

(defun autopair-insert (arg)
  (interactive "P")
  (let (pair)
    (cond
     ((assq last-command-event skeleton-pair-alist)
      (autopair-open arg))
     (t
      (autopair-close arg)))))

(defun autopair-open (arg)
  (interactive "P")
  (let ((pair (assq last-command-event
                    skeleton-pair-alist)))
    (cond
     ((and (not mark-active)
           (eq (car pair) (car (last pair)))
           (eq (car pair) (char-after)))
      (autopair-close arg))
     (t
      (skeleton-pair-insert-maybe arg)))))

(defun autopair-close (arg)
  (interactive "P")
  (cond
   (mark-active
    (let (pair open)
      (dolist (pair skeleton-pair-alist)
        (when (eq last-command-event (car (last pair)))
          (setq open (car pair))))
      (setq last-command-event open)
      (skeleton-pair-insert-maybe arg)))
   ((looking-at
     (concat "[ \t\n]*"
             (regexp-quote (string last-command-event))))
    (replace-match (string last-command-event))
    (indent-according-to-mode))
   (t
    (self-insert-command (prefix-numeric-value arg))
    (indent-according-to-mode))))

(defadvice delete-backward-char (before autopair disable); activate) ;Don't activate automatically
  (when (and (char-after)
             (eq this-command 'delete-backward-char)
             (eq (char-after)
                 (car (last (assq (char-before) skeleton-pair-alist)))))
    (delete-char 1)))

(defadvice c-electric-backspace (before autopair disable); activate) ;Don't activate automatically
  (when (and (char-after)
             (eq this-command 'c-electric-backspace)
             (eq (char-after)
                 (car (last (assq (char-before) skeleton-pair-alist)))))
    (delete-char 1)))

(defun autopair-close-block (arg)
  (interactive "P")
  (cond
   (mark-active
    (autopair-close arg))
   ((not (looking-back "^[[:space:]]*"))
    (newline-and-indent)
    (autopair-close arg))
   (t
    (autopair-close arg))))

(defun autopairs-ret (arg)
  (interactive "P")
  (let (pair)
    (dolist (pair skeleton-newline-pair-alist)
    ;(dolist (pair skeleton-pair-alist)
      (when (eq (char-after) (car (last pair)))
        (save-excursion (indent-newline-indent))))
    ;(newline arg)
    ;(indent-according-to-mode)))
    (indent-newline-indent)))

; To add more:
;(add-to-list 'skeleton-pair-alist '(?<  _ ?>))

; For global use:
;(global-set-key "("  'autopair-insert)
;(global-set-key ")"  'autopair-insert)
;...

;;;;;;;;;;;;;;;;;;;
;; OWN FUNCTIONS ;;
;;;;;;;;;;;;;;;;;;;
(defun dabbrev-completion-all () ;För att sätta prefix till 16. Då autocompletar man mha alla buffrar
  (interactive)
  (let ((current-prefix-arg '(16))) ; C-u
  (call-interactively 'dabbrev-completion)))


(defun toggle-current-window-dedication ()
 (interactive)
 (let* ((window    (selected-window))
        (dedicated (window-dedicated-p window)))
   (set-window-dedicated-p window (not dedicated))
   (message "Window %sdedicated to %s"
            (if dedicated "no longer " "")
            (buffer-name))))

(defun battle-station ()
 (interactive)
 (split-window-horizontally)
 (split-window-horizontally)
 (split-window-vertically)
 (split-window-vertically)
 (select-window (window-at (- (frame-width) 1) (- (frame-height) 2)) nil)
 (split-window-vertically)
 (balance-windows)
 (split-window-vertically)
 (switch-to-buffer "*cscope*")
 (other-window 1)
 (switch-to-buffer "*Completions*")
 (select-window (window-at 1 1) nil))

(defun my-top-of-page () ;Annars M-0 M-r
  "Go to top of page."
  (interactive)
  (move-to-window-line 2))

(defun my-bottom-of-page () ;Annars M-- M-r
  "Go to bottom of page."
  (interactive)
  ;(move-to-window-line -1))
  (let* ((wb-height (window-buffer-height (selected-window)))
        (actual-height (if (> wb-height (window-height))
                           (window-height)
                         wb-height)))
    (move-to-window-line (- actual-height 4))))

(defun my-middle-of-page () ;Annars M-r
  "Go to middle of page."
  (interactive)
  (let* ((wb-height (window-buffer-height (selected-window)))
        (actual-height (if (> wb-height (window-height))
                           (window-height)
                         wb-height)))
    (move-to-window-line (/ actual-height 2))))

(defun indent-newline-indent ()
  (interactive)
  (indent-according-to-mode)
  (newline-and-indent))

(defun smart-beginning-of-line ()
  "Move point to first non-whitespace character or beginning-of-line.

Move point to the first non-whitespace character on this line.
If point was already at that position, move point to beginning of line."
  (interactive)
  (let ((oldpos (point)))
    (back-to-indentation)
    (and (= oldpos (point))
         (beginning-of-line))))

;;;;;;;;;;;
;; HOOKS ;;
;;;;;;;;;;;

;(setq-default c-default-style "linux")
(setq c-default-style "linux")

(add-hook 'c-mode-common-hook
          '(lambda () ; You may also create a function (defun) and use here instead of lambda
             (message "MINE: Loading c-mode-common-hook.")
             (setq-default truncate-lines t      ; Don't truncate lines
                           indent-tabs-mode nil)  ; Spaces instead of tabs when indenting
             (setq c-basic-offset 2)
             ; Adds newline after e.g. ";". Also indents it and leaves trailing whitespaces
             ;(c-toggle-auto-newline 1)
             (define-key c-mode-base-map (kbd "RET") 'autopairs-ret)
             (c-set-offset 'substatement-open '0) ; brackets should be at same indentation level as the statements they open
             ;(c-set-offset 'inline-open '+)
             ;(c-set-offset 'block-open '+)
             ;(c-set-offset 'brace-list-open '+)   ; all "opens" should be indented by the c-indent-level
             (c-set-offset 'case-label '+)       ; indent case labels by c-indent-level, too
             ; Looks like I have to enable advices before activating them.
             ; Someone stated that "the function specified, ad-activate activates
             ; all currently-enabled advice (not necessarily just one defined in
             ; the previous expression), and will also deactivate any advice which
             ; was previously active, but has since been disabled". Only seems to
             ; work like this in hooks? Try if other modes were affected.
             (ad-enable-advice 'c-electric-backspace 'before 'autopair)
             (ad-enable-advice 'delete-backward-char 'before 'autopair)
             (ad-activate 'c-electric-backspace)
             (ad-activate 'delete-backward-char)
             (local-set-key "(" 'autopair-insert)
             (local-set-key ")" 'autopair-insert)
             (local-set-key "[" 'autopair-insert)
             (local-set-key "]" 'autopair-insert)
             (local-set-key "{" 'autopair-insert)
             (local-set-key "}" 'autopair-close-block)
             (local-set-key "\"" 'autopair-insert)))

;(add-hook 'before-save-hook 'delete-trailing-whitespace)


;(define-prefix-command 'ctl-z-map)
;(defun move-to-window-line-top ()
;  (interactive)
;  (move-to-window-line 0))
;(defun move-to-window-line-middle ()
;  (interactive)
;  (let* ((wb-height (window-buffer-height (get-buffer-window)))
;        (actual-height (if (> wb-height (window-height))
;                           (window-height)
;                         wb-height)))
;    (move-to-window-line (/ actual-height 2))))
;(defun move-to-window-line-bottom ()
;  (interactive)
;  (move-to-window-line -1)
;  (beginning-of-line))
;(define-key ctl-z-map (kbd "h") 'move-to-window-line-top)
;(define-key ctl-z-map (kbd "m") 'move-to-window-line-middle)
;(define-key ctl-z-map (kbd "l") 'move-to-window-line-bottom)
;(global-set-key (kbd "C-z") 'ctl-z-map)
