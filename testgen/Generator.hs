module Generator where

import Control.Monad
import Data.List
import Data.Maybe
import System.IO
import System.IO.Unsafe
import System.Random
import Test.QuickCheck

data Token = Token String deriving Eq
data Rule = Rule Token [[Token]]
data BNF = BNF [Token] [Rule] [Rule] Token deriving Show

instance Show Token where
    show (Token x) = x
instance Show Rule where
    show (Rule start sequences) = (show start) ++ ">>" ++ (foldr (++) "" $ intersperse "|" $ map (\x -> concat $ intersperse " " $ map show x) sequences)

getToken (Rule token _) = token
getSequences (Rule _ sequences) = sequences

createTestSet fname ext convertor count bnf = do
  testSet <- replicateM count (newStdGen >>= (\rnd -> return $ generate 10000 rnd $ generateSentence bnf))
  -- print $ length testSet
  sequence_ $ zipWith (writeToFile fname ext convertor) [1..] testSet
 
writeToFile name_prefix suffix convertor n x = do 
  h <- openFile (name_prefix ++ pad n ++ "." ++ suffix) WriteMode 
  hPutStrLn h $ convertor x
  hClose h 
    where pad n = reverse $ take 4 $ (reverse $ show n) ++ (repeat '0')

generateSentence bnf = sized $ generateSentence' bnf

generateSentence' (BNF nonterm termination rules start) n = generateNext n nonterm termination rules [start]

generateNext 0 nonterm termination rules sentence = applyRule' termination sentence
generateNext n nonterm termination rules sentence = if find (\x -> elem x nonterm) sentence == Nothing
                                                    then return sentence
                                                    else do
                                                      next <- applyRule' rules sentence
                                                      generateNext (n-1) nonterm termination rules next

applyRule' rules sentence = liftM concat $ sequence $ map (applyRule rules) sentence

applyRule rules token = maybe (return [token]) (elements . getSequences) rule
    where rule = find (\x -> getToken x==token) rules

-- filterNonTerm nonterm sequences = filter (\x -> not $ or $ map (\y -> elem y nonterm) x) sequences

testNonRecursiveCase = BNF 
                       [Token "A",Token "B"] 
                       [Rule (Token "A") [[Token "an",Token "c"]],
                        Rule (Token "B") [[Token "an",Token "eof"]]]
                       [Rule (Token "A") [[Token "B"],[Token "an",Token "c"]] , 
                        Rule (Token "B") [[Token "an"],[Token "eof"]] ] 
                       (Token "A")

testRecursiveCase = BNF
                    [Token "A"]
                    [Rule (Token "A") [[Token "(", Token ")"]]]
                    [Rule (Token "A") [[Token "(",Token "A",Token ")"], []]]
                    (Token "A")