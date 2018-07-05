#! /usr/bin/env racket
#lang racket

; Given that F[k] is the first Fibonacci number for which the first nine digits
; AND the last nine digits are 1-9 pandigital, find k.

; The Go version took 17 seconds—*forever*!  I saw a clever solution in the
; thread after completing it, but I wanted to play with doing this in Racket
; *without* converting the number to a string.

; Bitbanging is a little verbose in Racket, but I feel like I'm (more or less)
; getting my Scheme legs back under me.  Except that I had to look things up
; every time I wanted to call a function (and who wants to call it bitwise-ior?),
; this would have taken less time to write than the Go version, I think.

; That turned out to take 138s.  I didn't misplace the decimal.  This is the
; same algorithm as the Go version but didn't mess with string conversions
; and ended up way, way slower.  So then I made a version that used strings.
; That took 17s to run.  Same as the Go version.

(define (pd? x)
  (define (pdp x a)
    (if (eq? x 0) a
        (let ([m (modulo x 10)]
              [x (quotient x 10)])
          (pdp x (bitwise-ior a (arithmetic-shift 1 (- m 1)))))))
  (and (<= 123456789 x 987654321) (eq? #x1ff (pdp x 0))))

; This version doesn't work due to something I'm doing that makes
; Racket angry, namely the divide by zero and the float problem.
(define (first9-fails x)
  (if (< x 1000000000) x
      (quotient x (expt 10 (- (floor (log x 10)) 9)))))
; This version was responsible for most of the speed problems:
(define (first9-slow x)
  (if (< x 1000000000) x
      (first9 (quotient x 10))))

; This version has disappointed its dad.
(define (first9-disappoint x)
  (if (< x 1000000000) x
      (string->number (substring (number->string x) 0 9))))

; There must be a better way.
(define first9 first9-disappoint)

(define (last9 x)
  (modulo x 1000000000))

(define (find-dp p c a)
  ; A progress bar of sorts, because it was slow as hell:
  ;(when (= 0 (modulo a 1000)) (printf "~a~n" a))
  (if (and (pd? (last9 c)) (pd? (first9 c))) a
    (find-dp c (+ p c) (+ a 1))))

(printf "~a~n" (find-dp 1 1 2))
