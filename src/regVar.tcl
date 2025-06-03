#|-regVar.tcl :
#|  -declares the regVar namespace that stores variables and values
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
#|    -0.0.6 :
#|      -date :
#|        -2025-06-03.Tue ;
#|      -changes :
#|        -redesigned storage to use category-based arrays .
#|        -allows same variable names in different categories .
#|        -variables now stored as categoryName(varName) internally ;;
#|    -0.0.5 :
#|      -date :
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
#|    - .
set regVar_version 0.0.6

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
#|      -a_categoryVars :
#|        -array where keys are categories and values are lists of variable names .
#|      -storage arrays :
#|        -each category gets its own array: a_cat_${category} ;;
  variable a_categoryVars
  array set a_categoryVars {}

#|    -commands :
#|      -proc varSave {varName {category "default"}} :
#|        -adds a variable including its current value in the calling proc .
#|        -assigns it to a category (default: "default") .
#|        -if the variable does not exists it is created with an empty value .
#|        -allows same variable names in different categories ;
proc varSave {varName {category "default"}} {
  variable a_categoryVars
  
  # Initialize category if it doesn't exist
  if {![info exists a_categoryVars($category)]} {
    set a_categoryVars($category) {}
    }
  
  # Create or access the category-specific array
  variable a_cat_${category}
  if {![array exists a_cat_${category}]} {
    array set a_cat_${category} {}
    }
  
  # Check if variable exists in calling scope
  if {[uplevel 1 [list info exists $varName]]} {
    # Variable exists, get its value
    upvar $varName var
    set a_cat_${category}($varName) $var
  } else {
    # Variable doesn't exist, create it with empty value
    set a_cat_${category}($varName) ""
    }
  
  # Add to category variable list if not already present
  if {[lsearch $a_categoryVars($category) $varName] < 0} {
    lappend a_categoryVars($category) $varName
    }
  }

#|      -proc varRestore {varName {category "default"}} :
#|        -updates the value of a registered variable varName from
#|         _ specified category .
#|        -returns 1 if the value was updated or 0 otherwise, i.e., when
#|         _ the variable is not registered in the category ;
  proc varRestore {varName {category "default"}} {
    upvar $varName var
    variable a_categoryVars
    
    # Check if category exists and contains the variable
    if {[info exists a_categoryVars($category)] && 
        [lsearch $a_categoryVars($category) $varName] >= 0} {
      
      variable a_cat_${category}
      if {[info exists a_cat_${category}($varName)]} {
        set var $a_cat_${category}($varName)
        return 1
        }
      }
    return 0
    }

#|      -proc list_regVariables {{category ""}} :
#|        -returns the list of registered (saved) variables .
#|        -if category is specified, returns only variables in that category .
#|        -if no category specified, returns all variables from all categories ;;
  proc list_regVariables {{category ""}} {
    variable a_categoryVars
    
    if {$category eq ""} {
      # Return all variables from all categories
      set allVars {}
      foreach cat [array names a_categoryVars] {
        foreach varName $a_categoryVars($cat) {
          lappend allVars "${cat}::${varName}"
        }
      }
      return $allVars
    } else {
      # Return variables from specific category
      if {[info exists a_categoryVars($category)]} {
        return $a_categoryVars($category)
      } else {
        return {}
        }
      }
    }

#|      -proc list_regVariables_byCategory {} :
#|        -returns a dictionary/list mapping categories to their variables ;;
  proc list_regVariables_byCategory {} {
    variable a_categoryVars
    return [array get a_categoryVars]
    }

#|      -proc list_categories {} :
#|        -returns a list of all categories currently in use ;;
  proc list_categories {} {
    variable a_categoryVars
    return [lsort [array names a_categoryVars]]
    }

#|      -proc varRemove {varNames {category "default"}} :
#|        -removes one or more variables from specified category .
#|        -the elements to delete are specified by varNames .
#|        -if category not specified, removes from "default" category ;;
  proc varRemove {varNames {category "default"}} {
    variable a_categoryVars
    
    # Check if category exists
    if {![info exists a_categoryVars($category)]} {
      return
      }
    
    variable a_cat_${category}
    
    foreach varName $varNames {
      set ind [lsearch $a_categoryVars($category) $varName]
      if {$ind >= 0} {
        # Remove from category variable list
        set a_categoryVars($category) [lreplace $a_categoryVars($category) $ind $ind]
        
        # Remove from category array
        if {[info exists a_cat_${category}($varName)]} {
          unset a_cat_${category}($varName)
          }
        }
      }
    
    # Clean up empty category
    if {[llength $a_categoryVars($category)] == 0} {
      unset a_categoryVars($category)
      if {[array exists a_cat_${category}]} {
        unset a_cat_${category}
        }
      }
    }

#|      -proc regVar_clear {{category ""}} :
#|        -removes all variables stored in the namespace .
#|        -if category is specified, removes only variables in that category ;
  proc regVar_clear {{category ""}} {
    variable a_categoryVars
    
    if {$category eq ""} {
      # Clear all categories
      foreach cat [array names a_categoryVars] {
        varRemove $a_categoryVars($cat) $cat
        }
    } else {
      # Clear specific category
      if {[info exists a_categoryVars($category)]} {
        varRemove $a_categoryVars($category) $category
        }
      }
    }

#|      -proc getVarValue {varName {category "default"}} :
#|        -returns the stored value of a variable without restoring it .
#|        -useful for inspection without modifying calling scope ;;
  proc getVarValue {varName {category "default"}} {
    variable a_categoryVars
    
    if {[info exists a_categoryVars($category)] && 
        [lsearch $a_categoryVars($category) $varName] >= 0} {
      
      variable a_cat_${category}
      if {[info exists a_cat_${category}($varName)]} {
        return $a_cat_${category}($varName)
        }
      }
    error "Variable '$varName' not found in category '$category'"
    }

#|      - ;;
#|  - ;
}   ;#   namespace eval regVar

