module Strategy (parList, badParList) where

import Control.Parallel
import Control.Parallel.Strategies hiding ( parMap
                                          , parList
                                          , evalList
                                          , using
                                          , parPair )
import Sudoku (Grid, solve)
import Data.List (splitAt)
import Control.DeepSeq (force)
import Control.Monad


-- Perform some computation using a Strategy
using :: a -> Strategy a -> a
x `using` s = runEval (s x)


-- Example: parPair
someCompt :: Int -> Int
someCompt = undefined

parPair :: Strategy (a,b)
parPair (a,b) = do
  a' <- rpar a
  b' <- rpar b
  return (a',b')

val = (someCompt 35, someCompt 36) `using` parPair




-- A Strategy for Evaluating a List in Parallel -------------->>

{-
   We can think of parMap as a composition of two parts:
     1) The algorithm: map
     2) The parallelism: evaluating the elements of a list in parallel.
-}

-- Now we can define parList in terms of evalList, using rparWith
parList :: Strategy a -> Strategy [a]
parList strat = evalList (rparWith strat)

-- evalList is a parameterized Strategy on lists.
evalList :: Strategy a -> Strategy [a]
evalList strat = mapM strat




-- GC'd Sparks: Bad Optimization -------------------------->>

badParList :: Strategy a -> Strategy [a]
badParList strat xs = do
  go xs
  return xs
  where
    go [] = return ()
    go (x:xs) = do
      rparWith strat x
      go xs
