#lang racket/base
 
(require rackunit "sudoku_solver.rkt")

(define matrix0
  '((0)
  ))

(define matrix1
  '((1)
  ))

(check-equal? (cons #t (cons '(1) null)) (get-solution matrix0))
(check-equal? (cons #t (cons '(1) null)) (get-solution matrix1))
(display "OK\n")
(exit)