module Burst
    where

import Serializer (Solution)
import SatelliteGuidance
import Data.Binary

data Burst = Burst Int Double Double deriving Show

convertBurst :: [Burst] -> Solution
convertBurst = getSolution . getProgram

getProgram :: [Burst] -> Program
getProgram l = Program $ foldl (++) [] $ map getElem l

getElem :: Burst -> [(Word32, [(Word32,Double)])]
getElem (Burst t x y) = [(fromIntegral t, [(2,x), (3,y)]), (fromIntegral $ t+1, [(2,0), (3,0)])]