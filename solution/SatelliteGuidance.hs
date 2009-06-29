module SatelliteGuidance
   where

import Serializer
import Data.Word
import Control.Monad
data Program = Program [(Word32, [(Word32, Double)])]

getPVM (addr, value) = PVMapping addr value
getPVMs = map getPVM
getFrame (timeStamp, pvms) = if (null pvms) 
                                then []
                                else [Frame timeStamp (fromIntegral $ length pvms) (getPVMs pvms)] 
getSolution (Program list) = Solution ourHeader ((>>= getFrame) list)
getSolutionTerminated (Program list) terminationMoment = Solution ourHeader (((>>= getFrame) list) ++ [Frame terminationMoment 0 []]) 
filterUnique list1 list2 = map snd $ filter (\ (a,b) -> a /= b) $ zip list1 list2 
filterSimFrame (i, list1) (j, list2) = (j, filterUnique list1 list2)
filterProgramList [] = []
filterProgramList l = head l:filterProgramList' l
filterProgramList' [] = []
filterProgramList' (x:xs) = if (null xs) then []
                                     else (filterSimFrame x (head xs)):filterProgramList' xs
filterProgram (Program list) = Program (filterProgramList list)