import Burst
import Hohmann
import SatelliteGuidance

theProgram = getProgram 1002 $ moveHohmann (3*1057) (1.0) (-6352278.93) 6361717.57 21082000.0

main = do
  -- runIOProgram $ getProgram 1001 $ moveHohmann 0 (-6556995.34) 7814.93 42164000.0
  runIOProgram theProgram