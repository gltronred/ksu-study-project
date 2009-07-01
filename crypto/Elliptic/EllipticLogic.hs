module EllipticLogic
   where

import Control.Monad.Instances
import Control.Monad
import Data.Maybe
import System.Random
import Data.List
import Data.Char

data ModNum = GF Integer Integer | Infinite deriving (Eq,Read, Show)
{-
instance Show ModNum
   where
   show (GF _ num) = show num
   show Infinite = "Infinite"
-}
instance Num ModNum
         where
         
         (GF p a) + (GF q b)  = if (p==q) then GF p ((a+b) `mod` p)
                                          else error "Incompatible modulos in addition!"         
         Infinite + _ = Infinite
         _ + Infinite = Infinite
         
         (GF p a) - (GF q b)  = if  (p==q) then GF p ((p+a-b) `mod` p)
                                           else error "Incompatible moduli"
         Infinite - x = Infinite
         x - Infinite = Infinite
         (GF p a) * (GF q b)  = if (p==q) then GF p ((a*b) `mod` p)
                                          else error "Incompatible modulos in multiplication!"
         Infinite * _ = Infinite
         
         _ * Infinite = Infinite
  
         fromInteger x = error "RSALogic.ModNum -- no fromInteger."
         signum x = error "RSALogic.ModNum -- no signum."
         abs x = error "RSALogic.ModNum -- no abs."

(.*) 1 (x,y) = (x,y)
--(.*) k (x,y) = ellipticSum ((k-1) .* (x,y)) (x, y) 
inverse (GF p 0) = Infinite
inverse (GF p a) = (GF p a)^(p-2)
ellipticMul  (a,b,p) (x,y) k = (!!(k-1)) $ iterate (ellipticSum (a,b,p) (x,y)) (x,y)
ellipticSum  (a,b,p) (x1,y1) (x2, y2)  | (x1, y1) == (Infinite, Infinite) = (x2,y2)
                                       | (x2, y2) == (Infinite, Infinite) = (x1,y1)
                                       | (x1, y1) /= (x2,y2) = 
                                            let lambda = (y2 - y1) * inverse (x2-x1)
                                                x3 = lambda^2 - x1 - x2
                                                y3 = lambda * (x1 - x3) - y1
                                            in (x3, y3)        
                                       | otherwise = let lambda = ((GF p 3) * x1^2 + (GF p a)) * inverse ((GF p 2)*y1)
                                                         x3 = lambda^2 - (x1+x1)
                                                         y3 = lambda * (x1 - x3) - y1
                                                      in (x3, y3)

ellipticNeg (a,b,p) (Infinite, GF q u) = (Infinite, GF p ((p - u) `mod` p))
ellipticNeg (a,b,p) (GF q u, Infinite) = (GF p u, Infinite)
ellipticNeg (a,b,p) (GF q x, GF q2 y) = (GF p x, GF p ((p-y) `mod` p))
      
allPoints a b p      = (:) (Infinite, Infinite) $ map (\(u,v) -> (GF p u, GF p v)) 
                                                   $ filter (\(x, y) -> (x^3 + a*x + b) `mod` p == (y^2) `mod` p) 
                                                     $ join (liftM2(,)) [0..p-1]
numberOfPoints a b p = length $ allPoints a b p

encryptElliptic (a,b,p) n k baseElement publicKey plainTextElement =
  let curve = allPoints a b p
      m = curve!!(fromEnum plainTextElement)
   in (ellipticMul (a,b,p) baseElement k,ellipticSum (a,b,p) m (ellipticMul (a,b,p) publicKey k))
                 

decryptElliptic (a,b,p) n baseElement privateKey (c1, c2) = 
  let  curve = allPoints a b p
       answer = ellipticSum (a,b,p) c2 (ellipticMul (a,b,p) (ellipticNeg (a,b,p) c1) privateKey)
       result = fromJust $ findIndex (==answer) curve
    in result
decryptString (a,b,p) n baseElement publicKey = map (decryptElliptic (a,b,p) n baseElement publicKey)
encryptString (a,b,p) n k baseElement publicKey = map (encryptElliptic (a,b,p) n k baseElement publicKey)

decryptStr (a,b,p) n baseElement privateKey string =  (>>= return . chr) $ decryptString (a,b,p) n baseElement privateKey (read string :: [((ModNum, ModNum),(ModNum,ModNum))])
encryptStr (a,b,p) n k baseElement publicKey string = show $ encryptString (a,b,p) n k baseElement publicKey $ map ord string

generateKeys (a,b,p) baseElement n = 
   do k <- randomRIO (1,n-1)
      publicKey <- return $ ellipticMul (a,b,p) baseElement k
      return (k, publicKey) 

encryptDriver (a,b,p) baseElement pk string = 
   do n <- return $ numberOfPoints a b p 
      k <- randomRIO (1,n-1)
      return $ encryptStr (a,b,p) n k baseElement pk string                                                        