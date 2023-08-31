#|-logLib.tcl :|
#|  -tcl library for vmd declaring the logLib namespace, used by other
#|   _ libraries to manage generic log files .
#|  -dates :
#|    -created :-2023-04-28.Fri ;
#|    -modified :-2023-08-31.Thu ;;
#|  -authors and contributors :
#|    -Carlos Z. Gómez Castro ;
#|  -public software repositories :
#|    -https://github.com/carloszep/anMD-vmd.tcl ;
#|  -version information :
#|    -version :-0.0.4 ;
#|    -changes in progress :
#|      -definition of the logLib namespace .
#|      -some procs tested on 3ago23 .
#|      -implemented the nested state namespace and the state_save and
#|       _ state_restore commands (not tested yet) .
#|      -added l_variables variable and add_variables and list_variables
#|       commands (not tested yet) .
#|      -state_show command added .
#|      -added set_logName and set_version commands .
#|      -command version renamed to get_logVersion .
#|      -command set_version renamed to set_logVersion .
#|      -command set_logName_version deleted ;
#|    -to do list :
#|      -to implement a command to interpretate variable arguments .
#|      -to implement a graphical interface .
#|      -to test saving the state of the namespace .
#|      -to implement an internal namespace test command ;;
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
#|      -get_logName .
#|      -set_logName .
#|      -get_logVersion .
#|      -set_logVersion .
#|      -get_logName_version .
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
#|      -add_variables .
#|      -list_variables .
#|      -add_commands .
#|      -list_commands .
#|      -state_save .
#|      -state_restore .
#|      -state_show .
#|      -arg_interpreter ;
  namespace export get_logName set_logName get_logVersion set_logVersion
  namespace export get_logName_version
  namespace export get_logPath set_logPath get_logFileName set_logFileName
  namespace export get_logPrefixStr set_logPrefixStr
  namespace export get_logSufixStr set_logSufixStr
  namespace export get_logOutputStream set_logOutputStream
  namespace export get_logLevel set_logLevel logMsg logToken logFlush
  namespace export get_logScreen logScreenOn logScreenOff
  namespace export get_logAppend logAppendOn logAppendOff
  namespace export add_variables list_variables
  namespace export add_commands list_commands
  namespace export state_save state_restore state_show
  namespace export arg_interpreter

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
#|          -"0.0.4" ;;
  variable logVersionTxt "0.0.4"
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
#|      -l_variables :
#|        -contains the names of all namespace variables in a list .
#|        -are used as "state" variables to be used in
#|         _ ::logLib::state_save and ::logLib::state_restore commands ;
  variable l_variables [list logNameTxt logVersionTxt logPath logFileName \
                             logPrefixStr logSufixStr loSt logLvl logScreen \
                             logAppend l_variables l_commands]
#|      -l_commands :
#|        -list of the proc names to be exported by the namespace ;;
  variable l_commands [list get_logName         set_logName \
                            get_logVersion      set_logVersion \
                            get_logName_version \
                            get_logFileName     set_logFileName \
                            get_logPrefixStr    set_logPrefixStr \
                            get_logSufixStr     set_logSufixStr \
                            get_logOutputStream set_logOutputStream \
                            get_logLevel        set_logLevel \
                            get_logScreen logScreenOn   logScreenOff \
                            get_logAppend logAppendOn   logAppendOff \
                            logMsg        logToken      logFlush \
                            add_variables       list_variables \
                            add_commands        list_commands \
                            state_save    state_restore state_show \
                            arg_interpreter]

#|    -nested namespaces :
#|      -state :
#|        -contains a copy of all (::logLib::) namespace variables .
#|        -intended to save the state of the namespace .
#|        -uses the state_save and state_restore commands .
#|        -saved variable :
#|          -it is initialized with the value of 0 .
#|          -its value changes to 1 after running ::logLib::state_save ;;;
  namespace eval state {
    variable saved 0
    variable logNameTxt ""
    variable logVersionTxt ""
    variable logPath ""
    variable logFileName ""
    variable logPrefixStr ""
    variable logSufixStr ""
    variable loSt stdout ""
    variable logLvl ""
    variable logScreen ""
    variable logAppend ""
    variable l_commands ""
    }

