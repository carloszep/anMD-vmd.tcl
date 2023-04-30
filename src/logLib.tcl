#|-logLib.tcl :|
#|  -tcl library for vmd declaring a namespace used by other libraries
#|   _ to manage generic log files .
#|  -dates :
#|    -created :-2023-04-28.Fri ;
#|    -modified :-2023-04-29.Sat ;;
#|  -authors and contributors :
#|    -Carlos Z. Gómez Castro ;
#|  -public software repositories :
#|    -https://github.com/carloszep/anMD-vmd.tcl ;
#|  -version information :
#|    -current version :-0.0.1 ;
#|    -changes in progress :
#|      -definition of the logLib namespace ;;
#|  -notes :
#|    -originally started within the anMD lib ;
#|  -namespace logLib :
#|    -variable :
#|      -logNameTxt .
#|      -logVersionTxt .
#|      -loSt .
#|      -logLvl ;
#|    -commands :
#|      -version :-returns the version number registered ;
#|      -get_logName_version :
#|        -returs a string formated as <logName>_v.<version> ;
#|      -set_logName_version :
#|        - ;
#|      -get_logFileName .
#|      -set_logFileName .
#|      -get_logOutputStream .
#|      -set_logOutputStream .
#|      -get_logLevel .
#|      -set_logLevel .
#|      -logMsg .
#|      -logToken .
#|      -logFlush ;;
#|  - ;

namespace eval logLib {
  namespace export version get_logName_version set_logName_version
  namespace export get_logOutputStream set_logOutputStream
  namespace export get_logLevel set_logLevel logMsg logToken logFlush
  variable logNameTxt ""
  variable logVersionTxt ""
  variable logFileName ""
  variable loSt stdout
  variable logLvl 1

  proc version {} {
    variable logVersionTxt
    return $logVersionTxt
    }

  proc get_logName_version {} {
    variable logNameTxt
    variable logVersionTxt
# returns string with library name and version
    return "${logNameTxt}_v.$logVersionTxt"
    }

  proc set_logName_version {name ver {fileName ""}} {
    variable logNameTxt
    variable logVersionTxt
    variable logFileName
    set logNameTxt $name
    set logVersionTxt $ver
    set logFileName $fileName
    if {$logFileName == ""} {
# sets default logFileName if not specified yet
      set logFileName "log_[get_logName_version].txt"
      }
    }

  proc get_logFileName {} {
    variable logFileName
    return $logFileName
    }

  proc set_logFileName {fileName} {
    variable logFileName
    variable loSt
    if {($logFileName != "auto") && ($logFileName != "default")} {
      set logFileName $fileName
      }
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

  proc get_logLevel {} {
    variable logLvl
    return logLvl
    }

  proc set_logLevel {level} {
    variable logLvl
    set logLvl $level
    }

  proc logMsg {msg {lvl 1}} {
    variable loSt
    variable logLvl
    variable flushMsg
    if {($lvl > 0) && ($lvl <= $logLvl)} {puts $loSt $msg}
    }

   proc logToken {msg {level 1}} {
    variable loSt
    variable logLvl
    variable flushMsg
    if {($level > 0) && ($level <= $logLvl)} {puts -nonewline $loSt $msg}
    }

  proc logFlush {} {
    variable loSt
    if {$loSt != stdout} {flush $loSt}
    }

  }   ;# namespace eval logLib


