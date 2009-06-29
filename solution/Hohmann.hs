module Hohmann
    where

import Burst

moveHohmann :: Int -> Double -> Double -> Double -> [Burst]
moveHohmann t0 x y r2 = 
    [Burst t1 (power1*cos(phi)) (power1*sin(phi)), Burst t2 (power2*cos(phi)) (-power2*sin(phi))]
    where
      gravitationalConstant = 6.67428e-11
      massOfEarth = 6.0e24
      mu = gravitationalConstant*massOfEarth
      t1 = t0
      r1 = sqrt(x*x + y*y)
      t2 = floor $ fromIntegral t1 + tH
      tH = pi * sqrt( (r1+r2)^3/8/mu )
      power1 = sqrt(mu/r1) * (sqrt(2*r2/(r1+r2)) - 1)
      power2 = sqrt(mu/r2) * (1 - sqrt(2*r1/(r1+r2)))
      phi = atan2 x y