#lang racket/base
 
(require rackunit "sudoku_solver.rkt")

; Tests if get-solution returns false for unsolvable grids.

(define matrix0
   '(( 4 3 3 3  )
( 0 0 0 0  )
( 3 2 0 1  )
( 0 4 3 2  )
))

(define matrix1
   '(
    (0 9 3  4 5 6  7 8 9) 
    (0 4 0  2 5 0  1 0 7) 
    (8 0 7  6 0 0  4 0 3)
    
    (0 1 2  8 0 0  6 0 0) 
    (9 7 0  0 4 0  0 3 5) 
    (0 0 4  0 0 2  9 1 0)
    
    (2 0 1  0 0 7  5 0 0) 
    (4 0 9  0 8 1  0 6 0) 
    (8 8 8  8 8 8  8 8 8)))



(check-equal? #f (get-solution matrix0))
(check-equal? #f (get-solution matrix1))
(display "OK\n")
(exit)
