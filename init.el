;;; init --- Summary
;;; Commentary:
;;; code:
(require 'package) ;; You might already have this line
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (url (concat (if no-ssl "http" "https") "://melpa.org/packages/")))
  (add-to-list 'package-archives (cons "melpa" url) t))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(cider-auto-mode t)
 '(custom-enabled-themes (quote (tango-dark)))
 '(indent-tabs-mode nil)
 '(jdee-server-dir "~/jdee-server")
 '(package-selected-packages
   (quote
    (auctex ac-math pyvenv git hy-mode jedi company-jedi ipython-shell-send flycheck-clojure flycheck-pycheckers flymake-python-pyflakes company-anaconda company-shell anaconda-mode template-overlays omnisharp csharp-mode
            (quote company)
            (quote company-mode)
            ac-cider cider-eval-sexp-fu gradle-mode jdee lsp-java eclim javadoc-lookup java-snippets java-imports javaimp javap-mode company ensime sbt-mode markdown-toc markdown-mode+ markdown-mode company-go go-fill-struct go-scratch go-errcheck go-tag go-stacktracer go-snippets go-imenu go-playground-cli go-impl go-autocomplete go-complete go-gopath go-projectile go-playground go-imports golint go-mode clojars cider-hydra cider cython-mode ## clojure-mode scala-mode auto-complete-clang auto-complete-c-headers)))
 '(tab-width 4))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(add-hook 'go-mode-hook
          (lambda ()
            (set (make-local-variable 'company-backends) '(company-go))
            (company-mode)))

(defun install-plugins ()
  (interactive)
  (let* ((packages '(company ac-cider auto-complete cider-eval-sexp-fu gradle-mode
                             jdee lsp-java eclim javadoc-lookup java-snippets
                             java-imports javaimp javap-mode company ensime
                             sbt-mode markdown-toc markdown-mode+ markdown-mode
                             pyvenv anaconda-mode company-go go-fill-struct go-scratch
                             go-errcheck go-tag go-stacktracer go-snippets
                             go-imenu go-playground-cli go-impl go-autocomplete
                             go-complete go-gopath go-projectile go-playground
                             go-imports golint go-mode clojars cider-hydra
                             cider cython-mode clojure-mode scala-mode
                             auto-complete-clang auto-complete-c-headers
                             csharp-mode omnisharp))
         (packages-new))
    (package-refresh-contents)
    (dolist (p packages packages-new)
      (package-install p)
      (setq packages-new (cons p packages)))))

(eval-after-load
  'company
  '(add-to-list 'company-backends #'company-omnisharp))

(defun enable-python-env (env)
  "ARGS: ENV."
  (interactive "senv: ")
  (pyvenv-mode 1)
  (pyvenv-activate (concat "~/anaconda3/envs/" env "/"))
  (jedi:ac-setup))

(defun disable-python-env ()
  "Disable current python env."
  (interactive)
  (pyvenv-deactivate)
  (pyenv-mode 0))

(defun cs-mode-setup ()
  (omnisharp-mode)
  (company-mode)
  (flycheck-mode)

  (setq indent-tabs-mode nil)
  (setq c-syntactic-indentation t)
  (c-set-style "ellemtel")
  (setq c-basic-offset 4)
  (setq truncate-lines t)
  (setq tab-width 4)
  (setq evil-shift-width 4)

  (local-set-key (kbd "C-c r r") 'omnisharp-run-code-action-refactoring)
  (local-set-key (kbd "C-c C-c") 'recompile))

(add-hook 'csharp-mode-hook 'cs-mode-setup t)

(global-company-mode t)
(global-flycheck-mode t)
(global-set-key [?\C-x ?\M-x] 'company-complete)
(provide 'init)
;;; init.el ends here
(put 'upcase-region 'disabled nil)
