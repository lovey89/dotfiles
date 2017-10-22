(deftheme mywombat2
  "Created 2017-10-01.")

(let ((class '((class color) (min-colors 89)))
      (loved-white   "#f6f3e8")
      (loved-gray+2  "#99968b")
      (loved-gray+1  "#444444")
      (loved-gray    "#242424")
      (loved-gray-1  "#1c1c1c")
      (loved-pink+2  "#ff615a")
      (loved-pink+1  "#f58c80")
      (loved-pink    "#eea9b8")
      (loved-green   "#92a65e")
      (loved-green+1 "#95e454")
      (loved-blue    "#8ac6f2")
      (loved-red     "#e5786d")
      (loved-yellow  "#cae682")
      (loved-cyan    "#333366")
      (loved-brown   "#ccaa8f")
      )

  (custom-theme-set-variables
   'mywombat2
   '(ansi-color-names-vector ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"]))
;["black" "red3" "green3" "yellow3" "blue2" "magenta3" "cyan3" "gray90"]

  (custom-theme-set-faces
   'mywombat2

   ;; Basic colors
   `(default             ((,class (:background ,loved-gray   :foreground ,loved-white)))) ; BG and FG
   `(mode-line           ((,class (:background ,loved-white  :foreground ,loved-gray+1))))
   `(mode-line-inactive  ((,class (:background ,loved-gray+1 :foreground ,loved-white))))
   `(region              ((,class (:background ,loved-pink   :foreground ,loved-gray)))) ; Text selection
   `(secondary-selection ((,class (:background ,loved-cyan   :foreground ,loved-white)))) ; Needed?
   `(show-paren-match    ((,class (:background "#ff8700" :foreground "#080808"))))
   `(show-paren-mismatch ((,class (:background ,loved-pink+2 :foreground ,loved-white))))
   `(minibuffer-prompt   ((,class (:foreground ,loved-red))))
   `(highlight           ((,class (:background ,loved-gray+1))))
   `(link                ((,class (:foreground ,loved-blue :underline t))))
   `(link-visited        ((,class (:foreground ,loved-red :underline t))))
   `(button              ((,class (:inherit (link)))))
   `(isearch             ((,class (:background "#ff8700" :foreground "#080808"))))
   `(lazy-highlight      ((,class (:background "#ffff00" :foreground "#080808"))))
   `(header-line         ((,class (:background "#303030" :foreground "#e7f6da"))))
   `(escape-glyph        ((,class (:foreground "#ddaa6f" :weight bold))))

   ;; Basic colors under X
   `(cursor ((,class (:background "#f6f3e8"))))
   `(fringe ((,class (:background "#303030"))))

   ;; Font locks
   `(font-lock-builtin-face       ((,class (:foreground ,loved-red))))
   `(font-lock-comment-face       ((,class (:foreground ,loved-gray+2))))
   `(font-lock-constant-face      ((,class (:foreground ,loved-red))))
   `(font-lock-function-name-face ((,class (:foreground ,loved-yellow))))
   ;`(font-lock-keyword-face       ((,class (:foreground ,loved-blue :weight bold))))
   `(font-lock-keyword-face       ((,class (:foreground ,loved-blue))))
   `(font-lock-string-face        ((,class (:foreground ,loved-green+1))))
   ;`(font-lock-type-face          ((,class (:foreground ,loved-green :weight bold))))
   `(font-lock-type-face          ((,class (:foreground ,loved-green))))
   `(font-lock-variable-name-face ((,class (:foreground ,loved-yellow))))
   `(font-lock-warning-face       ((,class (:foreground ,loved-brown))))

   ;; Org mode
   `(org-block            ((,class (:background ,loved-gray-1))))
   `(org-block-begin-line ((,class (:background ,loved-green :foreground ,loved-gray))))
   `(org-block-end-line   ((,class (:inherit (org-block-begin-line)))))

   ;; Company
   `(company-tooltip                      ((,class (:inherit (mode-line-inactive)))))
   `(company-tooltip-selection            ((,class (:inherit (region)))))
   `(company-tooltip-annotation           ((,class (:foreground ,loved-blue))))
   `(company-tooltip-common               ((,class (:foreground ,loved-yellow))))
   `(company-tooltip-annotation-selection ((,class (:foreground "#000080"))))
   `(company-tooltip-common-selection     ((,class (:foreground "#8b0000")))))
  )

(provide-theme 'mywombat2)
