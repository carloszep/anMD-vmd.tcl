#|-logLib.tcl :|
#|  -tcl library declaring the logLib namespace, used by other
#|   _ libraries to manage generic output log files .
#|  -dates :
#|    -created :
#|      -2023-04-28.Fri ;
#|    -modified :
#|      -2023-09-25.Mon ;;
#|  -authors and contributors :
#|    -Carlos Z. Gómez Castro ;
#|  -public software repositories :
#|    -https://github.com/carloszep/anMD-vmd.tcl ;
#|  -version information :
#|    -version :-0.0.7 ;
#|    -changes in progress :
#|      -regVar namespace incorporated ;
#|    -to do list :
#|      -to implement a graphical interface .
#|      -to implement an internal namespace test command .
#|      -to add add_state_variables command *? ;;
#|  -usage :
#|    -1. source within another script as :
#|      -source logLib.tcl ;
#|    -2. the namespace commands can be imported as :
#|      -namespace import ::logLib::* ;
#|    -3. the name and version of the invoking script may be specified :
#|      - ;;
#|  -notes :
#|    -originally started within the anMD lib ;
#|  -sourced files :
#|    -regVar.tcl ;
source regVar.tcl

#|  -namespace logLib :
namespace eval logLib {

#|    -import :
#|      -regVar::* ;
  namespace import ::regVar::*

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
#|      -get_logPrefix .
#|      -set_logPrefix .
#|      -get_logSufix .
#|      -set_logSufix .
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
  namespace export get_logPrefix set_logPrefix
  namespace export get_logSufix set_logSufix
  namespace export get_logOutputStream set_logOutputStream
  namespace export get_logLevel set_logLevel logMsg logToken logFlush
  namespace export get_logScreen logScreenOn logScreenOff
  namespace export get_logAppend logAppendOn logAppendOff
  namespace export list_variables add_commands list_commands
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
#|          -"0.0.7" ;;
  variable logVersionTxt "0.0.7"

#|      -logPath :
#|        -default value :-"" ;;
  variable logPath ""

#|      -logFileName :
#|        -default value :-"" ;;
  variable logFileName ""

#|      -logPrefix :
#|        -text to be preppended to log messages .
#|        -default value :-"" ;;
  variable logPrefix ""

#|      -logSufix :
#|        -text to be appended at the en of each log message .
#|        -default value :-"" ;;
  variable logSufix ""

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
                             logPrefix logSufix loSt logLvl logScreen \
                             logAppend l_commands]

#|      -l_commands :
#|        -list of the proc names to be exported by the namespace ;;
  variable l_commands [list get_logName         set_logName \
                            get_logVersion      set_logVersion \
                            get_logName_version \
                            get_logFileName     set_logFileName \
                            get_logPrefix       set_logPrefix \
                            get_logSufix        set_logSufix \
                            get_logOutputStream set_logOutputStream \
                            get_logLevel        set_logLevel \
                            get_logScreen logScreenOn   logScreenOff \
                            get_logAppend logAppendOn   logAppendOff \
                            logMsg        logToken      logFlush \
                            add_variables       list_variables \
                            add_commands        list_commands \
                            state_save    state_restore state_show \
                            arg_interpreter]

#|    -commands :
#|      -proc get_logName {} :
#|        -returns the strings registered as logNameTxt ;
  proc get_logName {} {
    variable logNameTxt
    logMsg "logLib::get_logName: returned logNameTxt: $logNameTxt" 4
    return $logNameTxt
    }

#|      -proc set_logName {name} :
#|        -sets the logName ;
  proc set_logName {name} {
    variable logNameTxt
    logMsg "logLib::set_logName: logNameTxt set to: $name" 3
    set logNameTxt $name
    }

#|      -proc get_logVersion {} :
#|        -returns the version number registered ;
  proc get_logVersion {} {
    variable logVersionTxt
    logMsg "logLib::get_logVersion: returned logVersionTxt: $logVersionTxt" 4
    return $logVersionTxt
    }

#|      -proc set_logVersion {ver} :
#|        -sets the logVersion ;
  proc set_logVersion {ver} {
    variable logVersionTxt
    logMsg "logLib::set_logVersion: logVersionTxt set to: $ver" 3
    set logVersionTxt $ver
    }

#|      -proc get_logName_version {} :
#|        -returs a string formated as <logName>_v.<version> ;
  proc get_logName_version {} {
    variable logNameTxt
    variable logVersionTxt
    logMsg "logLib::get_logName_version: returned: ${logNameTxt}_v.$logVersionTxt" 4
    return "${logNameTxt}_v.$logVersionTxt"
    }

