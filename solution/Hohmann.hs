module Hohmann
    where

import Burst

gravitationalConstant = 6.67428e-11
massOfEarth = 6.0e24
mu = gravitationalConstant*massOfEarth

radius x y = sqrt(x*x + y*y)

timeHohmann r1 r2 = pi * sqrt( (r1+r2)^3/8/mu )

power1Hohmann r1 r2 = sqrt(mu/r1) * (sqrt(2*r2/(r1+r2)) - 1)
power2Hohmann r1 r2 = sqrt(mu/r2) * (1 - sqrt(2*r1/(r1+r2)))

moveHohmann :: Int -> Double -> Double -> Double -> Double -> [Burst]
moveHohmann t0 rotation x y r2 = 
    [Burst t1 (rotation*power1*cos(phi)) (rotation*power1*sin(phi)), Burst t2 (-rotation*power2*cos(phi)) (-rotation*power2*sin(phi))]
    where
      t1 = t0
      r1 = radius x y
      t2 = floor $ tH + fromIntegral t1
      tH = timeHohmann r1 r2
      power1 = power1Hohmann r1 r2
      power2 = power2Hohmann r1 r2
      phi = atan2 y x