module RSALogic
   where

import Data.Encoding
import Data.Encoding.CP1251
import System.Random
import Control.Monad
import Data.List
data ModNum = GF Integer Integer deriving Eq
data RSAKeys = RSAKeys (Integer, Integer) (Integer, Integer) 
instance Show ModNum
   where
   show (GF _ num) = show num
instance Num ModNum
         where
         
         (GF p a) + (GF q b)  = if (p==q) then GF p ((a+b) `mod` p)
                                          else error "Incompatible modulos in addition!"         
         (GF p a) * (GF q b)  = if (p==q) then GF p ((a*b) `mod` p)
                                          else error "Incompatible modulos in multiplication!"
         fromInteger x = error "RSALogic.ModNum -- no fromInteger."
         signum x = error "RSALogic.ModNum -- no signum."
         abs x = error "RSALogic.ModNum -- no abs."
toNumber (GF p n) = n
extendedGCD a b  = if (a `mod` b == 0) then (b,0,1)
                                       else (d, y, x - y*(a `div` b))
                                             where (d, x, y) = extendedGCD b (a `mod` b)

randomNumbers k (a,b) = replicateM k $ randomRIO (a, b)
probeTest 1 = False
probeTest primeCandidate = and [primeCandidate `mod` d /= 0 | d <- [2..(truncate . sqrt . fromIntegral) primeCandidate]]
ioProbeTest = (return::a -> IO a) . probeTest
fermatTest k primeCandidate  = liftM (\l -> and [(GF primeCandidate a)^(primeCandidate-1) == (GF primeCandidate 1)|a <- l]) 
                                                      $ randomNumbers k (1, primeCandidate-1)
rmStep p a (s,d) =  let num = GF p a
                        sq  = num^2
                        numd = num^d
                        one = GF p 1
                        minusOne = GF p (p-1)
                     in (p `mod` a == 0) || (numd /= one)  && (all (/= minusOne) . take s . iterate (^2) $ numd)

factorOutTwo number = until (odd . snd) (\(a,b)-> (a+1, b `div` 2)) $ (0,number)

rmTest _ 1 = return False
rmTest _ 2 = return True
rmTest _ 3 = return True
rmTest k primeCandidate = liftM (\l -> let (s,d) = factorOutTwo (primeCandidate - 1)
                                                    in not $ or [rmStep primeCandidate a (s,d)|a <- l]) 
                                                       $ randomNumbers k (2, primeCandidate-2)

pollardRhoStep n f (x,y,d) = let x' = f x
                                 y' = f (f y)
                                 d' = gcd (abs  (x'-y')) n
                                  in (x', y', d')

pollardRho n = d where (x,y,d) = (until (\(x,y,d) -> d /= 1) $ 
                                  pollardRhoStep n ((`mod` n) . (+ (n-1)) . (^2))) (2,2,1)

factorRSAKey key = let factor = pollardRho key in (key `div` factor, factor)
rsaStep (p,q) e = let n = p*q
                      phi = (p-1)*(q-1)
                      d = ((y + phi) `mod` phi) where (d,x,y) = extendedGCD phi e
                  in (n, d)

rsaEncrypt (n,e) symbol = toNumber $ (GF n (symbol `mod` n))^e
rsaDecrypt (n,d) message = toNumber $ (GF n (message `mod` n)^d)
rsaListEncrypt (n,e) = map $ rsaEncrypt (n,e)
rsaListDecrypt (n,d) = map $ rsaDecrypt (n,d)

rsaAttack (n,e) = let (p,q) = factorRSAKey n
                      (d, phi) = rsaStep (p,q) e
                  in rsaDecrypt (d,n)

rsaListAttack (n,e) = let (p,q) = factorRSAKey n
                          (_, d) = rsaStep (p,q) e
                      in  rsaListDecrypt (n,d)
cyrString = "аудио"
generatePrime primeTest (a,b) = do candidate <- randomRIO (a,b)
                                   isPrime   <- primeTest candidate                                   
                                   if isPrime then return $ candidate
                                              else generatePrime primeTest (a,b)

generatePublicKey primeTest p q =       do phi        <- return $ (p-1)*(q-1)
                                           candidate  <- randomRIO (1,phi-1)
                                           isPrime    <- primeTest candidate
                                           isFeasible <- return $ isPrime && (gcd phi candidate == 1) && (candidate /= p) && (candidate /= q)
                                           if isFeasible then return $ candidate
                                                         else generatePublicKey primeTest p q 


facadeCP1251IntArraytoUTF8 = decodeString CP1251 . map (toEnum . fromIntegral) 
facadeHackRSA (n,e) numbers    = facadeCP1251IntArraytoUTF8 $ rsaListAttack (n,e) numbers
facadeDecryptRSA (n,d) numbers = facadeCP1251IntArraytoUTF8 $ rsaListDecrypt (n,d) numbers 
facadeEncryptRSA (n,e) string =  rsaListEncrypt (n,e) $ map (fromIntegral . fromEnum) $ encodeString CP1251 string

facadeGenerateRSAKeys (r1s, r1e) (r2s, r2e) primeTest = do p <- generatePrime primeTest (r1s, r1e)
                                                           q <- generatePrime primeTest (r2s, r2e)
                                                           n <- return $ p*q
                                                           e <- generatePublicKey primeTest p q
                                                           (n, d) <- return $ rsaStep (p,q) e
                                                           return $ RSAKeys (n,e) (n,d)
  