#|      -proc get_logPath {} :
#|        -returns the path registered for the log ;
  proc get_logPath {} {
    variable logPath
    logMsg "logLib::get_logPath: returned logPath: $logPath" 4
    return $logPath
    }

#|      -proc set_logPath {path} :
#|        -sets the path prepended to the log file ;
  proc set_logPath {path} {
    variable logPath
    logMsg "logLib::set_logPath: logPath set to: $path" 3
    set logPath $path
    }

#|      -proc get_logFileName {} :
#|        -returns the name of the file to be used as output stream ;
  proc get_logFileName {} {
    variable logFileName
    logMsg "logLib::get_logFileName: returned logFileName: $logFileName" 4
    return $logFileName
    }

#|      -proc set_logFileName {fileName} :
#|        -sets the name of the file to be used as output stream .
#|        -can be used to deactivate log output to files .
#|        -arguments :
#|          -fileName :
#|            -acceptable values :
#|              -a string usable as a file name .
#|              -'none', '""', 'stdout', 'screen' :
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
    state_save   ;# saving namespace variables
    set_logPrefix "logLib::set_logFileName: "
    if {$loSt != "stdout"} {
      logMsg "closing current log output stream..." 2
      close $loSt
      }
    switch [string tolower $fileName] {
      "none" - "" - "stdout" - "screen" {
        logMsg "set logFileName to: ''" 3
        logMsg "sending log messages to 'stdout'" 2
        set loSt stdout
        set logFileName ""
        }
      "auto" - "default" {
        set logFileName "log_[get_logName_version].txt"
        logMsg "set logFileName to: $logFileName" 2
        if {([file exists ${logPath}${logFileName}]) && ($logAppend)} {
          logMsg "appending log messages to: ${logPath}${logFileName}" 3
          set loSt [open ${logPath}${logFileName} a]
        } else {
          logMsg "sending log messages to new file: ${logPath}${logFileName}" 3
          set loSt [open ${logPath}${logFileName} w]
          }
        }
      default {
        set logFileName $fileName
        logMsg "set logFileName to: $logFileName" 2
        if {([file exists ${logPath}${logFileName}]) && ($logAppend)} {
          logMsg "appending log messages to: ${logPath}${logFileName}" 3
          set loSt [open ${logPath}${logFileName} a]
        } else {
          logMsg "sending log messages to new file: ${logPath}${logFileName}" 3
          set loSt [open ${logPath}${logFileName} w]
          }
        }
      }
    state_restore    ;# restoring namespace variables
    }

#|      -proc get_logPrefix {} :
#|        -returns the log prefix string ;
  proc get_logPrefix {} {
    variable logPrefix
    logMsg "logLib::get_logPrefix: returned logPrefix: $logPrefix" 4
    return $logPrefix
    }

#|      -proc set_logPrefix {prefix} :
#|        -sets the log prefix string ;
  proc set_logPrefix {prefix} {
    variable logPrefix
    logMsg "logLib::set_logPrefix: logPrefix set to: $prefix" 3
    set logPrefix $prefix
    }

#|      -proc get_logSufix {} :
#|        -returns the log sufix string ;
  proc get_logSufix {} {
    variable logSufix
    logMsg "logLib::get_logSufix: returned logSufix: $logSufix" 4
    return $logSufix
    }

#|      -proc set_logSufix {sufix} :
#|        -sets the log sufix string ;
  proc set_logSufix {sufix} {
    variable logSufix
    logMsg "logLib::set_logSufix: logSufix set to: $sufix" 3
    set logSufix $sufix
    }


#|      -proc get_logOutputStream {} :
#|        -returns the output stream currently used for log ;
  proc get_logOutputStream {} {
    variable loSt
    logMsg "logLib::get_logOutputStream: returned loSt: $loSt:" 4
    return $loSt
    }

#|      -proc set_logOutputStream {stream fileName} :
#|        -sets an already oppened output stream and their cooresponding
#|         _ fileName ;
  proc set_logOutputStream {stream fileName} {
    variable loSt
    variable logFileName
    if {$loSt != "stdout"} {
      logMsg "logLib::set_logOutputStream: closing current log output stream..." 2
      close $loSt
      }
    logMsg "logLib::set_logOutputStream: loSt and logFileName set to: $stream $fileName" 2
    set loSt $stream
    set logFileName $fileName
    }

#|      -proc get_logLevel {} :
#|        -returns the minimum output level to print log msgs ;
  proc get_logLevel {} {
    variable logLvl
    logMsg "logLib::get_logLevel: returned logLvl: $logLvl" 4
    return $logLvl
    }

#|      -proc set_logLevel {level} :     
#|        -sets the minimum output level to print log msgs ;
  proc set_logLevel {level} {
    variable logLvl
    logMsg "logLib::get_logLevel: logLvl set to: $level" 3
    set logLvl $level
    }

