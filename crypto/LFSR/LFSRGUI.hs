import LFSRLogic
import Graphics.UI.Gtk.Glade
import Graphics.UI.Gtk
import Control.Monad

buttonClickHandler keyEntry srcEntry dstEntry =
    do key <- entryGetText keyEntry
       inputFileName <- entryGetText srcEntry
       outputFileName <- entryGetText dstEntry
       putStrLn $ "output" ++ outputFileName
       putStrLn $ "input" ++ inputFileName
       catch (encode key inputFileName outputFileName)
             (\e -> return ())

main = do
  initGUI
  lfsrXmlM <- xmlNew "lfsrWindow.glade"
  let lfsrXml = case lfsrXmlM of
                    (Just lfsrXml) -> lfsrXml
                    Nothing -> error "can't find the glade file \"lfsrWindow.glade\" \
                                       \in the current directory"
  window <- xmlGetWidget lfsrXml castToWindow "window1"
  [buttonEncrypt, buttonDecrypt] <- mapM (xmlGetWidget lfsrXml castToButton) ["buttonEncrypt","buttonDecrypt"]
  [entryPlaintext, entryCiphertext, entryKey] <- mapM (xmlGetWidget lfsrXml castToEntry)  ["entryPlaintext", "entryCiphertext", "entryKey"] 
  buttonEncrypt `onClicked` buttonClickHandler entryKey entryPlaintext entryCiphertext
  buttonDecrypt `onClicked` buttonClickHandler entryKey entryCiphertext entryPlaintext 
  window `onDestroy` mainQuit
  widgetShowAll window
  mainGUI