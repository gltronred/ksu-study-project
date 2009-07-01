module LFSRLogic 
   where
import Data.Bits

import Data.List
import Data.Char
import System.IO
import Control.Monad
data LFSR = LFSR Int Integer (Integer -> Integer)
step (LFSR size state function) =  (function state) `shiftL` (size-1) 
                                    .|. (state `shiftR` 1) 
                                    .&.  ((1 `shiftL` size) - 1)
iteration (LFSR size state function) = let step'  = step (LFSR size state function) 
                                        in (function state, LFSR size step' function)
bitStreamLfsr = unfoldr (Just . iteration)
byteStreamLfsr' list = (foldl1 ((+).(*2)) $ take 8 list) : byteStreamLfsr' (drop 8 list)
byteStreamLfsr = map fromIntegral . byteStreamLfsr' . bitStreamLfsr

readBin = fromIntegral . foldl (\a b -> 2*a + digitToInt b) 0::[Char]->Integer
countBits n = fst $ until ((== 0) . snd) 
                          (\(c,n)-> (c + n .&. 1, n `shiftR` 1)) 
                           (0, n)

lfsrConvolve coeff state = (`mod` 2) $ countBits (state .&. coeff) 
lfsrEncode inputStream gamma = zipWith xor inputStream gamma

sampleLFSR key = LFSR 16 key (lfsrConvolve (readBin "1000000000010110"))
hashKey = fromIntegral . (`mod` 16381) . foldl1  ((+) . (* 256)) . map fromEnum :: String -> Integer

encode key srcFileName dstFileName = do srcHandle <- openFile srcFileName ReadMode
                                        dstHandle <- openFile dstFileName WriteMode 
                                        istream   <- liftM (map fromEnum) . hGetContents $ srcHandle
                                        mapM_ (hPutChar dstHandle . toEnum) $ lfsrEncode istream (byteStreamLfsr $ sampleLFSR (hashKey key)) 
                                        hClose srcHandle
                                        hClose dstHandle                                     