#|      -proc logMsg {msg {level 1}} :
#|        -prints a message string line to the corrent output stream .
#|        -if the specified level is higher than the current log level,
#|         _ no message is output .
#|        -logPrefix and logSufix are preppended and appended, resp. ;
  proc logMsg {msg {level 1}} {
    variable logPrefix
    variable logSufix
    variable loSt
    variable logLvl
    variable logScreen
    if {($level > 0) && ($level <= $logLvl)} {
#      logMsg "logLib::logMsg: message sent to output stream: $loSt" 3
#      logMsg "logLib::logMsg:   at log Level: $level" 4
#      logMsg "logLib::logMsg:   message: $level" 4
      puts $loSt "${logPrefix}${msg}${logSufix}"
      if {($loSt != "stdout") && $logScreen} {
#        logMsg "logLib::logMsg:   message sent also to stdout" 3
        puts stdout "${logPrefix}${msg}${logSufix}"
        }
    } else {
#      logMsg "logLib::logMsg: log message not output due to log level" 3
      }
    }

#|      -proc logToken {msg {level 1}} :
#|        -prints a string to the corrent out stream, with no new line, if the
#|         _ lvl of the msg is greater than or equal to the current log lvl .
#|        -special scape characters such as '\t' or '\n' can be printed ;
   proc logToken {msg {level 1}} {
    variable loSt
    variable logLvl
    variable logScreen
    if {($level > 0) && ($level <= $logLvl)} {
      logMsg "logLib::logToken: token sent to output stream: $loSt" 3
      logMsg "logLib::logToken:   at log Level: $level toke: $level" 4
      puts -nonewline $loSt $msg
      if {($loSt != "stdout") && $logScreen} {
        logMsg "logLib::logToken:   token sent also to stdout" 3
        puts -nonewline stdout $msg
        }
    } else {
      logMsg "logLib::logToken: token not output due to log level" 3
      }
    }

#|      -proc logFlush {} :
#|        -flush log messages printed into a file ;
  proc logFlush {} {
    variable loSt
    logMsg "logLib::logFlush: Flushing output stream buffer." 4
    if {$loSt != "stdout"} {flush $loSt}
    }

#|      -proc get_logScreen {} :
#|        -returns the value of logScreen ;
  proc get_logScreen {} {
    variable logScreen
    logMsg "logLib::get_logScreen: returned logScreen: $logScreen" 4
    return $logScreen
    }

#|      -proc logScreenOn {} :
#|        -activates an "allways print to screen" option regardless of the
#|         _ output sent to log files .
#|        -allows sending log messages to both the screen and a file ;
  proc logScreenOn {} {
    variable logScreen
    logMsg "logLib::logScreenOn: logScreen set to: 1" 3
    set logScreen 1
    }

#|      -proc logScreenOff {} :
#|        -deactivates an "allways print to screen" option .
#|        -if no log file is specified the output will be sent to stdout anyway ;
  proc logScreenOff {} {
    variable logScreen
    logMsg "logLib::logScreenOff: logScreen set to: 0" 3
    set logScreen 0
    }

#|      -proc get_logAppend {} :
#|        -returns the value of logAppend ;
  proc get_logAppend {} {
    variable logAppend
    logMsg "logLib::get_logAppend: returned logAppend: $logAppend" 4
    return $logAppend
    }

#|      -proc logAppendOn {} :
#|        -allows to append log messages to a reoppened file ;
  proc logAppendOn {} {
    variable logAppend
    logMsg "logLib::logAppendOn: logAppend set to: 1" 3
    set logAppend 1
    }

#|      -proc logAppendOff {} :
#|        -allways rewrites (overwrites) a file that is reoppened ;
  proc logAppendOff {} {
    variable logAppend
    logMsg "logLib::logAppendOff: logAppend set to: 0" 3
    set logAppend 0
    }

#|      -proc add_variables {new_variables} :
#|        -adds variable names to the l_variables list ;
  proc add_variables {new_variables} {
    variable l_variables
    logMsg "logLib::add_variables: variables appended to l_variables: $new_variables" 3
    set l_variables [list {*}$l_variables {*}$new_variables]
    }

#|      -proc list_variables {} :
#|        -returns a list of variable names stored in l_variables ;
  proc list_variables {} {
    variable l_variables
    logMsg "logLib::list_variables: returned l_variables: $l_variables" 4
    return $l_variables
    }

#|      -proc add_commands {new_commands} :
#|        -adds command names to the l_commands list ;
  proc add_commands {new_commands} {
    variable l_commands
    logMsg "logLib::add_commands: commands appended to l_commands: $new_commands" 3
    set l_commands [list {*}$l_commands {*}$new_commands]
    }

