#! /usr/bin/env racket
#lang racket

; Find the value of d < 1000 for which 1/d contains the longest recurring cycle in
; its decimal fraction part.

; So it has been long enough since I wrote any real Lisp code that it took a minute
; to acclimate myself.  I wrote this top to bottom after doing the Go one, and you
; can actually see the code make more sense as you approach the bottom of the file.

; Took like 10s to compile, ran in 3.1s, compared to the 1.7s in the Go version.
; Not exactly comparable, as a chunk of the algorithm is different.

; It was nice to not have to write a sieve, but just using the builtin primality
; test will not scale to the larger problems, I suspect.
(require math/number-theory)

(define (period n)
  (define (piteri mpow lpow)
    (let ([inner
           (lambda ()
                   (if (eq? 0 (modulo (- (expt 10 lpow) (expt 10 mpow)) n)) (- lpow mpow) #f))])
      	(if (<= mpow -1) #f
      	      (let ([res (inner)])
      	           (if res res (piteri (- mpow 1) lpow))))))
  (define (pitero lpow)
    (let ([r (piteri (- lpow 1) lpow)])
         (if r r (pitero (+ lpow 1)))))
  (pitero 1))

; This expression came out more like a K program than a Scheme one, but
; I still think it's pretty.
; (Obviously not syntactically, but in the sense that this expression does a
; "Take all the numbers from 1 to 1000 and filter from there" maneuver.)
(printf "~a~n"
  (ormap (lambda (n) (and (eq? (- n 1) (period n)) n))
         (filter prime? (reverse (for/list ([i 1000]) i)))))
