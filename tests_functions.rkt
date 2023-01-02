#lang racket

(require rackunit "sudoku_solver.rkt")

(require compatibility/defmacro)


(define-macro (my-assert expr expected)
  `(let ([tmp ,expr])
     (if (equal? tmp ,expected)
         (void)
         (println ( format "Assert failed: given ~a evaluated: ~a expected ~a" ',expr tmp ,expected)))))

(define-macro (my-assert-true expr)
     `(if ( equal? #t ,expr )
         (void)
         (println ( format "Assert-true failed: given ~a" ',expr))))

(define-macro (my-assert-false expr)
     `(if ( equal? #f ,expr )
         (void)
         (println ( format "Assert-false failed: given ~a" ',expr))))


(my-assert  (my-append-lst '(1 2) '(3 4)) '(1 2 3 4))
(my-assert (my-append-lst '(1 2) '(3 4 4 5 4)) '(1 2 3 4 4 5 4))
(my-assert (replace '(1 2 3 4 5 6) 0 100) '(100 2 3 4 5 6))

(define matrix0
   '(( 0 0 2 0 0 0 0 7 0  )
( 3 0 0 0 7 0 0 0 0  )
( 6 7 8 0 0 0 0 0 5  )
( 0 2 0 0 0 0 0 8 0  )
( 0 0 0 7 8 0 0 9 0  )
( 0 0 0 2 0 0 3 7 1  )
( 5 0 0 8 1 2 0 0 0  )
( 0 6 0 0 9 1 0 0 0  )
( 0 0 0 0 0 4 0 0 0  )
))


(my-assert (get-value-at matrix0 1 0) 3)
(my-assert (get-value-at matrix0 6 0) 5)
(my-assert (len '(1 2 3 4 5)) 5)
(my-assert (get-dimension matrix0) 9)
(my-assert (get-square matrix0 9 6 6 9 9 null) '(0 0 0 0 0 0 0 0 0 )) 

(my-assert-true (contains-in-list? '(1 2 3) 3 0 3) )
(my-assert-false (contains-in-list? '(1 2 3) 3 0 4) )
(my-assert-false (contains-in-list? '() 0 0 4) )

(my-assert-true(num-is-valid? matrix0 9 0 0 4))
(my-assert-false(num-is-valid? matrix0 9 0 0 3))
(my-assert-false(num-is-valid? matrix0 9 0 0 5))
(my-assert-false(num-is-valid? matrix0 9 0 0 6))
(my-assert-false(num-is-valid? matrix0 9 0 0 7))
(my-assert-false(num-is-valid? matrix0 9 0 1 7))
(my-assert-false(num-is-valid? matrix0 9 0 0 2))

(my-assert-false(num-is-valid? matrix0 9 8 8 1))
(my-assert-true(num-is-valid? matrix0 9 8 8 2))
(my-assert-true(num-is-valid? matrix0 9 8 8 3))
(my-assert-false(num-is-valid? matrix0 9 8 8 4))
(my-assert-false(num-is-valid? matrix0 9 8 8 5))

(display "OK\n")
(exit)

