module Interactor
  where
import System.IO
import System.Process
import SatelliteGuidance
import Data.Word

data OutputPorts = OutputPorts [(Word32, Double)] deriving (Show, Read)
data InputPorts = InputPorts [(Word32, Double)] deriving Read

instance Show InputPorts
         where show (InputPorts list) = unwords . (map (show . snd)) $ list

readOutputPorts string = OutputPorts [(a `div` 2, read b) |(a,b) <- filter (even . fst) $ zip [0..] (tail $ tail $ words string)]

interactionStep outputPorts transition i o =
 do s <- return $ show $ transition outputPorts
    putStrLn s
    hPutStrLn i s
    op <- fmap (Just . readOutputPorts) $ hGetLine o
    isEOF <- hIsEOF o
    if (isEOF)  then return ()
                else interactionStep op transition i o   
    

interaction::FilePath->(Maybe OutputPorts -> InputPorts) -> IO ()
interaction filename transition = do (i,o,e,p) <- runInteractiveProcess "../vm/./vm" [filename] Nothing Nothing
                                     interactionStep Nothing transition i o
                                     hClose i
                                     hClose o