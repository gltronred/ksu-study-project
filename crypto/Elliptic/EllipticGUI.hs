import EllipticLogic
import Graphics.UI.Gtk.Glade
import Graphics.UI.Gtk
import Control.Monad
import Data.IORef

data EncryptionOptions = EncryptionOptions (Integer,Integer,Integer) (ModNum,ModNum) (Integer, (ModNum,ModNum)) 

encryptClickHandler options srcEntry dstEntry message =
    do srcText <- entryGetText srcEntry
       writeIORef message srcText
       msg <- readIORef message
       EncryptionOptions (a,b,p) baseElement (sk,pk) <- readIORef options
       dstText <- (encryptDriver (a,b,p) baseElement pk msg)
       entrySetText dstEntry dstText


decryptClickHandler options srcEntry dstEntry message =
    do srcText <- entryGetText srcEntry
       EncryptionOptions (a,b,p) baseElement (sk,pk) <- readIORef options
       dstText <- return $ (decryptStr (a,b,p) (numberOfPoints a b p) baseElement (fromIntegral sk) srcText)
       entrySetText dstEntry dstText
       --msg <- readIORef message
       --entrySetText dstEntry msg
       
       
generateClickHandler options =
 do  (sk, pk) <- generateKeys (1000,1,251) (GF 251 250, GF 251 249) (numberOfPoints 1000 1 251)
     opts <- return $ EncryptionOptions (1000,1,251) (GF 251 250, GF 251 249) (fromIntegral sk, pk)
     writeIORef options opts

main = do
  initGUI
  lfsrXmlM <- xmlNew "ellipticWindow.glade"
  let lfsrXml = case lfsrXmlM of
                    (Just lfsrXml) -> lfsrXml
                    Nothing -> error "can't find the glade file \"ellipticWindow.glade\" \
                                       \in the current directory"
  window <- xmlGetWidget lfsrXml castToWindow "window1"
  (sk, pk) <- generateKeys (1000,1,251) (GF 251 250, GF 251 249) (numberOfPoints 1000 1 251)   
  options <- newIORef (EncryptionOptions (1000,1,251) (GF 251 250, GF 251 249) (fromIntegral sk,pk))  
  message <- newIORef ""
  [buttonEncrypt, buttonDecrypt, buttonGenerate] <- mapM (xmlGetWidget lfsrXml castToButton) ["buttonEncrypt","buttonDecrypt","buttonGenerate"]
  [entryPlaintext, entryCiphertext] <- mapM (xmlGetWidget lfsrXml castToEntry)  ["entryPlaintext", "entryCiphertext"] 
  buttonEncrypt  `onClicked` encryptClickHandler options entryPlaintext entryCiphertext message
  buttonDecrypt  `onClicked` decryptClickHandler options entryCiphertext entryPlaintext message
  buttonGenerate `onClicked` generateClickHandler options
  window `onDestroy` mainQuit
  widgetShowAll window
  mainGUI