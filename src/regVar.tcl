#|-regVar.tcl :
#|  -declares the regVar namespace that stores variables and values
#|   _ for other namespaces .
#|  -dates :
#|    -created :
#|      -2023-09-07.Thu ;
#|    -modified :
#|      -2023-09-07.Thu ;;
#|  -atuhors and contributors :
#|    -Carlos Z. Gómez Castro ;
#|  -public software repositories :
#|    -https://github.com/carloszep/anMD-vmd.tcl ;
#|  -version information :
#|    -version :-0.0.1 ;
#|    -changes in progress :
#|      -initial declarations ;
#|    -to do list :
#|      -to complete definitio of variable and commands .
#|      -perform tests ;
#|  -notes :
#|    - ;;
#|  -namespace regVar :
namespace eval regVar {
#|    -export :
#|      -varSave .
#|      -varRestore .
#|      -list_regVariables ;
  namespace export varSave varRestore list_regVariables
#|    -variables :
#|      -l_regVariables :
#|        -list of all registered variables ;;
  variable l_regVariables {}

#|    -commands :
#|      -proc varSave {varName} :
#|        -adds a variable including it current vaule in the calling proc ;
  proc varSave {varName} {
    upvar $varName var
    variable l_regVariables
    variable $varName $var
    lappend l_regVariables $varName
    }

#|      -proc varRestore {} :
#|        -updates the value of a registered variable varName .
#|        -returns 1 if the value was updated or 0 otherwise, i.e., when
#|         _ the variable is not registered in l_regVariables ;
  proc varRestore {varName} {
    upvar $varName var
    variable l_regVariables
    variable $varName
    if {[lsearch $l_regVariables $varName] >= 0} {
      set var [set $varName]
      return 1
    } else {
      return 0
      }
    }

#|      -proc list_variables {} :
#|        -returns the list of registered (saved) variables ;
  proc list_regVariables {} {
    variable l_regVariables
    return $l_regVariables
    }
#|      - ;;
#|  - ;
  }   ;#   namespace eval state

