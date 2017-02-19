module Main where

import Data.Time.Clock
import EvalM (sudoku1, sudoku2, sudoku3, sudoku4, sudoku5)
import Par (sudoku6)
import System.Environment
import Text.Printf
import Control.Parallel
import Control.Parallel.Strategies
import Control.Exception (evaluate)
import Data.Maybe


main :: IO ()
main = do
  [f, cmd] <- getArgs
  file <- readFile f
  let puzzles = lines file
  t0 <- getCurrentTime
  case cmd of
    "sudoku1" -> do
      let solutions = sudoku1 puzzles
      print $ length $ filter isJust solutions
      printTimeSince t0
    "sudoku2" -> do
      let solutions = runEval $ sudoku2 puzzles
      print $ length $ filter isJust solutions
      printTimeSince t0
    "sudoku3" -> do
      let solutions = runEval $ sudoku3 puzzles
      print $ length $ filter isJust solutions
      printTimeSince t0
    "sudoku4" -> do
      print $ length $ filter isJust (sudoku4 puzzles)
      printTimeSince t0
    "sudoku5" -> do
      print $ length $ filter isJust (sudoku5 puzzles)
      printTimeSince t0
    "sudoku6" -> do
      print $ length $ filter isJust (sudoku6 puzzles)
      printTimeSince t0


printTimeSince :: UTCTime -> IO ()
printTimeSince t0 = do
  t1 <- getCurrentTime
  printf "time: %.2fs\n" (realToFrac (diffUTCTime t1 t0) :: Double)
