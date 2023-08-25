#|-logLib.tcl :|
#|  -tcl library for vmd declaring the logLib namespace, used by other
#|   _ libraries to manage generic log files .
#|  -dates :
#|    -created :-2023-04-28.Fri ;
#|    -modified :-2023-08-03.Thu ;;
#|  -authors and contributors :
#|    -Carlos Z. Gómez Castro ;
#|  -public software repositories :
#|    -https://github.com/carloszep/anMD-vmd.tcl ;
#|  -version information :
#|    -current version :-0.0.2 ;
#|    -changes in progress :
#|      -definition of the logLib namespace .
#|      -some procs tested on 3ago23 .
#|      -version changed to 0.0.2 after adding logAppend procs ;;
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
#|      -version .
#|      -get_logName .
#|      -get_logName_version .
#|      -set_logName_version .
#|      -get_logPath .
#|      -set_logPath .
#|      -get_logFileName .
#|      -set_logFileName .
#|      -get_logPrefixStr .
#|      -set_logPrefixStr .
#|      -get_logSufixStr .
#|      -set_logSufixStr .
#|      -get_logOutputStream .
#|      -set_logOutputStream .
#|      -get_logLevel .
#|      -set_logLevel .
#|      -logMsg .
#|      -logToken .
#|      -logFlush .
#|      -get_logScreen .
#|      -logScreenOn .
#|      -logScreenOff .
#|      -get_logAppend .
#|      -logAppendOn .
#|      -logAppendOff .
#|      -add_commands .
#|      -list_commands ;
  namespace export version get_logName get_logName_version set_logName_version
  namespace export get_logPath set_logPath get_logFileName set_logFileName
  namespace export get_logPrefixStr set_logPrefixStr
  namespace export get_logSufixStr set_logSufixStr
  namespace export get_logOutputStream set_logOutputStream
  namespace export get_logLevel set_logLevel logMsg logToken logFlush
  namespace export get_logScreen logScreenOn logScreenOff
  namespace export get_logAppend logAppendOn logAppendOff
  namespace export add_commands list_commands
#|    -variables :
#|      -logNameTxt :
#|        -name of the proc, library, namespace, etc., using the logLib .
#|        -to be included in the default logFileName and in log msgs .
#|        -default value :
#|          -"logLib" ;;
  variable logNameTxt "logLib"
#|      -logVersionTxt :
#|        -version string of the proc, library, namespace, etc., using the logLib .
#|        -to be included in the default logFileName and in log msgs .
#|        -default value :
#|          -"0.0.2" ;;
  variable logVersionTxt "0.0.2"
#|      -logPath :
#|        -default value :-"" ;;
  variable logPath ""
#|      -logFileName :
#|        -default value :-"" ;;
  variable logFileName ""
#|      -logPrefixStr :
#|        -text to be preppended to log messages .
#|        -default value :-"" ;;
  variable logPrefixStr ""
#|      -logSufixStr :
#|        -text to be appended at the en of each log message .
#|        -default value :-"" ;;
  variable logSufixStr ""
#|      -loSt :
#|        -stream for log output messages .
#|        -default value :-stdout ;;
  variable loSt stdout
#|      -logLvl :
#|        -default :-1 ;;
  variable logLvl 1
#|      -logScreen :
#|        -default value :-1 ;;
  variable logScreen 1
#|      -logAppend :
#|        -default value :-1 ;;
  variable logAppend 1
#|      -l_commands :
#|        -list of the proc names to be exported by the namespace ;;
  variable l_commands [list version get_logName \
                            get_logName_version set_logName_version \
                            get_logFileName     set_logFileName \
                            get_logPrefixStr    set_logPrefixStr \
                            get_logSufixStr     set_logSufixStr \
                            get_logOutputStream set_logOutputStream \
                            get_logLevel        set_logLevel \
                            get_logScreen logScreenOn logScreenOff \
                            get_logAppend logAppendOn logAppendOff \
                            logMsg logToken logFlush \
                            add_commands list_commands]

#|    -commands :
#|      -proc version {} :
#|        -returns the version number registered ;
  proc version {} {
    variable logVersionTxt
    return $logVersionTxt
    }

#|      -proc get_logName {} :
#|        -returns the strings registered as logNameTxt ;
  proc get_logName {} {
    variable logNameTxt
    return $logNameTxt
    }

#|      -proc get_logName_version {} :
#|        -returs a string formated as <logName>_v.<version> ;
  proc get_logName_version {} {
    variable logNameTxt
    variable logVersionTxt
# returns string with library name and version
    return "${logNameTxt}_v.$logVersionTxt"
    }

#|      -proc set_logName_version {name ver} :
#|        -sets the logName and the logVersion .
  proc set_logName_version {name ver} {
    variable logNameTxt
    variable logVersionTxt
    set logNameTxt $name
    set logVersionTxt $ver
    }

#|      -proc get_logPath {} :
#|        -returns the path registered for the log ;
  proc get_logPath {} {
    variable logPath
    return $logPath
    }

#|      -proc set_logPath {path} :
#|        -sets the path prepended to the log file ;
  proc set_logPath {path} {
    variable logPath
    set logPath $path
    }

#|      -proc get_logFileName {} :
#|        -returns the name of the file to be used as output stream ;
  proc get_logFileName {} {
    variable logFileName
    return $logFileName
    }

