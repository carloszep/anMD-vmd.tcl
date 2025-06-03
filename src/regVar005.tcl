#|-regVar.tcl :
#|  -declares the regVar namespace that stores variables and their values
#|   _ for other namespaces .
#|  -dates :
#|    -created :
#|      -2023-09-07.Thu ;
#|    -modified :
#|      -2025-06-03.Tue ;;
#|  -authors and contributors :
#|    -Carlos Z. Gómez Castro ;
#|  -public software repositories :
#|    -https://github.com/carloszep/anMD-vmd.tcl ;
#|  -version :
#|    -0.0.5 :
#|      -completed :
#|        -2025-06-02.Mon ;
#|      -changes :
#|        -bug fixed for proc varSave .
#|        -added variable classification system with categories .
#|        -extended all procedures to support optional category parameter .
#|        -added new procs: list_categories, list_regVariables_byCategory ;;
#|    -0.0.4 :
#|      -procedures varSave and varRemove rewritten by Claude
#|       _ to manage repeated or missing variable names ;;
#|  -to do list :
#|    -implement procedures to write/read variables from files .
#|    -to complete definition of variables and commands .
#|    -perform tests ;
#|  -notes :
#|    -v005 rewritten by Claude to manage the variable calssification feature ;
set regVar_version 0.0.5

#|  -namespace regVar :
namespace eval regVar {
#|    -export :
#|      -varSave .
#|      -varRestore .
#|      -list_regVariables .
#|      -list_regVariables_byCategory .
#|      -list_categories .
#|      -varRemove .
#|      -regVar_clear ;
  namespace export varSave varRestore list_regVariables
  namespace export list_regVariables_byCategory list_categories
  namespace export varRemove regVar_clear

#|    -variables :
#|      -l_regVariables :
#|        -list of all registered variables .
#|      -a_varCategories :
#|        -array mapping variable names to their categories ;;
  variable l_regVariables {}
  variable a_varCategories
  array set a_varCategories {}

#|    -commands :
#|      -proc varSave {varName {category "default"}} :
#|        -adds a variable including its current value in the calling proc .
#|        -optionally assigns it to a category (default: "default") .
#|        -if the variable does not exists it is created with an empty value ;
proc varSave {varName {category "default"}} {
  variable l_regVariables
  variable a_varCategories
  
  # Check if variable exists in calling scope
  if {[uplevel 1 [list info exists $varName]]} {
    # Variable exists, get its value
    upvar $varName var
    variable $varName $var
  } else {
    # Variable doesn't exist, create it with empty value
    variable $varName ""
    }
  
  # Add to list if not already present
  if {[lsearch $l_regVariables $varName] < 0} {
    lappend l_regVariables $varName
    }
  
  # Set category
  set a_varCategories($varName) $category
  }

#|      -proc varRestore {varName} :
#|        -updates the value of a registered variable varName .
#|        -returns 1 if the value was updated or 0 otherwise, i.e., when
#|         * the variable is not registered in l_regVariables ;
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

#|      -proc list_regVariables {{category ""}} :
#|        -returns the list of registered (saved) variables .
#|        -if category is specified, returns only variables in that category ;;
  proc list_regVariables {{category ""}} {
    variable l_regVariables
    variable a_varCategories
    
    if {$category eq ""} {
      return $l_regVariables
    } else {
      set categoryVars {}
      foreach varName $l_regVariables {
        if {[info exists a_varCategories($varName)] && 
            $a_varCategories($varName) eq $category} {
          lappend categoryVars $varName
        }
      }
      return $categoryVars
    }
  }

#|      -proc list_regVariables_byCategory {} :
#|        -returns a dictionary/list mapping categories to their variables ;;
  proc list_regVariables_byCategory {} {
    variable l_regVariables
    variable a_varCategories
    
    array set categoryDict {}
    
    foreach varName $l_regVariables {
      if {[info exists a_varCategories($varName)]} {
        set cat $a_varCategories($varName)
        if {![info exists categoryDict($cat)]} {
          set categoryDict($cat) {}
        }
        lappend categoryDict($cat) $varName
      }
    }
    
    return [array get categoryDict]
  }

#|      -proc list_categories {} :
#|        -returns a list of all categories currently in use ;;
  proc list_categories {} {
    variable l_regVariables
    variable a_varCategories
    
    set categories {}
    foreach varName $l_regVariables {
      if {[info exists a_varCategories($varName)]} {
        set cat $a_varCategories($varName)
        if {[lsearch $categories $cat] < 0} {
          lappend categories $cat
        }
      }
    }
    
    return [lsort $categories]
  }

#|      -proc varRemove {varNames} :
#|        -removes one or more elements in l_regVariables list .
#|        -also removes their category associations .
#|        -the elements to delete are specified by .
#|        -notes :
#|          -Claude improved ;;
  proc varRemove {varNames} {
    variable l_regVariables
    variable a_varCategories
    
    foreach varName $varNames {
      set ind [lsearch $l_regVariables $varName]
      if {$ind >= 0} {
        set l_regVariables [lreplace $l_regVariables $ind $ind]
        
        # Remove category association
        if {[info exists a_varCategories($varName)]} {
          unset a_varCategories($varName)
        }
        
        # Remove namespace variable
        if {[info exists $varName]} {
          variable $varName
          unset $varName
        }
      }
    }
  }

#|      -proc regVar_clear {{category ""}} :
#|        -removes all variables stored in the namespace .
#|        -if category is specified, removes only variables in that category ;
  proc regVar_clear {{category ""}} {
    if {$category eq ""} {
      varRemove [list_regVariables]
    } else {
      varRemove [list_regVariables $category]
    }
  }

#|      - ;;
#|  - ;
}   ;#   namespace eval regVar

