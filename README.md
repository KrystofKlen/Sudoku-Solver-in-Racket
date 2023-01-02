# Assignment name
Sudoku solver in Racket - university project.

## Example usage

 1) Type sudoku grid into matrix (list of lists). 0 in the given grid represents empty field.
Example :<br />

`(define matrix1
   '(( 6 6 0 0 0 5 0 0 0  )
( 0 0 0 0 0 0 0 0 0  )
( 0 0 0 0 2 0 0 0 5  )
( 0 2 0 0 0 4 0 9 0  )
( 0 0 0 0 0 0 0 1 0  )
( 0 0 0 2 0 0 0 6 0  )
( 0 0 4 0 0 0 0 0 0  )
( 0 0 0 0 3 0 0 7 2  )
( 9 0 0 0 6 2 4 0 0  )
))`

2) Pass this matrix into get-solution<br />
Example:<br />
  `(get-solution matrix1)`

3) Result:<br />
    If grid is not of size (n^2)*(n^2) where n>=1 then the program may fail.
    Returns true + solved sudoku or false if given grid has no solutions.


## Testing

`Tester.java` has it's own implementation of sudoku solver. It is used to independently test result grids from Racket. It works on it's own and hasn't any connection to the sudoku solver in Racket.

`racket tests9x9.rkt > result1.txt`<br />
`racket tests4x4.rkt > result2.txt`<br />
`racket tests16x16.rkt > result3.txt`<br />
`javac Tester.java`<br />
`java Tester`<br />

expected result:<br />
    9x9 OK tests executed: 71<br />
    4x4 OK tests executed: 40<br />
    16x16 OK tests executed: 4<br />


`racket tests_grids_with_no_solution.rkt`<br />

expected result:<br />
     OK<br />


`racket tests1x1.rkt`<br />

expected result:<br />
     OK<br />

`racket tests_functions.rkt`<br />

expected result:<br />
     OK<br />
