{-# OPTIONS_GHC -XMultiParamTypeClasses #-}

import Testgen
import Control.Monad
import Data.Char
import Test.QuickCheck
import Text.ParserCombinators.Parsec

-- These types are declared for each problem

data Input = Input [Int] -- List of integers
data Output = Output Int -- Sum of input
data Correct = Correct Int -- Double sum of input (because correct is not output in general)
data Problem = Problem Input Output Correct

-- Procedures to read and write input, output and correct data (e.g. with Parsec)

input :: Parser [Int]
input = do
  first <- liftM read $ many1 digit
  next <- remaining
  return $ first:next

remaining = (char ',' >> spaces >> input) <|> (return [])

instance Read Input where
    readsPrec _ str = either (\_ -> []) (\x -> [(Input x,"")]) $ parse input "" str
instance Show Input where
    show (Input l) = foldl (\x y -> x++" "++y) "" $ map show l

instance Read Output where
    readsPrec _ = \x -> [(Output $ read x, "")]
instance Show Output where
    show (Output x) = show x

instance Read Correct where
    readsPrec _ = \x -> [(Correct $ read x, "")]
instance Show Correct where
    show (Correct x) = show x

genList :: Gen Input
genList = sized $ \n -> do
            k <- choose (0,n)
            liftM Input $ genList' k
genList' n = sequence [ choose (0,maxInt) | _ <- [1..n]]
    where maxInt = 1000

myChecker :: Input -> Output -> Correct -> Verdict
myChecker (Input input) (Output output) (Correct correct) = if 2*output == correct then AC else WA

myGenerator :: Gen (Input, Correct)
myGenerator = genList >>= (\(Input x) -> return (Input x, Correct $ 2*sum x))

mySolve (Input x) = Output $ sum x

-- main = runCheck myChecker
-- main = runTestgen myGenerator 2 200
-- main = runTests myGenerator mySolve myChecker 2000
main = runTestsCollecting myGenerator mySolve myChecker 2000 (\(Input i) (Correct c) -> length i)