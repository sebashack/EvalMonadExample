# Paralellism with the Eval Monad

Within the module Control.Parallel.Strategies rpar is the operation
which enables us to create parallelism. We can partition the amount
of work in a fixed way, or we can partition it dynamically at run
time so that we keep our processors always busy since GHC automatically
distributes the parallel work in the pool of generated sparks.
A nice abstraction to achieve this dynamic parallelism is parMap.

parMap is already built in Control.Parallel.Strategies but here I easily
define it using mapM.

This example has been taken from the book:
Parallel and Concurrent Programming In Haskell, By Simon Marlow

Note that in src/EvalM there are 3 versions of sudoku. You can freely replace
any of them in Main.hs so that you can observe performance differences by
using +RTS -s or a profiling tool like threadscope with +RTS -l
