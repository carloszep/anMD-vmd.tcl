#|-logLib.tcl :|
#|  -tcl library for vmd declaring the logLib namespace used by other
#|   _ libraries to manage generic log files .
#|  -dates :
#|    -created :-2023-04-28.Fri ;
#|    -modified :-2023-05-01.Mon ;;
#|  -authors and contributors :
#|    -Carlos Z. Gómez Castro ;
#|  -public software repositories :
#|    -https://github.com/carloszep/anMD-vmd.tcl ;
#|  -version information :
#|    -current version :-0.0.1 ;
#|    -changes in progress :
#|      -definition of the logLib namespace ;;
#|  -usage :
#|    -1. source within another script as :
#|      -source logLib.tcl ;
#|    -2. the namespace commands can be imported as :
#|      -namespace import ::logLib::* ;
#|    -3. the name and version of the invoking script may be specified :
#|      - ;;
#|  -notes :
#|    -originally started within the anMD lib ;

#|  -namespace logLib :
namespace eval logLib {
#|    -export :
#|      -version get_logName_version set_logName_version get_logFileName
#|       _ set_logFileName get_logOutputStream set_logOutputStream
#|       _ get_logLevel set_logLevel logMsg logToken logFlush
#|       _ list_commands ;
  namespace export version get_logName_version set_logName_version
  namespace export get_logOutputStream set_logOutputStream
  namespace export get_logLevel set_logLevel logMsg logToken logFlush
  namespace export list_commands
#|    -variable :
#|      -logNameTxt .
#|      -logVersionTxt .
#|      -logFileName .
#|      -loSt .
#|      -logLvl .
#|      -l_commands ;
  variable logNameTxt ""
  variable logVersionTxt ""
  variable logFileName ""
  variable loSt stdout
  variable logLvl 1
  variable l_commands [list version \
                            get_logName_version set_logName_version \
                            get_logFileName     set_logFileName \
                            get_logOutputStream set_logOutputStream \
                            get_logLevel        set_logLevel \
                            logMsg logToken logFlush list_commands]

#|    -commands :
#|      -proc version {} :
#|        -returns the version number registered ;
  proc version {} {
    variable logVersionTxt
    return $logVersionTxt
    }

#|      -proc get_logName_version {} :
#|        -returs a string formated as <logName>_v.<version> ;
  proc get_logName_version {} {
    variable logNameTxt
    variable logVersionTxt
# returns string with library name and version
    return "${logNameTxt}_v.$logVersionTxt"
    }

#|      -proc set_logName_version {name ver {fileName ""}} :
#|        -sets the ligName, the logVersion, and the logFileName ;
  proc set_logName_version {name ver {fileName ""}} {
    variable logNameTxt
    variable logVersionTxt
    variable logFileName
    set logNameTxt $name
    set logVersionTxt $ver
    set logFileName $fileName
    global ${logFileName}_version
    set ${logFileName}_version ${logVersionTxt} 
    if {$logFileName == ""} {
# sets default logFileName if not specified yet
      set logFileName "log_[get_logName_version].txt"
      }
    }

#|      -proc get_logFileName {} :
#|        -returns the name of the file to be used as output stream ;
  proc get_logFileName {} {
    variable logFileName
    return $logFileName
    }

#|      -proc set_logFileName {fileName} :
#|        -sets the name of the file to be used as output stream ;
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

#|      -proc get_logOutputStream {} :
#|        -returns the output stream currently used for log ;
  proc get_logOutputStream {} {
    variable loSt
    return $loSt
    }

#|      -proc set_logOutputStream {stream fileName} :
#|        -sets an already oppened output stream and their cooresponding
#|         _ fileName ;
  proc set_logOutputStream {stream fileName} {
    variable loSt
    variable logFileName
    set loSt $stream
    set logFileName $fileName
    }

#|      -proc get_logLevel {} :     
#|        -returns the minimum output level to print log msgs ;
  proc get_logLevel {} {
    variable logLvl
    return logLvl
    }

#|      -proc set_logLevel {level} :     
#|        -sets the minimum output level to print log msgs ;
  proc set_logLevel {level} {
    variable logLvl
    set logLvl $level
    }

#|      -proc logMsg {msg {lvl 1}} :           
#|        -prints a message string to the corrent output stream, if the level
#|         _ of the msg is greater than or equal to the current log level ;
  proc logMsg {msg {lvl 1}} {
    variable loSt
    variable logLvl
    variable flushMsg
    if {($lvl > 0) && ($lvl <= $logLvl)} {puts $loSt $msg}
    }

#|      -proc logToken {msg {level 1}} :
#|        -prints a string to the corrent out stream, with no new line, if the
#|         _ lvl of the msg is greater than or equal to the current log lvl ;
   proc logToken {msg {level 1}} {
    variable loSt
    variable logLvl
    variable flushMsg
    if {($level > 0) && ($level <= $logLvl)} {puts -nonewline $loSt $msg}
    }

#|      -proc logFlush {} :
#|        -flush log messages printed into a file ;
  proc logFlush {} {
    variable loSt
    if {$loSt != stdout} {flush $loSt}
    }

#|      -proc list_commands {} :
#|        -returns a list of the commands that can be exported ;
  proc list_commands {} {
    variable l_commands
    return $l_commands
    }

#|      - ;;

  }   ;# namespace eval logLib

#|  - ;