#|      -proc list_commands {} :
#|        -returns a list of the commands that can be exported ;
  proc list_commands {} {
    variable l_commands
    logMsg "logLib::list_commands: returned l_commands: $l_commands" 4
    return $l_commands
    }

#|      -proc state_save {} :
#|        -registers (stores) the names and values of the namespace variables
#|         _ in l_variables in the regVar namespace ;
  proc state_save {} {
    variable l_variables
    logMsg "logLib::state_save: vars and values stored into regVar" 3
    foreach var ${l_variables} {
      variable $var
      logMsg "logLib::state_save:   variable: $var value: [set $var]" 4
      regVar::varSave $var
      }
    }

#|      -proc state_restore {} :
#|        -copy the values of all the variables within the '::logLib::state::'
#|         _ nested namespace to the ::logLib:: namespace variables .
#|        -if the value of ::logLib::state::saved is 0 does nothing ;
  proc state_restore {} {
    variable l_variables
    logMsg "logLib::state_restore: vars and values restored from regVar" 3
    foreach var $l_variables {
      variable $var
      if {[regVar::varRestore $var]} {
        logMsg "logLib::state_restore:   $var value restored: [set $var]" 4
      } else {
        logMsg "logLib::state_restore:   $var value not restored" 3
        }
      }
    }

#|      -proc state_show {{lvl 1}} :
#|        -prints to variable names and values specified in l_variables .
#|        -arguments :
#|          -lvl :-output log level for logMsg output ;;;
  proc state_show {{lvl 1}} {
    variable l_variables
    logMsg "logLib::state_show: printing the namespace variables's values" 3
    logMsg "logLib::state_show:   to output level: $lvl" 3
    foreach var ${l_variables} {
      variable $var
      logMsg "logLib::state_show:   sent to log: $var [set $var]" 5
      logMsg "  $var [set $var]" $lvl
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
#|              -'set_logName', 'setLogName', 'logName' .
#|              -'set_logVersion', 'setLogVersion', 'logVersion' .
#|              -'set_logFileName', 'set_logFile', 'setLogFile',
#|               _ 'setLogFileName', 'logFile', 'logFileName' .
#|              -'set_logPrefix', 'set_logPrefix', 'setLogPrefix',
#|               _ 'logPrefix', 'logPrefix' .
#|              -'set_logSufix', 'set_logSufix', 'setLogSufix',
#|               _ 'logSufix', 'logSufix' .
#|              -'set_logOutputStream', 'set_logOutput', 'setlogOutput',
#|               _ 'logOutput', 'logStream', 'setLogOutputStream' .
#|              -'set_logLevel', 'setLogLevel', 'logLevel', 'logLvl' ;;;
#|        -notes :
#|          -this command may provide a shell to implement prior processing
#|           _ for several commands .
#|          -provides overloading of commands .
#|          -most arg-invoked commands requires a single argument
#|           _ as value, except for set_logoutputstream .
#|          -the first acceptable arg value corresponds to the command
#|           _ to be called ;;
  proc arg_interpreter {args} {
    logMsg "logLib::arg_interpreter: interpreting list of arguments: $args" 3
    set remaining_arg_val {}
    if {[expr {[llength $args]%2}] == 0} {
      if {[llength $args] > 0} {
        foreach {arg val} $args {
          switch [string tolower $arg] {
            "set_logname" - "setlogname" - "logname" {
              set_logName $val}
            "set_logversion" - "setlogversion" - "logversion" {
              set_logVersion $val}
            "set_logfilename" - "set_logfile" - "setlogfile" \
              - "setlogfilename" - "logfile" - "logfilename" {
              set_logFileName $val}
            "set_logprefixstr" - "set_logprefix" - "setlogprefix" \
              - "logprefix" - "logPrefix" {
              set_logPrefix $val}
            "set_logsufixstr" - "set_logsufix" - "setlogsufix" \
              - "logsufix" - "logsufixstr" {
              set_logSufix $val}
            "set_logoutputstream" - "set_logoutput" - "setlogoutput" \
              - "logoutput" - "logstream" - "setlogoutputstream" - "loSt" {
              [eval set_logOutputStream $val]}
            "set_loglevel" - "setloglevel" - "loglevel" - "loglvl" {
              set_logLevel $val}
            default {
              set remaining_arg_val [list {*}${remaining_arg_val} $arg $val]
              }
            }
          }
        }
    } else {
      logMsg "logLib::arg_interpreter: Odd number of optional arguments! args: $args" 2
      return ""
      }
    return ${remaining_arg_val}
    }
#|      - ;;

  }   ;# namespace eval logLib

#|  - ;
# printing information at 'source' time
puts "[::logLib::get_logName_version]: Library to manage log information messages."

