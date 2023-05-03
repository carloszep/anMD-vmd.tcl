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
#|    -updated :-2023-05-02.Tue ;
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

#|    -commands :
#|      -init :- ;
#|      -graphicsOn :- ;
#|      -graphicsOff :- ;
#|      -shellComOn :- ;
#|      -shellComOff :- ;;;

source logLib.tcl

#|  -namespace anMD :
namespace eval anMDlib {
#|    -import :
#|      -::logLib::* ;
  namespace import ::logLib::*
#|    -variables :
#|      -useGraphics :- ;
#|      -useShellCom :- ;;
  variable useGraphics 1
  variable useShellCom 1

#|    -commands :
#|
  proc graphicsOn {} {
    variable useGraphics
    set useGraphics 1
    }

  proc graphicsOff {} {
    variable useGraphics
    set useGraphics 0
    }

  proc shellComOn {} {
    variable useShellCom
    set useShellCom 1
    }

  proc shellComOff {} {
    variable useShellCom
    set useShellCom 0
    }

#|      - ;;

  }   ;#  namespace eval anMD

#|  -initialization of the anMD namespace :
#|    -intended to show the usage of the library and setup default values .
#|    -set the name and version of the library using the logLib namespace .
::anMD::set_logName_version anMDlib 0.0.1
#|    -set the library path prepended to the log file .
::anMD::set_logPath ""
#|    -set the name of the file to output log messages .
#|    -settting logFileName to 'stdout' outputs log only to screen .
::anMD::set_logFileName "stdout"
#|    -set the logLevel controling the "amount" of log output .
::anMD::set_logLevel 1
#|    -activates the output to the screen additional to file log output .
::anMD::logScreenOn
#|    -incorportates the anMD list of commands to the logLib list .
::anMD::add_commands [list graphicsOn graphicsOff shellComOn shellComOff]
#|    -reports to log the initial configuration .
::anMD::logMsg "initialized [get_logName_version]" 1
::anMD::logMsg "Structural analysis of MD trajectories for VMD." 1
::anMD::logMsg "log path: [::anMD::get_logPath]"
::anMD::logMsg "log output to: [get_logOutputStream]" 2
::anMD::logMsg "output level: [get_logLevel]" 1
::anMD::logMsg "name of output file for log: [get_logFileName]" 2
::anMD::logMsg "print to screen: [get_logScreen]" 2
::anMD::logMsg "list of commands: [list_commands]" 2
#|    -flush the output buffer .
::anMD::logFlush
#|    - ;

#|  - ;


