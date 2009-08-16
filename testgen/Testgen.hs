{-# OPTIONS_GHC -XDeriveDataTypeable #-}

module Testgen 
    where

import qualified Control.Exception as E
import Control.Monad
import Data.Typeable
import System.Exit
import System.Environment
import System.IO
import System.Random
import Test.QuickCheck

data Verdict = AC | PE | WA  deriving (Eq, Show, Ord)

data PEException = PEException deriving (Show, Typeable)
instance E.Exception PEException

verdict AC = hPutStrLn stderr "AC" >> exitSuccess
verdict PE = hPutStrLn stderr "PE" >> exitWith (ExitFailure 4)
verdict WA = hPutStrLn stderr "WA" >> exitWith (ExitFailure 5)

checkPE method handle = catch (method handle) (\e -> verdict PE)
useFile filename inputAction = withFile filename ReadMode (checkPE inputAction)

safeReadIO x = if null res
               then E.throw PEException
               else return $ fst $ res!!1
    where res = reads x

safeInput filename = useFile filename (\h -> hGetContents h >>= safeReadIO)

openFiles = do testInput:userOutput:correctAns:c <- getArgs; return (testInput, userOutput, correctAns)

createTestSet gen start count = do
  testSet <- replicateM count (newStdGen >>= (\rnd -> return $ generate 10000 rnd gen))
  sequence_ $ zipWith writeTo2File [start..] testSet

writeTo2File n test = do
  writeToFile "dat" num $ fst test
  writeToFile "ans" num $ snd test
    where num = show n

writeToFile suffix n x = do 
  h <- openFile (pad n ++ "." ++ suffix) WriteMode 
  hPutStrLn h $ show x
  hClose h 
    where pad n = reverse $ take 3 $ (reverse $ show n) ++ (repeat '0')

runCheck :: (Read input, Read output, Read correct) => (input -> output -> correct -> Verdict) -> IO ()
runCheck checker = do
  (i,o,c) <- openFiles
  input <- safeInput i
  output <- safeInput o
  correct <- safeInput c
  verdict $ checker input output correct

runTestgen :: (Show input, Show correct) => Gen (input, correct) -> Int -> Int -> IO ()
runTestgen generator = createTestSet generator

runTests :: (Show input, Show correct) => Gen (input, correct) -> (input -> output) -> (input -> output -> correct -> Verdict) -> Int -> IO ()
runTests generator solve checker count = check (defaultConfig {configMaxTest = count}) $ forAll generator $ \(i,c) -> checker i (solve i) c == AC

runTestsCollecting :: (Show input, Show correct, Show a) => Gen (input, correct) -> (input -> output) -> (input -> output -> correct -> Verdict) -> Int -> (input -> correct -> a) -> IO ()
runTestsCollecting generator solve checker count collector = check (defaultConfig {configMaxTest = count}) $ forAll generator $ \(i,c) -> collect (collector i c) (checker i (solve i) c == AC)