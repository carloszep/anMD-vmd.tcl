#|-anMDlib.tcl :|
#|  -tcl library for VMD to perform analysis of molecular dynamics (MD) trajectories (traj) .
#|  -continues from the old library anMD_v.0.6.0 .
#|  -anMDlib.tcl is intended to drive and interface all the MD analysis procedures implemented .
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
#|    -the use of the userInfo library is assumed to be the same, eventhough userInfo lib
#|     _ will be updated in the future ;
#|  -namespace anMD :
#|    -variables :
#|      -versionTxt :- ;
#|      -logFileName :- ;
#|      -useGraphics :- ;
#|      -loSt :- ;
#|      -logLvl :- ;
#|      -l_commands ;
#|    -commands :- ;;;

namespace eval anMD {
  variable versionTxt "0.0.1"
  variable logFileName "log_anMD-v.${versionTxt}.txt"
  variable useGraphics 1
  variable loSt stdout
  variable logLvl 1
  variable l_commands [list version graphicsOn graphicsOff set_logOutputStream]

  proc version {} {
    variable versionTxt
    return ${versionTxt}
    }

  proc graphicsOn {} {
    variable useGraphics
    set useGraphics 1
    }

  proc graphicsOff {} {
    variable useGraphics
    set useGraphics 0
    }

  proc get_logFile {} {
    variable logFileName
    return $logFileName
    }

  proc set_logFile {fileName} {
    variable logFileName
    variable loSt
    set logFileName $fileName
    if {$loSt != stdout} {
      close $loSt
      set loSt stdout
      }
    if {($logFileName != "") && ($logFileName != stdout)} {}
    set loSt [open $logFileName w]
    }

  proc get_logOutputStream {} {
    variable loSt
    return $loSt
    }

  proc set_logOutputStream {stream fileName} {
    variable loSt
    variable logFileName
    set loSt $stream
    set logFileName $fileName
    }

  proc set_outputStream {stream fileName} {
    variable loSt
    variable logFileName
    set loSt $stream
    }

  proc set_logLevel {lvl} {
    variable logLvl
    set logLvl $lvl
    }

  proc logMsg {msg {lvl 1}} {
    variable loSt
    variable logLvl
    if {$lvl > 0} {
      if {$lvl <= $logLvl} {puts $loSt $msg; flush $loSt}
      }
    }

  }   ;#  namespace eval anMD

