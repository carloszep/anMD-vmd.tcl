#|-userInfo.tcl :| 
#|  -tcl scripts library to manage VMD trajectories from MD simulations .
#|  -assists in incorporating user-specified information from simulations .
#|  -declares the namespace containing the varaibles and commands to be
#|   _ used by other analysis tools .
#|  -started from the userInfo_v.0.0.5 library .
#|  -dates :
#|    -created :-2023-05-03.Wed ;
#|    -modified :-2023-05-03.Wed ;;
#|  -authors and contributors :
#|    -Carlos Z. Gómez Castro ;
#|  -public software repositories :
#|    -https://github.com/carloszep/anMD-vmd.tcl ;
#|  -version information :
#|    -current version :-0.0.1 ;
#|    -changes in progress :
#|      -definition of the userInfo namespace ;;
#|  -notes :
#|    -for the moment this library uses the global array selInfo ;
#|  -source :
#|    -logLib.tcl ;
source logLib.tcl
#|  -namespace eval userInfo :
namespace eval userInfo {

#|    -import :
#|      -::logLib::* ;
  namespace import ::logLib::*

#|    -variables :
#|      -maxTrajSizeGB .
#|      -currTrajSizeGB .
#|      -trajFragList .
#|      - ;
  variable maxTrajSizeGB 6.0
  variable currTrajSizeGB 0.0
  variable trajFragList [list fragName simName dcdFile timeStep dcdFreq \
               loadStep dcdSize iniTime finTime iniFrame finFrame frameTime]
  variable indTFL

#|    -commands :
#|      -proc init {} :
#|        - ;
  proc init {} {
    variable indTFL
    variable trajFragList
    set i 0
    foreach elem $trajFragList {
      set indTFL($elem) $i
      incr i
      }
    logMsg "initialized indices array indTFL from trajFragList..." 3
    logMsg "trajFragList: [get_trajFragList]" 2
    }
#|      -proc get_maxTrajSizeGB {} :
#|        - ;
  proc get_maxTrajSizeGB {} {
    variable maxTrajSizeGB
    return $maxTrajSizeGB
    }

#|      -proc set_maxTrajSizeGB {trajSize} :
#|        - ;
  proc set_maxTrajSizeGB {trajSize} {
    variable maxTrajSizeGB
    set maxTrajSizeGB $trajSize
    }

#|      -proc loadedTrajSize {} :
#|        - ;
  proc loadedTrajSize {} {
    variable currTrajSizeGB
    return $currTrajSizeGB
    }

#|      -proc get_trajFragList {} :
#|        - ;
  proc get_trajFragList {} {
    variable trajFragList
    return $trajFragList 
    }

#|      - ;
#|    - ;
  }   ;# namespace eval userInfo

#|  -initialization of the userInfo namespace :
#|    -intended to show the usage of the library and setup default values .
#|    -set the name and version of the library using the logLib namespace .
::userInfo::set_logName_version userInfo 0.0.1
#|    -set the library path prepended to the log file .
::userInfo::set_logPath ""
#|    -set the name of the file to output log messages .
#|    -settting logFileName to 'stdout' outputs log only to screen .
::userInfo::set_logFileName "stdout"
#|    -set the logLevel controling the "amount" of log output .
::userInfo::set_logLevel 3
#|    -activates the output to the screen additional to file log output .
::userInfo::logScreenOn
#|    -incorportates the userInfo list of commands to the logLib list .
::userInfo::add_commands [list get_maxTrajSizeGB set_maxTrajSizeGB loadedTrajSize \
                               get_trajFragList]
#|    -reports to log the initial configuration .
::userInfo::logMsg "initialized [::userInfo::get_logName_version]" 1
::userInfo::logMsg "Manage VMD trajectories from MD simulations." 1
::userInfo::logMsg "log path: [::userInfo::get_logPath]" 2
::userInfo::logMsg "log output to: [::userInfo::get_logOutputStream]" 2
::userInfo::logMsg "output level: [::userInfo::get_logLevel]" 1
::userInfo::logMsg "output file for log: [::userInfo::get_logFileName]" 2
::userInfo::logMsg "print to screen: [::userInfo::get_logScreen]" 2
::userInfo::logMsg "list of commands: [::userInfo::list_commands]" 2
#|    -flush the output buffer .
::userInfo::logFlush
#|    -run the initialization proc .
::userInfo::init

#|    - ;

#|  - ;| eof



