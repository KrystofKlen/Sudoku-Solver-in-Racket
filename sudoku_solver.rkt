#lang racket

;; making everything accessible for unit tests
(provide (all-defined-out))
;___________________________________________________________________________________________________________________________________________________________________________
(define ( len lst)
  (if (null? lst)
      0
      (+ 1 (len (cdr lst)))))

;___________________________________________________________________________________________________________________________________________________________________________
(define (atom? x)
  (not ( or (null? x) (pair? x))))

;___________________________________________________________________________________________________________________________________________________________________________
(define (get-matrix-col matrix col)
  (map (lambda (row) (my-nth row col)) matrix))

;___________________________________________________________________________________________________________________________________________________________________________
;; returns nth element from list
(define (my-nth lst n)
  (if (= n 0)
      (car lst)
      (my-nth (cdr lst) (- n 1))))

;___________________________________________________________________________________________________________________________________________________________________________
;; returns value from matrix with coordinated [row, col]
(define (get-value-at matrix row col)
  (my-nth (my-nth matrix row) col))

;___________________________________________________________________________________________________________________________________________________________________________
;; returns true if x is row contains x, otherwise returns false
(define ( contains-in-list? lst lst-len curr-index x)
  (if ( = lst-len curr-index)
      #f
      (if (= x (car lst))
          #t
          (contains-in-list? (cdr lst) lst-len (+ 1 curr-index) x ))))

;___________________________________________________________________________________________________________________________________________________________________________
;; returns initial index of square
(define ( get-suqare-initial-index dimension x)
  (- x (modulo x (sqrt dimension))))

;___________________________________________________________________________________________________________________________________________________________________________
;; returns index at which iteration of square should end
(define ( get-square-stop-index dimension from )
  (+ from (sqrt dimension )))

;___________________________________________________________________________________________________________________________________________________________________________
;; given coordinates of value (row column) this function returns square in which value is located
(define (get-square-wrapper matrix dimension row col)
  (let ([sq-init-r (get-suqare-initial-index dimension row)]
        [sq-init-c (get-suqare-initial-index dimension col)])
  (get-square matrix dimension
                sq-init-r
                sq-init-c
                (get-square-stop-index dimension sq-init-r )
                (get-square-stop-index dimension sq-init-c )
                null)))

;___________________________________________________________________________________________________________________________________________________________________________
;; return true = x is contained in square, otwerwise false
(define ( contains-in-squere matrix dimension row col x)
  ( contains-in-list?
    (get-square-wrapper matrix dimension row col)
    (len (get-square-wrapper matrix dimension row col))
    0
    x))
   
;___________________________________________________________________________________________________________________________________________________________________________
; returns elements in square
; emaple for row = 0, col = 0, stop-row = 2,stop-col = 2
; * * x x
; * * x x
; x x x x
; x x x x
; returns elements on * position.
(define (get-square matrix dimension row col stop-row stop-col lst )
  (if (= row stop-row)
      lst
      (let ([ curr-value (get-value-at matrix row col) ])
          (if (= col  ( - stop-col 1)  )
              (get-square   matrix dimension (+ 1 row) ( - (+ col 1) (sqrt dimension ))          stop-row stop-col  (cons curr-value lst) )
              (get-square   matrix dimension  row      (+ 1 col)  stop-row stop-col  (cons curr-value lst) )))))

;___________________________________________________________________________________________________________________________________________________________________________
;; returns true if number can be put into sudoku
(define ( num-is-valid? matrix dimension row col num )
  (and (not (contains-in-squere matrix dimension row col num))
  (and
      (not (contains-in-list? (my-nth matrix row) dimension 0 num))
      (not (contains-in-list? (get-matrix-col matrix col) dimension 0 num)))))



;___________________________________________________________________________________________________________________________________________________________________________
;unifies 2 lists
(define (my-append-lst lst1 lst2)
   (if (null? lst1)
       lst2
       (cons (car lst1) (my-append-lst (cdr lst1) lst2))))
;___________________________________________________________________________________________________________________________________________________________________________
; replaces element in list
(define (replace lst index num)
  (my-append-lst (take lst index) (cons num (drop lst (+ index 1)))))

;___________________________________________________________________________________________________________________________________________________________________________

(define (change-value-in-matrix matrix row col num)
  (replace matrix row (replace (my-nth matrix row) col num)))

;___________________________________________________________________________________________________________________________________________________________________________
;creates a list of numbers in range curr-stop
(define (loop-num curr stop lst)
  (if (= curr stop)
      lst
      (loop-num (+ curr 1) stop (cons curr lst))))

