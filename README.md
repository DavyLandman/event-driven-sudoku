Event Driven Sudoku
=============

This is a very simple sudoku solver, it uses events to cancel out possible cell
values, and when this does not result in a solution, it just makes a guess and
backtracks if it was the wrong guess.

To run/fork
-------
- Clone the repository
- `git submodule init`
- `git submodule update`
- windows: `ruby solve_sudoku.rb sudokus\fiendish.sraw`
- unix: `./solve_sudoku.rb sudokus/fiendish.sraw`

TODO
------
- Be smarter about the selection of which candidates to use while guessing
  (hidden singles are easy to detect)
- Avoid duplication in the guessing (memoization)
- Reduce the size `Sudoku.initialize_units` and `Sudoku.get_unit`

