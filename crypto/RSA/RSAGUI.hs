import RSALogic
import Graphics.UI.Gtk.Glade
import Graphics.UI.Gtk
import Control.Monad
import Data.IORef
import qualified Control.Exception as C
import Prelude --hiding ( catch )

data PrimeTest = FermatTest | ProbeTest | RabinMillerTest
getPrimeTest x = case x of
                     FermatTest -> fermatTest 40
                     ProbeTest  -> ioProbeTest
                     RabinMillerTest -> rmTest 40

encryptWrapper (n, e) plainText = show $ facadeEncryptRSA (n,e) plainText
decryptWrapper (n, d) cipherText = facadeDecryptRSA (n, d) $ read cipherText 
hackWrapper (n,e) cipherText = facadeHackRSA (n,e) $ read cipherText
codeEventHandler srcEntry dstEntry keyEntry transformFunction =
       catch (do keyString <- entryGetText keyEntry
                 srcText   <- entryGetText srcEntry
                 key       <- readIO keyString :: IO (Integer, Integer)
                 let dstText = transformFunction key srcText
                          in entrySetText dstEntry dstText)
             (\e->putStrLn $ show e)

generateEventHandler r1Entry r2Entry publicEntry secretEntry primetest =
      catch (  do range1 <- liftM read $ entryGetText r1Entry :: IO (Integer, Integer)
                  range2 <- liftM read $ entryGetText r2Entry :: IO (Integer, Integer)
                  RSAKeys pub sec <- facadeGenerateRSAKeys range1 range2 (getPrimeTest primetest)
                  entrySetText publicEntry (show pub)
                  entrySetText secretEntry (show sec))
            (\e->putStrLn $ show e)        

main = do
  initGUI
  rsaXmlM <- xmlNew "rsaWindow.glade"
  let rsaXml = case rsaXmlM of
                    (Just rsaXml) -> rsaXml
                    Nothing -> error "can't find the glade file \"rsaWindow.glade\" \
                                       \in the current directory"
  window <- xmlGetWidget rsaXml castToWindow "window1"
  [buttonGenerate, buttonEncrypt, buttonDecrypt, buttonHack] <- mapM (xmlGetWidget rsaXml castToButton)
                                                                     ["buttonGenerate","buttonEncrypt","buttonDecrypt","buttonHack"]
  [entryPRange, entryQRange, entryPublicKey, 
   entrySecretKey, entryPlaintext,
   entryCiphertext, entryHackCiphertext, 
   entryHackPlaintext, entryHackPublicKey] <- mapM (xmlGetWidget rsaXml castToEntry)  ["entryPRange", "entryQRange", "entryPublicKey", 
                                                                                       "entrySecretKey", "entryPlaintext",
                                                                                       "entryCiphertext", "entryHackCiphertext",
                                                                                       "entryHackPlaintext", "entryHackPublicKey"] 
  [radioProbe, radioRabin, radioFermat] <- mapM (xmlGetWidget rsaXml castToRadioButton) ["radioProbe", "radioRabin", "radioFermat"]
  testRef <- newIORef ProbeTest               
  radioProbe  `onToggled` writeIORef testRef ProbeTest 
  radioRabin  `onToggled` writeIORef testRef RabinMillerTest
  radioFermat `onToggled` writeIORef testRef FermatTest
  buttonGenerate `onClicked` (do test <- readIORef testRef
                                 generateEventHandler entryPRange entryQRange entryPublicKey entrySecretKey test)
  buttonEncrypt `onClicked` codeEventHandler entryPlaintext entryCiphertext entryPublicKey encryptWrapper
  buttonDecrypt `onClicked` codeEventHandler entryCiphertext entryPlaintext entrySecretKey decryptWrapper
  buttonHack    `onClicked` codeEventHandler entryHackCiphertext entryHackPlaintext entryHackPublicKey hackWrapper                                  
  window `onDestroy` mainQuit
  widgetShowAll window
  mainGUI