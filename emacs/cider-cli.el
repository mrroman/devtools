;;; cider-cli -- use cider with .nrepl-port file
;;;
;;; Commentary:
;;; Code:

;; -*- lexical-binding: t -*-

(require 'projectile)

(defun cider-cli--read-file-as-string
    (name)
  "Read whole file NAME as a string."
  (when (file-exists-p name)
    (with-temp-buffer
      (insert-file-contents name)
      (buffer-string))))

(defun cider-cli--load-nrepl-port
    (nrepl-port-file)
  "Load port number from NREPL-PORT-FILE."
  (let ((port-file (cider-cli--read-file-as-string nrepl-port-file)))
    (when (and port-file (string-match-p "^[0-9]+$" port-file))
        port-file)))

(defun cider-cli--connect-to-nrepl
    (project-root nrepl-port server-buffer)
  "Connect to the project placed in PROJECT-ROOT on the port specified in the NREPL-PORT and running in the SERVER-BUFFER."
  (message "Connect to project %s on port %s" project-root nrepl-port)
  (cider-connect "localhost" nrepl-port project-root)
  (add-to-list 'cider-ancillary-buffers (get-buffer server-buffer)))

(defvar cider-cli-start-nrepl-command
  "/usr/local/bin/clojure -R:devtools:cider -m devtools.nrepl"
  "Command that starts Clojure with nrepl server.")

(defvar cider-cli-start-nrepl-timeout
  30
  "Timeout in seconds for nrepl server start.")

(defun cider-cli--wait-for-port
    (project-root nrepl-port-file server-buffer try)
  "Wait for Clojure CLI to start server in project PROJECT-ROOT at port in NREPL-PORT-FILE in the buffer SERVER-BUFFER for the TRY time."
  (if (not (zerop try))
      (progn
        (message "Waiting %d..." try)
        (let ((nrepl-port (cider-cli--load-nrepl-port nrepl-port-file)))
          (if nrepl-port
              (cider-cli--connect-to-nrepl project-root nrepl-port server-buffer)
            (run-at-time "1 sec" nil
                         #'cider-cli--wait-for-port
                         project-root nrepl-port-file server-buffer (- try 1)))))
    (progn
      (message "Kill nrepl server")
      (kill-process (get-buffer-process server-buffer)))))

(defun cider-cli--start-nrepl
    (project-root nrepl-port-file)
  "Start nrepl server at PROJECT-ROOT and connect to it port specified in NREPL-PORT-FILE."
  (let ((server-buffer (format "*nrepl server - %s*" (file-name-base (directory-file-name project-root)))))
    (message "Starting nrepl server in buffer %s..." server-buffer)

    (let ((default-directory project-root))
      (make-process :name "nrepl-server"
                    :buffer server-buffer
                    :command (split-string cider-cli-start-nrepl-command)
                    :connection-type 'pty))
    (cider-cli--wait-for-port project-root
                              nrepl-port-file
                              server-buffer
                              cider-cli-start-nrepl-timeout)))

(defun cider-jack-in-cli ()
  "Start Cider session."
  (interactive)
  (let* ((project-root (if (projectile-project-p)
                           (projectile-project-root)
                         default-directory))
         (nrepl-port-file (expand-file-name ".nrepl-port" project-root)))
    (if (file-exists-p nrepl-port-file)
        (cider-cli--connect-to-nrepl project-root nrepl-port-file)
      (cider-cli--start-nrepl project-root nrepl-port-file))))

(provide 'cider-cli)
;;; cider-cli.el ends here
