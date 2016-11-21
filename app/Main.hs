module Main where

import Data.Time.Clock
import EvalM
import System.Environment
import Text.Printf
import Control.Parallel
import Control.Parallel.Strategies
import Control.Exception (evaluate)
import Data.Maybe


main :: IO ()
main = do
  [f] <- getArgs
  file <- readFile f
  let puzzles = lines file
      solutions = runEval $ sudoku3 puzzles
  print $ length $ filter isJust solutions

  
printTimeSince t0 = do
  t1 <- getCurrentTime
  printf "time: %.2fs\n" (realToFrac (diffUTCTime t1 t0) :: Double)








