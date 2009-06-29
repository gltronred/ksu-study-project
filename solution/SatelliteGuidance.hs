module SatelliteGuidance
   where

import Serializer
import Data.Word
import Control.Monad
data Program = Program [(Word32, [(Word32, Double)])]
data CompactifiedInteger = Number Integer | InfinitePoint deriving Show

getPVM (addr, value) = PVMapping addr value
getPVMs = map getPVM
getFrame (timeStamp, pvms) = if (null pvms) 
                                then []
                                else [Frame timeStamp (fromIntegral $ length pvms) (getPVMs pvms)] 
getSolution (Program list) = Solution ourHeader ((>>= getFrame) list)
getSolutionTerminated (Program list) terminationMoment = Solution ourHeader (((>>= getFrame) list) ++ [Frame terminationMoment 0 []]) 
filterUnique list1 list2 = map snd $ filter (\ (a,b) -> a /= b) $ zip list1 list2 
filterSimFrame (i, list1) (j, list2) = (j, filterUnique list1 list2)
finDiff op [] = []
finDiff op l = head l:finDiff' op l
finDiff' op [] = []
finDiff' op (x:xs) = if (null xs) then []
                                  else (op x (head xs)):finDiff' op xs
filterProgram (Program list) = Program (finDiff filterSimFrame list)

subtractCompactified (Number a) (Number b) = Number (a - b)
subtractCompactified _ _ = InfinitePoint

compactifyProgram (Program list) = map (\(a,l)->(Number (fromIntegral a), map snd l)) list
augmentWithInfinity l = (tail l) ++ [(InfinitePoint, [])]
subtractFrames (a, l1) (b, l2) = (subtractCompactified a b, l2)
getFinDiff l = zipWith subtractFrames (augmentWithInfinity l) l
printPorts = putStrLn . unwords . map show
createIOStream (Number a, ports) = replicateM_ (fromIntegral a) $ printPorts ports
createIOStream (InfinitePoint, ports) = forever $ printPorts ports
runIOStream list = sequence_ [createIOStream l| l <- list]
runIOProgram = runIOStream . getFinDiff . compactifyProgram