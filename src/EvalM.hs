module EvalM where

import Control.Parallel
import Control.Parallel.Strategies hiding (parMap, parList)
import Sudoku (Grid, solve)
import Data.List (splitAt)
import Control.DeepSeq (force)
import Control.Monad
import Strategy (parList, badParList)

-- parMap abstraction enables us to apply parallelism to
-- all the elements of a list.

parMap :: (a -> b) -> [a] -> Eval [b]
parMap f xs = mapM (rpar . f) xs



-- Multiple solutions without parallelism

sudoku1 :: [String] -> [Maybe Grid]
sudoku1 = fmap solve


-- Parallelism with fixed division of work.
sudoku2 :: [String] -> Eval [Maybe Grid]
sudoku2 puzzles = do
  let (as, bs) = splitAt (length puzzles `div` 2) puzzles
  as' <- rpar (force $ solve <$> as)
  bs' <- rpar (force $ solve <$> bs)
  rseq as'
  rseq bs'
  return (as' ++ bs')


-- Parallelism with dynamic division of work.
sudoku3 :: [String] -> Eval [Maybe Grid]
sudoku3 = parMap solve


-- Refactoring with strategies
sudoku4 :: [String] -> [Maybe Grid]
sudoku4 xs = (solve <$> xs) `using` (parList rseq)


-- Bad parList
sudoku5 :: [String] -> [Maybe Grid]
sudoku5 xs = (solve <$> xs) `using` (badParList rseq)
