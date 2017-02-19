module Par where

import Control.DeepSeq
import Control.Monad.Par hiding (spawn, parMap)
import Sudoku (Grid, solve)


-- Fork a computation in parallel and return an IVar that
-- can be used to wait for the result.
spawn :: NFData a => Par a -> Par (IVar a)
spawn p = do
  i <- new
  fork (do x <- p
           put i x)
  return i


parMap :: NFData b => (a -> b) -> [a] -> Par [b]
parMap f as = do
  ibs <- mapM (spawn . return . f) as
  mapM get ibs


-- Solving Sudokus with Par
sudoku6 :: [String] -> [Maybe Grid]
sudoku6 xs = runPar $ parMap solve xs
