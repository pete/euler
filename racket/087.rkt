#! /usr/bin/env racket
#lang racket

; How many numbers below fifty million can be expressed as the sum of a prime
; square, prime cube, and prime fourth power?

; The Go version was quick, easy to write.  Thought I'd try a Racket version.
; The Racket version was easy to write, but I keep getting the feeling that it
; could be done more nicely.  (I had a recursive version, but I killed it after
; a few minutes; I probably did something incorrect.)  On the other hand, this
; version is more readable and was more fun to write than the Go version.

; 1.2s whether I used the compiler or interpreter.  (The compiler took 20s to
; compile this program, though.  Obscene.)  The Go version was substantially
; faster, but it used a completely different algorithm, so it isn't comparable.

(require math/number-theory)

(define nmax 50000000)
(define pmax 7079)

(define (res a b c)
  (+ (expt a 2) (expt b 3) (expt c 4)))

(define primes
  (filter prime? (range pmax)))
(define as
  (filter (lambda (n) (< (expt n 2) (- nmax 24))) primes))
(define bs
  (filter (lambda (n) (< (expt n 3) (- nmax 20))) as))
(define cs
  (filter (lambda (n) (< (expt n 4) (- nmax 12))) bs))

(define hits (make-hash))

(define (populate!)
  (for* ([a as] [b bs] [c cs])
    (let ([r (res a b c)])
          (when (< r nmax) (hash-set! hits r #t)))))

(populate!)
(printf "~a~n" (hash-count hits))