;___________________________________________________________________________________________________________________________________________________________________________
(define (fold fun init lst)
  (if (null? lst)
      init
      (fun (car lst) (fold fun init (cdr lst)))))

;___________________________________________________________________________________________________________________________________________________________________________
(define (map f lst)
  (fold (lambda (elem init)
          (cons (f elem) init)
          ) null lst))

;___________________________________________________________________________________________________________________________________________________________________________
(define (my-pair x y)
  (cons  x (cons y null)))

;___________________________________________________________________________________________________________________________________________________________________________
(define (cartesian-product-one n lst)
  (if (null? lst)
      null
      (cons (my-pair n (car lst)) (cartesian-product-one n (cdr lst)))))

;___________________________________________________________________________________________________________________________________________________________________________
; gives list of coordinates example for dimension = 9 ... ( (8 8) (8 7) (8 6) .... ( 0 0) )
; the coordinates are user for iteration of matrix
(define (cartesian-product lst1 lst2)
  (if (null? lst1)
      null
      (my-append-lst
      (cartesian-product-one (car lst1) lst2)
      (cartesian-product (cdr lst1) lst2))))

;___________________________________________________________________________________________________________________________________________________________________________
; iterates through the matrix and tries numbers and checks if it is a possible solution of sudoku
; if not it goes recursively back and tries another number
; return false when no number can be user at any field => sudoku does not have a solution.
(define (go matrix dimension lst values backtrack)
  (if(null? values)
     #f
     (if (null? lst)
         (cons #t matrix)
         (if
            (= 0 (get-value-at matrix  (car (car lst))   (cadr (car lst))))   
               (if
                (num-is-valid? matrix dimension (car (car lst))   (cadr (car lst)) (car values) )
                (let ([result (go
                              (change-value-in-matrix       matrix      (car (car lst))   (cadr (car lst))  (car values))
                              dimension
                              (cdr lst)
                              (loop-num 1 ( + dimension 1) null)
                              backtrack)])
                  (if (not (atom? result))
                      
                      result
                      
                      (go
                       (change-value-in-matrix     matrix      (car (car lst))    (cadr (car lst))  0)
                       dimension
                       lst
                       (cdr values)
                       backtrack)
                      ))
                   (go matrix dimension lst (cdr values) backtrack)
                   )
                 (go matrix dimension (cdr lst) (loop-num 1 ( + dimension 1) null) backtrack)
           ))))

;___________________________________________________________________________________________________________________________________________________________________________

(define (solve grid dimension)
  (go grid dimension (cartesian-product (loop-num 0 dimension null) (loop-num 0 dimension null)) (loop-num 1 ( + dimension 1) null) grid))

;___________________________________________________________________________________________________________________________________________________________________________

  
 (define (get-dimension grid)
   (len (my-nth grid 0)))
 
;___________________________________________________________________________________________________________________________________________________________________________

; usage: pass sudoku grid as a list of lists, if grid is not of size (n^2)*(n^2) where n>=1 program may fail.
; 0 in the given grid represents empty field.
; returns true + solved sudoku or false if given grid has no solutions.
(define (get-solution grid)
  (solve grid (get-dimension grid)))

#|

EXAMPLE INPUT -- please comment out to execute

(define matrix-yes-solution
   '(( 0 0 2 0 0 5 0 0 0  )
( 3 0 0 6 0 0 1 2 0  )
( 6 0 0 0 0 0 3 0 0  )
( 0 0 0 9 0 0 7 0 0  )
( 4 0 0 0 0 0 2 0 3  )
( 0 0 9 0 0 0 0 0 0  )
( 5 0 0 0 0 0 9 0 0  )
( 0 6 0 0 0 0 0 0 0  )
( 8 0 0 0 6 0 0 0 0  )
))

(define matrix-no-solution
   '(
    (0 9 0  4 5 6  7 8 9) 
    (0 4 0  2 5 0  1 0 7) 
    (8 0 7  6 0 0  4 0 3)
    
    (0 1 2  8 3 1  6 0 0) 
    (9 7 0  0 4 0  0 3 5) 
    (0 0 4  0 0 2  3 1 0)
    
    (2 0 1  0 0 7  5 0 0) 
    (4 0 9  0 8 1  0 6 0) 
    (8 8 8  8 0 0  8 8 8)))

(get-solution matrix-yes-solution)
(get-solution matrix-no-solution)

|#