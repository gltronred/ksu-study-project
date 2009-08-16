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
data BNF a = BNF [Token] (Token -> Gen [a]) [Rule] Token

instance Show Token where
    show (Token x) = x
instance Show Rule where
    show (Rule start sequences) = (show start) ++ ">>" ++ (foldr (++) "" $ intersperse "|" $ map (\x -> concat $ intersperse " " $ map show x) sequences)

getToken (Rule token _) = token
getSequences (Rule _ sequences) = sequences

generateSentence bnf = sized $ generateSentence' bnf

generateSentence' (BNF nonterm terminator rules start) n = generateNext n nonterm terminator rules [start]

generateNext 0 nonterm terminator rules sentence = applyRule' terminator sentence
generateNext n nonterm terminator rules sentence = if find (\x -> elem x nonterm) sentence == Nothing
                                                    then applyRule' terminator sentence
                                                    else do
                                                      next <- applyRule' (applyRule rules) sentence
                                                      generateNext (n-1) nonterm terminator rules next

applyRule' action sentence = liftM concat $ sequence $ map action sentence

applyRule rules token = maybe (return [token]) (elements . getSequences) rule
    where rule = find (\x -> getToken x==token) rules

-- filterNonTerm nonterm sequences = filter (\x -> not $ or $ map (\y -> elem y nonterm) x) sequences

testNonRecursiveCase = BNF 
                       [Token "A",Token "B"] 
                       term
                       [Rule (Token "A") [[Token "B"],[Token "an",Token "c"]] , 
                        Rule (Token "B") [[Token "an"],[Token "eof"]] ] 
                       (Token "A")
    where term (Token "A") = return [Token "an",Token "c"]
          term (Token "B") = return [Token "an",Token "eof"]
          term x = return [x]

testRecursiveCase = BNF
                    [Token "A"]
                    (\x -> if x==Token "A" then return [Token "(", Token ")"] else return [x])
                    [Rule (Token "A") [[Token "(",Token "A",Token ")"], []]]
                    (Token "A")