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
#|    -contain properties that dictate the bihavior of the arg kewords :
#|      -decide if the argument can be used more than once .
#|      -type of argument (flag, var-val pair, procedural arg, ...) ;;
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

#|  -namespace argInterp :
namespace eval argInterp {
#|    -import :- ;
#|    -export :
#|      -test_argInterp .
#|      - ;
#|    -namespace variables :
#|      -interp_vars .
#|      -interp_coms ;
#|    -namspace commands :- ;;;
  variable interp_vars {}
  variable interp_coms {}

  proc test_argInterp {} {
    }

}   ;# namespace eval argInterp