#|    -commands :
#|      -proc get_logName {} :
#|        -returns the strings registered as logNameTxt ;
  proc get_logName {} {
    variable logNameTxt
    return $logNameTxt
    }

#|      -proc set_logName {name} :
#|        -sets the logName ;
  proc set_logName {name} {
    variable logNameTxt
    set logNameTxt $name
    }

#|      -proc get_logVersion {} :
#|        -returns the version number registered ;
  proc get_logVersion {} {
    variable logVersionTxt
    return $logVersionTxt
    }

#|      -proc set_logVersion {ver} :
#|        -sets the logVersion ;
  proc set_logVersion {ver} {
    variable logVersionTxt
    set logVersionTxt $ver
    }

#|      -proc get_logName_version {} :
#|        -returs a string formated as <logName>_v.<version> ;
  proc get_logName_version {} {
    variable logNameTxt
    variable logVersionTxt
# returns string with library name and version
    return "${logNameTxt}_v.$logVersionTxt"
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

#|      -proc add_variables {new variables} :
#|        -adds variable names to the l_variables list ;
  proc add_variables {new variables} {
    variable l_variables
    set l_variables [list {*}$l_variables {*}$new_variables]
    }

#|      -proc list_variables {} :
#|        -returns a list of variable names stored in l_variables ;
  proc list_variables {} {
    variable l_variables
    return $l_variables
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

#|      -proc state_save {} :
#|        -copy the values of all (::logLig::) namespace variables
#|         _ to the nested namespace 'state' .
#|        -sets the state::saved variable to 1 ;
  proc state_save {} {
    variable l_variables
    foreach var ${l_variables} {
      variable $var
      set state::$var [set var]
      }
    set state::saved 1
    }

#|      -proc state_restore {} :
#|        -copy the values of all the variables within the '::logLib::state::'
#|         _ nested namespace to the ::logLib:: namespace variables .
#|        -if the value of ::logLib::state::saved is 0 does nothing ;
  proc state_restore {} {
    variable l_variables
    if {$state::saved} {
      foreach var ${l_variables} {
        variable $var
        set $var $state::[set var]
        }
      }
    }

#|      -proc state_show {{lvl 1}} :
#|        -prints to log variable names and values specified in l_variables .
#|        -if state::saved is 0 does nothing .
#|        -arguments :
#|          -lvl :-output log level for logMsg output ;;;
  proc state_show {{lvl 1}} {
    variable l_variables
    if {$state::saved} {
      foreach var ${l_variables} {
        variable $var
        logMsg "$var [set $var]" $lvl
        }
    } else {
      logMsg "state::saved 0" $lvl
      }
    }

#|      -proc logLib::arg_interpreter {args} :
#|        -interpretates a list of pairs of argument-vaule keywords refering to
#|         _ namespace commands and executes them .
#|        -returns the list of arg-val pairs of kewords not interpreted .
#|        -arguments :
#|          -args :
#|            -list of keywords (tokens) with pairs of argument-value .
#|            -if args is "" returns ""
#|            -format :
#|              -{arg1 val1 ...} ;
#|            -acceptable arg values :
#|              -'set_logName', 'setLogName', 'logName' :
#|                -calls the set_logName command .
#|                -requires 1 argument as value ;
#|              -'set_logVersion', 'setLogVersion', 'logVersion' :
#|                -calls the set_logVersion commands .
#|                -requires 1 argument as value ;
#|              -'set_logFileName', 'set_logFile', 'setLogFile',
#|               _ 'setLogFileName', 'logFile', 'logFileName' :
#|                -calls the set_logFileName command .
#|                -requires 1 argument as value ;
#|              -'set_logPrefixStr', 'set_logPrefix', 'setLogPrefix',
#|               _ 'logPrefix', 'logPrefixStr' ;;;;
  proc arg_interpreter {args} {
    
    }
#|      - ;;

  }   ;# namespace eval logLib

#|  - ;

