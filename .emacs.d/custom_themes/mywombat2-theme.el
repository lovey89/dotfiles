(deftheme mywombat2
  "Created 2017-10-01.")

(custom-theme-set-variables
 'mywombat2
 '(ansi-color-names-vector ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"]))

(custom-theme-set-faces
 'mywombat2
 '(cursor ((((class color) (min-colors 89)) (:background "#656565"))))
 '(fringe ((((class color) (min-colors 89)) (:background "#303030"))))
 '(highlight ((t (:background "#454545"))))
 '(region ((t (:background "#cd00cd" :foreground "#262626"))))
 '(secondary-selection ((((class color) (min-colors 89)) (:background "#333366" :foreground "#f6f3e8"))))
 '(isearch ((t (:background "color-208" :foreground "color-232"))))
 '(lazy-highlight ((t (:background "brightyellow" :foreground "black"))))
 '(mode-line ((t (:background "#f6f3e8" :foreground "#444444"))))
 '(mode-line-inactive ((t (:background "#444444" :foreground "#f6f3e8"))))
 '(minibuffer-prompt ((((class color) (min-colors 89)) (:foreground "#e5786d"))))
 '(escape-glyph ((((class color) (min-colors 89)) (:foreground "#ddaa6f" :weight bold))))
 '(font-lock-builtin-face ((((class color) (min-colors 89)) (:foreground "#e5786d"))))
 '(font-lock-comment-face ((((class color) (min-colors 89)) (:foreground "#99968b"))))
 '(font-lock-constant-face ((((class color) (min-colors 89)) (:foreground "#e5786d"))))
 '(font-lock-function-name-face ((((class color) (min-colors 89)) (:foreground "#cae682"))))
 '(font-lock-keyword-face ((((class color) (min-colors 89)) (:foreground "#8ac6f2" :weight bold))))
 '(font-lock-string-face ((((class color) (min-colors 89)) (:foreground "#95e454"))))
 '(font-lock-type-face ((t (:foreground "#92a65e" :weight bold))))
 '(font-lock-variable-name-face ((((class color) (min-colors 89)) (:foreground "#cae682"))))
 '(font-lock-warning-face ((((class color) (min-colors 89)) (:foreground "#ccaa8f"))))
 '(link ((((class color) (min-colors 89)) (:foreground "#8ac6f2" :underline t))))
 '(link-visited ((((class color) (min-colors 89)) (:foreground "#e5786d" :underline t))))
 '(button ((t (:inherit link))))
 '(header-line ((((class color) (min-colors 89)) (:background "#303030" :foreground "#e7f6da"))))
 '(show-paren-match ((t (:background "color-208" :foreground "black"))))
 '(show-paren-mismatch ((((class color)) (:background "purple" :foreground "white")) (t (:inverse-video t))))
 '(org-block ((t (:background "color-234"))))
 '(org-block-begin-line ((t (:background "#92a65e" :foreground "#262626"))))
 '(org-block-end-line ((t (:inherit (org-block-begin-line)))))
 '(default ((((class color) (min-colors 89)) (:background "#242424" :foreground "#f6f3e8")))))

(provide-theme 'mywombat2)
