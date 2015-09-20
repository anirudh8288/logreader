{-# LANGUAGE OverloadedStrings #-}
module Main (main) where

import Data.Text (Text)
import LogReader.Reader
import LogReader.Types
import TypeCount.Types hiding (lAfter)
import qualified Data.Map as M

firstCorrect :: [Log] -> Bool
firstCorrect [] = False
firstCorrect ((Log _ li):_) = elem Correct $ M.elems $ lAfter li

stats :: Exercise -> [(Text, Int, Int)]
stats (Exercise _ ts) =
    let g = (\ (User _ ls)-> if firstCorrect ls then 1 else 0)
        correctCount = sum . map g
        f = (\ (Task n us) -> (n,length us,correctCount us))
    in map f ts

main :: IO ()
main = do
    exercise <- readExercise "logs/typecount"
    print "(Exercise name, Unique users, Correct on first try)"
    mapM_ print $ stats exercise
