;; Note at the top of init.org file there is a line:
;; #+PROPERTY: header-args :tangle gen-init.el
;; When we tangle init.org the result will be outputted to gen-init.el

;; This line will be added automatically anyways..
(package-initialize)

;; We can't tangle without org!
(require 'org)

;; The name and path of our generated file
(setq gen-file (concat user-emacs-directory "gen-init.el"))

;; If the generated file doesn't exist we should create it
(unless (file-exists-p gen-file)
  (progn
    ;; Open the configuration
    (find-file (concat user-emacs-directory "init.org"))
    ;; tangle it
    (org-babel-tangle))
  )

;; load the generated file
(load-file gen-file)
