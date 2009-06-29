module Burst
    where

import Serializer (Solution)
import SatelliteGuidance
import Data.Binary

data Burst = Burst Int Double Double deriving Show

convertBurst :: Int -> [Burst] -> Solution
convertBurst scenario l = getSolution $ getProgram scenario l

getProgram :: Int -> [Burst] -> Program
getProgram scenario l = Program $ foldl (++) [(0, [(16000,fromIntegral scenario)])] $ map (getElem scenario) l

getElem :: Int -> Burst -> [(Word32, [(Word32,Double)])]
getElem scenario (Burst t x y) = 
    [(fromIntegral t, 
      [(16000,fromIntegral scenario), 
       (2,x), 
       (3,y)]), 
     (fromIntegral $ t+1, 
      [(16000,fromIntegral scenario), 
       (2,0), 
       (3,0)])]