import Data.Binary
import Data.Binary.Get
import Data.Binary.Put
import Data.Word
import Control.Monad
import Data.Binary.IEEE754

data Header = Header Word32 Word32 deriving Show
data PVMapping = PVMapping Word32 Double deriving Show
data Frame = Frame Word32 Word32 [PVMapping] deriving Show
data Solution = Solution Header [Frame] deriving Show

instance Binary PVMapping
 where 
      put (PVMapping addr value) = 
             do 
                putWord32le addr
                putFloat64le value
      
      get = do addr <- getWord32le
               value <- getFloat64le
               return $ PVMapping addr value

instance Binary Frame
  where 
  put (Frame a b l) =   do putWord32le a
                           putWord32le b
                           mapM_ put l
  get = do timeStamp <- getWord32le
           count <- getWord32le
           l <- replicateM (fromIntegral count) get
           return $ Frame timeStamp count l

instance Binary Solution
 where put (Solution (Header b c) list) = do
            putWord32le 0xcafebabe
            putWord32le b
            putWord32le c
            mapM_ put list
       get = do teamId <- getWord32le
                scenarioId <- getWord32le
                list <- replicateM 1 get
                return $ Solution (Header teamId scenarioId) list


solution = Solution (Header 42 1001) [
                                      Frame 0 3 [PVMapping 16000 1001.0, PVMapping 3 (-2466.4848), PVMapping 2 0.0], 
                                      Frame 1 1 [PVMapping 3 0.0],
                                      Frame 18875 1 [PVMapping 3 1482.9351],
                                      Frame 18876 1 [PVMapping 3 0.0],
                                      Frame 19877 0 []
                                     ]
solution2 = Solution (Header 42 1001) [Frame 0 3 [PVMapping 16000 1001.0, PVMapping 2 0.0, PVMapping 3 0.0], Frame 14000 0 []]