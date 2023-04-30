#|-anMDlib.tcl :|
#|  -tcl library for VMD to perform analysis of molecular dynamics (MD)
#|   _ trajectories (traj) .
#|  -continues from the old library anMD_v.0.6.0 .
#|  -anMDlib.tcl is intended to drive and interface all the MD analysis
#|   _ procedures implemented .
#|  -the main objective is to modernize this library using namespaces and to put
#|   _ different analysis in separated independent files ;
#|  -dates :
#|    -created :-2023-04-27.Thu ;
#|    -updated :-2023-04-27.Thu ;
#|  -authors and contributors :
#|    -Carlos Z. Gómez Castro ;
#|  -public software repositories :
#|    -https://github.com/carloszep/anMD-vmd.tcl ;
#|  -version information :
#|    -current version :-0.0.1 ;
#|    -changes in progress :
#|      -definition of the anMD namespace ;;
#|  -notes :
#|    -the use of the userInfo library is assumed to be the same, eventhough 
#|     _ userInfo lib will be updated in the future ;
#|  -namespace anMD :
#|    -variables :
#|      -versionTxt :- ;
#|      -logFileName :- ;
#|      -useGraphics :- ;
#|      -loSt :- ;
#|      -logLvl :- ;
#|      -l_commands ;
#|    -commands :- ;;;

source logLib.tcl

namespace eval anMD {
  namespace import ::logLib::*
  variable useGraphics 1
  variable l_commands [list version graphicsOn graphicsOff set_logOutputStream]

  proc graphicsOn {} {
    variable useGraphics
    set useGraphics 1
    }

  proc graphicsOff {} {
    variable useGraphics
    set useGraphics 0
    }

  }   ;#  namespace eval anMD

