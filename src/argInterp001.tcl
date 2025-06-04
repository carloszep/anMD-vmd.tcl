#|-argInterp.tcl :
#|  -argument interpreter for tcl procs and namespaces .
#|  -any proc or namespace command with variable (optional) args
#|   _ that imports the argInterp namespace should be able to: :
#|    -perform specific actions associated to argument keywords or tokens :
#|      -actions :
#|        -assign values to variables .
#|        -call procedures or commands with a given list of arguments .
#|        -execute given tcl scripts ;;
#|    -declare specific keywords and aliases :
#|      -accordingly to the type of action intended for .
#|      -the declaration can be made at "declaration time" or later* ;
#|    -contain properties that dictate the behavior of the arg kewords :
#|      -decide if the argument can be used more than once .
#|      -type of argument (flag, var-val pair, procedural arg, ...) ;
#|    -admit different formats for the arguments :
#|      -'var val', 'var=val', '-var val', --var{val}, ... ;;
#|  -version information :
#|    -version :-0.0.1 ;
#|    -changes in progress in this version :
#|      -initial namespace declarations ;
#|    -to do list :
#|      -complete the initial working version .
#|      -perform tests ;;
#|  -dates :
#|    -created :-2023-09-04.Mon ;
#|    -modified :-2023-09-04.Mon ;
#|  -authors and contributors :
#|    -Carlos Z. Gómez Castro ;
#|  -notes :
#|    -for the moment it is implemented within the anMD tcl library ;

global argInterp_version
set argInterp_version 001

#|-source files :- ;
loadLib logLib.tcl

#|  -namespace argInterp :
namespace eval argInterp {

#|    -import :
#|      -::logLib::* :
#|        -logLib already  includes ;;
  namespace import ::logLib::*

#|    -export :
#|      -test_argInterp .
#|      - ;
  namespace export test_argInterp

#|    -namespace variables :
#|      -argInterp_args .
  variable artInterp_args {}

#|      -argInterp_coms ;

#|    -namspace commands :- ;;


  proc argInterp_init {} {

# configure logLib namespace used by argInterp
    set_logFileName "stdout"
    set_logLevel 2
    set_logName "argInterp"
    set_logVersion $argInterp_version

# adding commands and variables from argInterp to logLib namespace
#    add_commands [list argInterp_init]
#    add_variables [list interp_args]

# report initial configuration
    logMsg "initialized [get_logName_version]" 1
    logMsg "Argument interpreter for tcl commands" 1
    state_show 2

# flushes the output buffer
    logFlush

    }

#|  -prog set_arg :
#|    -defines/modifies arguments and options ;
#|    -arguments :
#|      -argName :- ;
#|    -optional arguments (args) :
#|      -'alias', 'aliases', 'names' :- ;
#|      -'default', 'defaultValue', 'defVal' ;;
  proc set_arg {argName args} {
    variable interp_args

# check whether the argument already is in the interp_args list
    set argPos [lsearch $interp_args $argName]
    if {$argPos == -1} {set interp_args [list {*}$interp_args $argName]}

# check optional arguments
    if {[expr {[llength $args]%2}] == 0} {   ;# even or 0 optional arguments
    if {[llength $args] > 0} {
      foreach {arg val} $args {
        switch [string tolower $arg] {
          "alias" - "aliases" - "names" {
            
            }
          "default" - "defaultValue" - "defVal" {
            }
          default {}
          }
        }
      }
    } else {
      logMsg "Odd number of optional arguments! Returning... args: $args" 1
      return ""
      }
    }   ;# proc set_arg

#|  - ;
  proc test_argInterp {} {
    }

}   ;# namespace eval argInterp

# initializes the argInterp namespace
::argInterp::argInterp_init



