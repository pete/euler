#! /usr/bin/env racket
#lang racket

(define (p xs n)
  (cond ((not xs) 0)
        ((= (car xs) 1) 1)
        ((< n 0) 0)
        (#t (+ (p (cdr xs) n) (p xs (- n (car xs)))))))
        
(printf "~a\n" (p '(200 100 50 20 10 5 2 1) 200))
