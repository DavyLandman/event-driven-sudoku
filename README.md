Event Driven Sudoku
=============

This is a very simple sudoku solver, it uses events to cancel out possible cell
values, and when this does not result in a solution, it just makes a guess and
backtracks if it was the wrong guess.

To download and run/fork
-------
- Clone the repository
- `git submodules`
- `git submodule update`

TODO
------
- Be smarter about the selection of which candidates to use while guessing
  (hidden singles are easy to detect)
- Avoid duplication in the guessing (memoization)

