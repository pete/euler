#! /usr/bin/env racket
#lang racket

; Find ∑ S for every pair of consecutive primes with 5 ≤ p1 ≤ 1000000,
; S being the smallest multiple of the next prime after p1 that ends with p1.

; I think this wins the highest number for a solution that is this cheesy.
; You know how to find prime numbers, everyone does, this repo is full of
; sieves.  The Chinese remainder is easy to calculate once you know how to
; do it.  In this program, none of those things are demonstrated, because
; Racket comes with all that in its standard library.
;
; Initially, this had been a straightforward port of the Ruby version, but
; even compiled, it ran at least twice as long as the Ruby version before
; I stopped it.  I happened to scroll past "solve-chinese" while reading
; the manual for math/number-theory and didn't read past the name.  So as
; soon as I saw that, I hopped back over to the tab with the Racket manual

; 1.21s.

(require math/number-theory)

(define (pmod n)
  (cond [(> n 100000) 1000000]
        [(> n  10000)  100000]
        [(> n   1000)   10000]
        [(> n    100)    1000]
        [(> n     10)     100]
        [#t 10]))

(define (find-s p1)
  (solve-chinese (list 0 p1) (list (next-prime p1) (pmod p1))))

(define (sum-s p1 t)
  (if (> p1 1000000) t
      (sum-s (next-prime p1) (+ t (find-s p1)))))

(printf "~a~n" (sum-s 5 0))