#|      -proc set_logFileName {fileName} :
#|        -sets the name of the file to be used as output stream .
#|        -can be used to deactivate log output to files .
#|        -arguments :
#|          -fileName :
#|            -acceptable values :
#|              -a string usable as a file name .
#|              -'none', '""', 'stdout' :
#|                -deactivate the output to a log file .
#|                -the output stream (loSt) is set to stdout ;
#|              -'auto', 'default' :
#|                -a default file name is used with format
#|                 _ 'log_<logName>_v.<version>.txt' ;;;;
#|        - ;
  proc set_logFileName {fileName} {
    variable logPath
    variable logFileName
    variable logAppend
    variable loSt
    if {$loSt != "stdout"} {close $loSt}
    switch [string tolower $fileName] {
      "none" - "" - "stdout" {
        set loSt stdout
        set logFileName ""
        }
      "auto" - "default" {
        set logFileName "log_[get_logName_version].txt"
        if {([file exists ${logPath}${logFileName}]) && ($logAppend)} {
          set loSt [open ${logPath}${logFileName} a]
        } else {
          set loSt [open ${logPath}${logFileName} w]
          }
        }
      default {
        set logFileName $fileName
        if {([file exists ${logPath}${logFileName}]) && ($logAppend)} {
          set loSt [open ${logPath}${logFileName} a]
        } else {
          set loSt [open ${logPath}${logFileName} w]
          }
        }
      }
    }

#|      -proc get_logPrefixStr {} :
#|        -returns the log prefix string ;
  proc get_logPrefixStr {} {
    variable logPrefixStr
    return $logPrefixStr
    }

#|      -proc set_logPrefixStr {} :
#|        -sets the log prefix string ;
  proc set_logPrefixStr {} {}

#|      -proc get_logSufixStr {} :
#|        -returns the log sufix string ;
  proc get_logSufixStr {} {
    variable logSufixStr
    return $logSufixStr
    }

#|      -proc set_logSufixStr {} :
#|        -sets the log sufix string ;
  proc set_logSufixStr {} {}


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
    if {$loSt != "stdout"} {close $loSt}
    set loSt $stream
    set logFileName $fileName
    }

#|      -proc get_logLevel {} :     
#|        -returns the minimum output level to print log msgs ;
  proc get_logLevel {} {
    variable logLvl
    return $logLvl
    }

#|      -proc set_logLevel {level} :     
#|        -sets the minimum output level to print log msgs ;
  proc set_logLevel {level} {
    variable logLvl
    set logLvl $level
    }

#|      -proc logMsg {msg {level 1}} :           
#|        -prints a message string line to the corrent output stream .
#|        -if the specified level is higher than the current log level,
#|         _ no message is output .
#|        -logPrefixStr and logSufixStr are preppended and appended, resp. ;
  proc logMsg {msg {level 1}} {
    variable logPrefixStr
    variable logSufixStr
    variable loSt
    variable logLvl
    variable logScreen
    if {($level > 0) && ($level <= $logLvl)} {
      puts $loSt "${logPrefixStr}${msg}${logSufixStr}"
      if {($loSt != "stdout") && $logScreen} {
        puts stdout "${logPrefixStr}${msg}${logSufixStr}"
        }
      }
    }

#|      -proc logToken {msg {level 1}} :
#|        -prints a string to the corrent out stream, with no new line, if the
#|         _ lvl of the msg is greater than or equal to the current log lvl ;
   proc logToken {msg {level 1}} {
    variable loSt
    variable logLvl
    variable logScreen
    if {($level > 0) && ($level <= $logLvl)} {
      puts -nonewline $loSt $msg
      if {($loSt != "stdout") && $logScreen} {
        puts -nonewline stdout $msg
        }
      }
    }

#|      -proc logFlush {} :
#|        -flush log messages printed into a file ;
  proc logFlush {} {
    variable loSt
    if {$loSt != "stdout"} {flush $loSt}
    }

#|      -proc get_logScreen {} :
#|        -returns the value of logScreen ;
  proc get_logScreen {} {
    variable logScreen
    return $logScreen
    }

#|      -proc logScreenOn {} :
#|        -activates an "allways print to screen" option regardless of the
#|         _ output sent to log files .
#|        -allows sending log messages to both the screen and a file ;
  proc logScreenOn {} {
    variable logScreen
    set logScreen 1
    }

#|      -proc logScreenOff {} :
#|        -deactivates an "allways print to screen" option .
#|        -if no log file is specified the output will be sent to stdout anyway ;
  proc logScreenOff {} {
    variable logScreen
    set logScreen 0
    }

#|      -proc get_logAppend {} :
#|        -returns the value of logAppend ;
  proc get_logAppend {} {
    variable logAppend
    return $logAppend
    }

#|      -proc logAppendOn {} :
#|        -allows to append log messages to a reoppened file ;
  proc logAppendOn {} {
    variable logAppend
    set logAppend 1
    }

#|      -proc logAppendOff {} :
#|        -allways rewrites (overwrites) a file that is reoppened ;
  proc logAppendOff {} {
    variable logAppend
    set logAppend 0
    }

#|      -proc add_commands {new_commands} :
#|        -adds command names to the l_commands list ;
  proc add_commands {new_commands} {
    variable l_commands
    set l_commands [list {*}$l_commands {*}$new_commands]
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
