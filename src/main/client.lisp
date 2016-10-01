(in-package #:microservices-client)

(defun boot (port)
 "BOOT PORT => NIL

ARGUMENTS AND VALUES:

  PORT: An integer representing the port on which to bind
  NIL: NIL

DESCRIPTION:

  Boots up the client, listening on on the configured port"

 (sb-thread:make-thread
  (lambda ()
   (let
    ((socket (make-instance 'sb-bsd-sockets:inet-socket :type :stream :protocol :tcp)))
    (sb-bsd-sockets:socket-bind socket #(127 0 0 1) port)
    (sb-bsd-sockets:socket-listen socket 2)
    (unwind-protect
     (loop
      (let ((new-fd (sb-bsd-sockets:socket-accept socket)))
       (sb-thread:make-thread
        (lambda ()
         (let ((strm (sb-bsd-sockets:socket-make-stream new-fd :output t :input t)))
          (unwind-protect
           (loop
            for cmd = (read strm nil)
            while cmd
            do (format strm "~S~%" cmd)
            do (force-output strm))
           (sb-bsd-sockets:socket-close new-fd))))
        :name "Microservices Client Instance")))
     (sb-bsd-sockets:socket-close socket))))
  :name "Microservices Client"))
