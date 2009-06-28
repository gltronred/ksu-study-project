module Hohmann
    where

data Burst = Burst Int Double Double

moveHohmann :: Int -> Double -> Double -> [Burst]
moveHohmann t0 r1 r2 = 
    [Burst t1 power1*cos(phi) power1*sin(phi), Burst t2 power2*cos(phi) -power2*sin(phi)]
    where
      t1 = t0
      t2 = t1 + tH
      tH = t0
      power1 = 0.0
      power2 = 0.0
      phi = 0.0