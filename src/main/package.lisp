(require :sb-bsd-sockets)

(defpackage #:microservices-router (:use :common-lisp)
 (:export #:boot)
 (:documentation
  "The router for the microservices to register with and use."))

(defpackage #:microservices-client (:use :common-lisp)
 (:export #:boot)
 (:documentation
  "The client library that clients use impelemnt and register their services."))
