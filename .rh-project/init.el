;; -*- coding: utf-8 -*-

(require 'cl)
(require 'hydra)
(require 'vterm)
(require 'flycheck)
(require 'lsp-mode)
(require 'lsp-javascript)
(require 'clang-format)

;;; gcc-bazel-init common command
;;; /b/{

(defvar rpi-pico-dojo/build-buffer-name
  "*gcc-bazel-init-build*")

(defun rpi-pico-dojo/lint ()
  (interactive)
  (rh-project-compile
   "yarn-run app:lint"
   rpi-pico-dojo/build-buffer-name))

(defun rpi-pico-dojo/build ()
  (interactive)
  (rh-project-compile
   "yarn-run app:build"
   rpi-pico-dojo/build-buffer-name))

(defun rpi-pico-dojo/clean ()
  (interactive)
  (rh-project-compile
   "yarn-run app:clean"
   rpi-pico-dojo/build-buffer-name))

;;; /b/}

;;; gcc-bazel-init
;;; /b/{

(defun rpi-pico-dojo/hydra-define ()
  (defhydra gcc-bazel-init-hydra (:color blue :columns 5)
    "@gcc-bazel-init workspace commands"
    ("l" rpi-pico-dojo/lint "lint")
    ("b" rpi-pico-dojo/build "build")
    ("c" rpi-pico-dojo/clean "clean")))

(rpi-pico-dojo/hydra-define)

(define-minor-mode gcc-bazel-init-mode
  "gcc-bazel-init project-specific minor mode."
  :lighter " gcc-bazel-init"
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map (kbd "<f9>") #'gcc-bazel-init-hydra/body)
            map))

(add-to-list 'rm-blacklist " gcc-bazel-init")

(defun rpi-pico-dojo/lsp-deps-providers-path (path)
  (concat (expand-file-name (rh-project-get-root))
          "node_modules/.bin/"
          path))

(defvar rpi-pico-dojo/lsp-clients-clangd-args '())

(defun rpi-pico-dojo/config-lsp-clangd ()
  (setq rpi-pico-dojo/lsp-clients-clangd-args
        (copy-sequence lsp-clients-clangd-args))
  (add-to-list
   'rpi-pico-dojo/lsp-clients-clangd-args
   "--query-driver=**/arm-none-eabi-g*"
   ;; "--query-driver=/usr/bin/arm-none-eabi-g*"
   t)

  ;; (add-hook
  ;;  'lsp-after-open-hook
  ;;  #'rpi-pico-dojo/company-capf-c++-local-disable)

  ;; (add-hook
  ;;  'lsp-after-initialize-hook
  ;;  #'rpi-pico-dojo/company-capf-c++-local-disable)
  )

;; (defun rpi-pico-dojo/company-capf-c++-local-disable ()
;;   (when (eq major-mode 'c++-mode)
;;     (setq-local company-backends
;;                 (remq 'company-capf company-backends))))

(defun rpi-pico-dojo/config-lsp-javascript ()
  (plist-put
   lsp-deps-providers
   :local (list :path #'rpi-pico-dojo/lsp-deps-providers-path))

  (lsp-dependency 'typescript-language-server
                  '(:local "typescript-language-server"))

  (lsp--require-packages)

  (lsp-dependency 'typescript '(:local "tsserver"))

  (add-hook
   'lsp-after-initialize-hook
   #'rpi-pico-dojo/flycheck-add-eslint-next-to-lsp))

(defun rpi-pico-dojo/flycheck-add-eslint-next-to-lsp ()
  (when (seq-contains-p '(js2-mode typescript-mode web-mode) major-mode)
    (flycheck-add-next-checker 'lsp 'javascript-eslint)))

(defun rpi-pico-dojo/flycheck-after-syntax-check-hook-once ()
  (remove-hook
   'flycheck-after-syntax-check-hook
   #'rpi-pico-dojo/flycheck-after-syntax-check-hook-once
   t)
  (flycheck-buffer))

;; (eval-after-load 'lsp-javascript #'rpi-pico-dojo/config-lsp-javascript)
(eval-after-load 'lsp-mode #'rpi-pico-dojo/config-lsp-javascript)
(eval-after-load 'lsp-mode #'rpi-pico-dojo/config-lsp-clangd)

(defun gcc-bazel-init-setup ()
  (when buffer-file-name
    (let ((project-root (rh-project-get-root))
          file-rpath ext-js)
      (when project-root
        (setq file-rpath (expand-file-name buffer-file-name project-root))
        (cond
         ;; This is required as tsserver does not work with files in archives
         ((bound-and-true-p archive-subfile-mode)
          (company-mode 1))

         ((seq-contains '(c++-mode c-mode) major-mode)
          (when (rh-clangd-executable-find)
            (when (featurep 'lsp-mode)
              (setq-local
               lsp-clients-clangd-args
               (copy-sequence rpi-pico-dojo/lsp-clients-clangd-args))

              (add-to-list
               'lsp-clients-clangd-args
               (concat "--compile-commands-dir="
                       (expand-file-name (rh-project-get-root)))
               t)

              (setq-local lsp-modeline-diagnostics-enable nil)
              ;; (lsp-headerline-breadcrumb-mode 1)

              (setq-local flycheck-idle-change-delay 3)
              (setq-local flycheck-check-syntax-automatically
                          ;; '(save mode-enabled)
                          '(idle-change save mode-enabled))))

          ;; (add-hook 'before-save-hook #'clang-format-buffer nil t)
          (clang-format-mode 1)
          (company-mode 1)
          (lsp 1))

         ((or (setq
               ext-js
               (string-match-p
                (concat "\\.ts\\'\\|\\.tsx\\'\\|\\.js\\'\\|\\.jsx\\'"
                        "\\|\\.cjs\\'\\|\\.mjs\\'")
                file-rpath))
              (string-match-p "^#!.*node"
                              (or (save-excursion
                                    (goto-char (point-min))
                                    (thing-at-point 'line t))
                                  "")))

          (when (boundp 'rh-js2-additional-externs)
            (setq-local rh-js2-additional-externs
                        (append rh-js2-additional-externs
                                '("require" "exports" "module" "process"
                                  "__dirname"))))

          (setq-local flycheck-idle-change-delay 3)
          (setq-local flycheck-check-syntax-automatically
                      ;; '(save mode-enabled)
                      '(save idle-change mode-enabled))
          (setq-local flycheck-javascript-eslint-executable
                      (concat (expand-file-name project-root)
                              "node_modules/.bin/eslint"))

          (setq-local lsp-enabled-clients '(ts-ls))
          ;; (setq-local lsp-headerline-breadcrumb-enable nil)
          (setq-local lsp-before-save-edits nil)
          (setq-local lsp-modeline-diagnostics-enable nil)
          (add-hook
           'flycheck-after-syntax-check-hook
           #'rpi-pico-dojo/flycheck-after-syntax-check-hook-once
           nil t)
          (lsp 1)
          ;; (lsp-headerline-breadcrumb-mode -1)
          (prettier-mode 1)))))))

;;; /b/}
