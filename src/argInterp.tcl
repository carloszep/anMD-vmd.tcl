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
#|    -version :
#|      -002 :
#|        -date :-2025-06-15.Sun ;
#|        -the logLib_argInterp now always pre-process the userArg list .
#|        -the logLib options can be configured from any application ;
#|      -0.0.1 ;
#|        -date :-2025-06-03.Tue ;
#|        -complete initial working version .
#|        -integration with regVar and logLib namespaces .
#|        -support for multiple argument formats .
#|        -argument validation and type checking .
#|        -flexible alias system .
#|        -default value handling ;;
#|    -to do list :
#|      -add advanced validation functions .
#|      -implement script execution for arguments .
#|      -add help generation functionality ;;
#|  -dates :
#|    -created :-2023-09-04.Mon ;
#|    -modified :-2025-06-15.Sun ;
#|  -authors and contributors :
#|    -Carlos Z. Gómez Castro ;
#|    -Claude (implementation assistance) ;
#|  -notes :
#|    -integrates with regVar for variable storage and logLib for logging .
#|    -regVar is implicitly imported by loadLib .
#|    -input for the logLib_argInterp can be passed in the interpret_args
#|     _ userArgs input list ;

global argInterp_version
set argInterp_version 002

#|  -source files :
#|    -logLib ;
if {[info commands ::loadLib] ne ""} {
  loadLib logLib
} elseif {[file exists "logLib.tcl"]} {
  source logLib.tcl
} else {
  error "Cannot find logLib: neither loadLib command nor logLib.tcl file"
  }

#|  -namespace argInterp :
namespace eval argInterp {

#|    -import :
#|      -::logLib::* :
#|        -logLib for logging functionality .
#|      -::regVar::* :
#|        -regVar for variable storage ;;
  namespace import ::logLib::*
#  namespace import ::regVar::*

#|    -export :
#|      -argInterp_init .
#|      -set_arg .
#|      -get_arg .
#|      -remove_arg .
#|      -list_args .
#|      -clear_args .
#|      -interpret_args .
#|      -validate_args .
#|      -get_help .
#|      -state_save .
#|      -state_restore .
#|      -test_argInterp ;
  namespace export argInterp_init set_arg get_arg remove_arg list_args
  namespace export clear_args interpret_args validate_args get_help
  namespace export state_save state_restore test_argInterp

#|    -namespace variables :
#|      -l_argInterp_variables :
#|        -list of namespace variables for state management ;
  variable l_argInterp_variables [list l_argInterp_commands \
                                       current_context \
                                       validation_errors]

#|      -l_argInterp_commands :
#|        -list of exported commands ;
  variable l_argInterp_commands [list argInterp_init set_arg get_arg \
                                      remove_arg list_args clear_args \
                                      interpret_args validate_args \
                                      get_help state_save state_restore \
                                      test_argInterp]

#|      -current_context :
#|        -current context name for argument definitions ;
  variable current_context "default"

#|      -validation_errors :
#|        -list to store validation errors ;
  variable validation_errors {}

#|    -namespace commands :

#|      -proc argInterp_init {{context "default"}} :
#|        -initializes the argInterp namespace .
#|        -sets up logging configuration .
#|        -initializes regVar categories for argument storage ;
  proc argInterp_init {{context "default"}} {
    variable current_context
    variable l_argInterp_variables
    variable l_argInterp_commands
    
    # Configure logLib namespace used by argInterp
    set_logFileName "stdout"
    set_logLevel 2
    set_logName "argInterp"
    set_logVersion $::argInterp_version
    
    # Set current context
    set current_context $context
    
    # Initialize regVar categories for argument storage
    regVar_clear "argInterp_${context}"
    regVar_clear "argInterp_values_${context}"
    
    # Save initial state variables to regVar
    foreach var $l_argInterp_variables {
      variable $var
      varSave $var "argInterp_state"
    }
    
    # Report initial configuration
    logMsg "initialized [get_logName_version] with context: $context" 1
    logMsg "Argument interpreter for tcl commands" 1
    
    # Flush the output buffer
    logFlush
  }

#|    -proc set_arg {argName args} :
#|        -defines/modifies arguments and options .
#|        -arguments :
#|          -argName :
#|            -name of the argument to define ;
#|        -optional arguments (args) :
#|          -'alias', 'aliases' :
#|            -list of alternative names for the argument .
#|          -'default', 'defaultValue' :
#|            -default value for the argument .
#|          -'type' :
#|            -argument type: 'value', 'list', 'script' .
#|          -'required' :
#|            -boolean indicating if argument is required .
#|          -'multiple' :
#|            -boolean allowing multiple occurrences .
#|          -'validate' :
#|            -validation script or procedure name .
#|          -'action' :
#|            -action to perform when argument is found .
#|          -'help' :
#|            -help description for the argument ;;;
  proc set_arg {argName args} {
    variable current_context
    
    logMsg "argInterp::set_arg: defining argument '$argName' in context '$current_context'" 3
    
    # Initialize argument definition with defaults
    set argDef [dict create \
      name $argName \
      aliases {} \
      default "" \
      type "value" \
      required 0 \
      multiple 0 \
      validate "" \
      action "" \
      help "No description available"]
    
    # Process optional arguments
    if {[expr {[llength $args] % 2}] == 0} {
      if {[llength $args] > 0} {
        foreach {arg val} $args {
          switch [string tolower $arg] {
            "alias" - "aliases" {
              dict set argDef aliases $val
              logMsg "argInterp::set_arg: set aliases to: $val" 4
              }
            "default" - "defaultvalue" - "defval" {
              dict set argDef default $val
              logMsg "argInterp::set_arg: set default to: $val" 4
              }
            "type" {
              if {$val in {value list script}} {
                dict set argDef type $val
                logMsg "argInterp::set_arg: set type to: $val" 4
              } else {
                logMsg "argInterp::set_arg: invalid type '$val', using 'value'" 2
                dict set argDef type "value"
                }
              }
            "required" {
              dict set argDef required [expr {$val ? 1 : 0}]
              logMsg "argInterp::set_arg: set required to: [dict get $argDef required]" 4
              }
            "multiple" {
              dict set argDef multiple [expr {$val ? 1 : 0}]
              logMsg "argInterp::set_arg: set multiple to: [dict get $argDef multiple]" 4
              }
            "validate" {
              dict set argDef validate $val
              logMsg "argInterp::set_arg: set validation to: $val" 4
              }
            "action" {
              dict set argDef action $val
              logMsg "argInterp::set_arg: set action to: $val" 4
              }
            "help" {
              dict set argDef help $val
              logMsg "argInterp::set_arg: set help to: $val" 4
              }
            default {
              logMsg "argInterp::set_arg: unknown option '$arg' ignored" 2
              }
            }
          }
        }
    } else {
      logMsg "argInterp::set_arg: odd number of optional arguments! args: $args" 1
      return 0
      }
    
    # Store argument definition in regVar
    if {[catch {
      set argDefStr [dict_to_string $argDef]
      set categoryVar "argInterp_${current_context}"
      
      # Check if argument already exists and update or create
      if {[catch {getVarValue $argName $categoryVar} existingDef]} {
        # New argument
        varSave $argName $categoryVar
        set_regvar_value $argName $argDefStr $categoryVar
        logMsg "argInterp::set_arg: created new argument '$argName'" 3
      } else {
        # Update existing argument
        set_regvar_value $argName $argDefStr $categoryVar
        logMsg "argInterp::set_arg: updated existing argument '$argName'" 3
        }
    } err]} {
      logMsg "argInterp::set_arg: error storing argument definition: $err" 1
      return 0
      }
    
    return 1
    }

#|      -proc get_arg {argName {property ""}} :
#|        -retrieves argument definition or specific property .
#|        -arguments :
#|          -argName :
#|            -name of the argument .
#|          -property :
#|            -specific property to retrieve (optional) ;
  proc get_arg {argName {property ""}} {
    variable current_context
    
    set categoryVar "argInterp_${current_context}"
    
    if {[catch {
      set argDefStr [getVarValue $argName $categoryVar]
      set argDef [string_to_dict $argDefStr]
      
      if {$property eq ""} {
        return $argDef
      } else {
        if {[dict exists $argDef $property]} {
          return [dict get $argDef $property]
        } else {
          logMsg "argInterp::get_arg: property '$property' not found in argument '$argName'" 2
          return ""
        }
      }
    } err]} {
      logMsg "argInterp::get_arg: argument '$argName' not found: $err" 2
      return {}
    }
  }

#|      -proc remove_arg {argName} :
#|        -removes an argument definition .
#|        -arguments :
#|          -argName :
#|            -name of the argument to remove ;
  proc remove_arg {argName} {
    variable current_context
    
    set categoryVar "argInterp_${current_context}"
    
    if {[catch {
      varRemove [list $argName] $categoryVar
      logMsg "argInterp::remove_arg: removed argument '$argName'" 3
      return 1
    } err]} {
      logMsg "argInterp::remove_arg: error removing argument '$argName': $err" 2
      return 0
    }
  }

#|      -proc list_args {} :
#|        -returns list of defined arguments in current context ;
  proc list_args {} {
    variable current_context
    
    set categoryVar "argInterp_${current_context}"
    return [list_regVariables $categoryVar]
  }

#|      -proc clear_args {} :
#|        -removes all argument definitions from current context ;
  proc clear_args {} {
    variable current_context
    
    set categoryVar "argInterp_${current_context}"
    regVar_clear $categoryVar
    logMsg "argInterp::clear_args: cleared all arguments in context '$current_context'" 3
  }

#|      -proc interpret_args {userArgs {namespace_context ""} {process_logLib_args 1}} :
#|        -interprets user-provided arguments in the style of setCLOptions .
#|        -arguments :
#|          -userArgs :
#|            -list of user arguments to interpret .
#|          -namespace_context :
#|            -namespace where variables should be set (optional) .
#|          -process_logLib_args :
#|            -if 1, first pass arguments through logLib_argInterp (default: 1) ;
#|        -returns :
#|          -list of unprocessed arguments (like setCLOptions) ;
  proc interpret_args {userArgs {namespace_context ""} {process_logLib_args 1}} {
    variable current_context
    variable validation_errors
    
    logMsg "argInterp::interpret_args: processing list of arguments: $userArgs" 3
    
    set validation_errors {}
    set result [dict create]
    set remaining_args $userArgs
    
    # First pass: Process logLib arguments if enabled
    if {$process_logLib_args} {
      logMsg "argInterp::interpret_args: first pass - processing logLib arguments" 4
      if {[catch {
        set remaining_args [logLib_argInterp {*}$userArgs]
        logMsg "argInterp::interpret_args: logLib processed, remaining: $remaining_args" 4
      } err]} {
        logMsg "argInterp::interpret_args: error in logLib_argInterp: $err" 2
        # Continue with original args if logLib processing fails
        set remaining_args $userArgs
      }
    }
    
    # Get all defined arguments
    set definedArgs [list_args]
    
    # Check for even number of remaining arguments
    if {[expr {[llength $remaining_args] % 2}] == 0} {
      if {[llength $remaining_args] > 0} {
        foreach {arg val} $remaining_args {
          logMsg "argInterp::interpret_args: reading arg-val: $arg $val" 4
          set processed 0
          
          # Case-insensitive matching (like your setCLOptions)
          set normalizedArg [string tolower $arg]
          
          # Find matching argument definition
          set matchedArg [find_matching_arg_case_insensitive $normalizedArg $definedArgs]
          
          if {$matchedArg ne ""} {
            set argDef [get_arg $matchedArg]
            
            # Validate value if validator exists
            if {[validate_argument_value $matchedArg $val]} {
              dict set result $matchedArg $val
              set processed 1
              logMsg "argInterp::interpret_args: processed '$matchedArg' = '$val'" 4
              
              # Execute action if defined (for setter functions like set_cutoff)
              set action [dict get $argDef action]
              if {$action ne ""} {
                execute_argument_action $matchedArg $val $action $namespace_context
              } elseif {$namespace_context ne ""} {
                # Set variable in specified namespace (like your direct variable assignment)
                set_namespace_variable $matchedArg $val $namespace_context
              }
            } else {
              lappend validation_errors "Invalid value '$val' for argument '$matchedArg'"
              set processed 0
            }
          }
          
          if {!$processed} {
            logMsg "argInterp::interpret_args: argument (value) unknown: $arg ($val)" 2
            lappend unprocessed $arg $val
          }
        }
      }
      
      logMsg "argInterp::interpret_args: unused arguments: $unprocessed" 3
    } else {
      logMsg "argInterp::interpret_args: Odd number of remaining arguments: $remaining_args" 1
      return ""
    }
    
    # Store processed values and unprocessed args
    set valuesCategory "argInterp_values_${current_context}"
    regVar_clear $valuesCategory
    dict for {key value} $result {
      varSave $key $valuesCategory
      set_regvar_value $key $value $valuesCategory
    }
    
    # Store unprocessed arguments
    if {[llength $unprocessed] > 0} {
      varSave "unprocessed_args" $valuesCategory
      set_regvar_value "unprocessed_args" $unprocessed $valuesCategory
    }
    
    return $unprocessed
  }

#|      -proc validate_args {} :
#|        -validates processed arguments .
#|        -returns :
#|          -1 if validation passes, 0 otherwise ;
  proc validate_args {} {
    variable validation_errors
    
    if {[llength $validation_errors] > 0} {
      logMsg "argInterp::validate_args: validation errors found:" 1
      foreach error $validation_errors {
        logMsg "  $error" 1
      }
      return 0
    }
    
    logMsg "argInterp::validate_args: all arguments validated successfully" 3
    return 1
  }

#|      -proc get_help {{argName ""}} :
#|        -generates help information for arguments .
#|        -arguments :
#|          -argName :
#|            -specific argument name (optional) ;
  proc get_help {{argName ""}} {
    variable current_context
    
    if {$argName eq ""} {
      # Generate help for all arguments
      set helpText "Available arguments in context '$current_context':\n"
      
      set definedArgs [list_args]
      foreach arg $definedArgs {
        set argDef [get_arg $arg]
        set aliases [dict get $argDef aliases]
        set type [dict get $argDef type]
        set required [dict get $argDef required]
        set help [dict get $argDef help]
        
        append helpText "  $arg"
        if {[llength $aliases] > 0} {
          append helpText " (aliases: [join $aliases {, }])"
        }
        append helpText " - $type"
        if {$required} {
          append helpText " (required)"
        }
        append helpText "\n    $help\n"
      }
      
      return $helpText
    } else {
      # Generate help for specific argument
      if {[catch {
        set argDef [get_arg $argName]
        return "Argument '$argName': [dict get $argDef help]"
      } err]} {
        return "Argument '$argName' not found"
      }
    }
  }

#|      -proc state_save {} :
#|        -saves current argInterp state to regVar ;
  proc state_save {} {
    variable l_argInterp_variables
    variable current_context
    
    logMsg "argInterp::state_save: saving state for context '$current_context'" 3
    
    foreach var $l_argInterp_variables {
      variable $var
      varSave $var "argInterp_state"
    }
  }

#|      -proc state_restore {} :
#|        -restores argInterp state from regVar ;
  proc state_restore {} {
    variable l_argInterp_variables
    variable current_context
    
    logMsg "argInterp::state_restore: restoring state" 3
    
    foreach var $l_argInterp_variables {
      variable $var
      if {[varRestore $var "argInterp_state"]} {
        logMsg "argInterp::state_restore: restored $var" 4
      }
    }
  }

#|      -proc test_argInterp {} :
#|        -test procedure for argInterp functionality .
#|        -includes test in setCLOptions style ;
  proc test_argInterp {} {
    logMsg "argInterp::test_argInterp: running tests" 1
    
    # Test 1: Basic functionality test
    logMsg "argInterp::test_argInterp: Test 1 - Basic functionality" 1
    
    set_arg "input" \
      aliases {i in file} \
      type value \
      required 1 \
      help "Input file name"
    
    set_arg "verbose" \
      aliases {v} \
      help "Enable verbose output (use: verbose 1)"
    
    set_arg "output" \
      aliases {o out} \
      type value \
      default "output.txt" \
      help "Output file name"
    
    set testArgs {input input.txt verbose 1 output result.txt}
    set result [interpret_args $testArgs]
    
    logMsg "argInterp::test_argInterp: test result: $result" 1
    logMsg "argInterp::test_argInterp: validation: [validate_args]" 1
    
    # Test 2: setCLOptions style test
    logMsg "argInterp::test_argInterp: Test 2 - setCLOptions compatibility" 1
    
    # Clear previous definitions
    clear_args
    
    # Define arguments in setCLOptions style
    set_arg "src" \
      aliases {source input inputsource} \
      help "Source input"
    
    set_arg "pdbId" \
      aliases {pdbfile id vmdid molid} \
      help "PDB file identifier"
    
    set_arg "cutoff" \
      aliases {distcutoff distance dist r} \
      action "set_cutoff" \
      help "Distance cutoff"
    
    set_arg "bll" \
      aliases {baseloglevel baseloglvl} \
      action "set_bll" \
      help "Base log level"
    
    # Test with setCLOptions-style arguments including logLib args
    set testArgs2 {src test.pdb PDBID 123 cutoff 5.0 logLevel 4 logFileName test.log unknown_arg unknown_val}
    set unprocessed [interpret_args $testArgs2]
    
    logMsg "argInterp::test_argInterp: unprocessed args (should contain unknown_arg): $unprocessed" 1
    logMsg "argInterp::test_argInterp: logLib should have processed logLevel and logFileName" 1
    
    # Test 3: Create a setCLOptions replacement
    logMsg "argInterp::test_argInterp: Test 3 - setCLOptions replacement" 1
    
    # Create test namespace and replacement procedure
    namespace eval ::testNS {
      variable src ""
      variable pdbId ""
      variable cutoff 0.0
      variable procN "testNS"
      
      proc set_cutoff {val} {
        variable cutoff
        set cutoff $val
        ::logLib::logMsg "testNS::set_cutoff: cutoff set to $val" 2
      }
    }
    
    create_setCLOptions_replacement "::testNS" "setCLOptions"
    
    # Test the replacement
    set unprocessed2 [::testNS::setCLOptions src myfile.pdb pdbid 456 cutoff 3.5 extra_arg extra_val]
    logMsg "argInterp::test_argInterp: replacement procedure returned: $unprocessed2" 1
    
    # Display help
    logMsg "argInterp::test_argInterp: help text:\n[get_help]" 1
  }

#|    -helper procedures :

#|      -proc dict_to_string {dictVar} :
#|        -converts dictionary to string representation ;
  proc dict_to_string {dictVar} {
    set result {}
    dict for {key value} $dictVar {
      lappend result $key $value
    }
    return $result
  }

#|      -proc string_to_dict {stringVar} :
#|        -converts string representation back to dictionary ;
  proc string_to_dict {stringVar} {
    return $stringVar
  }

#|      -proc set_regvar_value {varName value category} :
#|        -sets value in regVar category ;
  proc set_regvar_value {varName value category} {
    # Create a temporary variable with the value and save it
    set tempVar $value
    upvar 0 tempVar localTemp
    varSave $varName $category
    # Directly access the regVar internal storage
    variable ::regVar::a_cat_${category}
    upvar 0 ::regVar::a_cat_${category} categoryArray
    set categoryArray($varName) $value
  }

#|      -proc normalize_arg_name {argName} :
#|        -normalizes argument name by removing prefixes ;
  proc normalize_arg_name {argName} {
    set normalized $argName
    # Remove leading dashes
    set normalized [string trimleft $normalized "-"]
    return $normalized
  }

#|      -proc find_matching_arg_case_insensitive {normalizedName definedArgs} :
#|        -finds matching argument from defined args (case-insensitive) ;
  proc find_matching_arg_case_insensitive {normalizedName definedArgs} {
    # First try exact match (case-insensitive)
    foreach argName $definedArgs {
      if {[string tolower $argName] eq $normalizedName} {
        return $argName
      }
    }
    
    # Then try aliases (case-insensitive)
    foreach argName $definedArgs {
      set argDef [get_arg $argName]
      set aliases [dict get $argDef aliases]
      foreach alias $aliases {
        if {[string tolower $alias] eq $normalizedName} {
          return $argName
        }
      }
    }
    
    return ""
  }

#|      -proc execute_argument_action {argName value action namespace_context} :
#|        -executes action associated with argument (like set_cutoff functions) ;
  proc execute_argument_action {argName value action namespace_context} {
    logMsg "argInterp::execute_argument_action: executing action '$action' for '$argName' with value '$value'" 4
    
    if {[catch {
      if {$namespace_context ne ""} {
        # Execute action in specified namespace context
        namespace eval $namespace_context [list $action $value]
      } else {
        # Execute action in current context
        eval $action [list $value]
      }
    } err]} {
      logMsg "argInterp::execute_argument_action: error executing action '$action': $err" 1
    }
  }

#|      -proc set_namespace_variable {varName value namespace_context} :
#|        -sets variable in specified namespace (like your direct assignment) ;
  proc set_namespace_variable {varName value namespace_context} {
    if {[catch {
      namespace eval $namespace_context [list variable $varName]
      namespace eval $namespace_context [list set $varName $value]
      logMsg "argInterp::set_namespace_variable: set ${namespace_context}::$varName = '$value'" 4
    } err]} {
      logMsg "argInterp::set_namespace_variable: error setting variable: $err" 1
    }
  }

#|      -proc create_setCLOptions_replacement {namespace_name procName} :
#|        -creates a replacement procedure in setCLOptions style .
#|        -arguments :
#|          -namespace_name :
#|            -namespace where the procedure should be created .
#|          -procName :
#|            -name for the replacement procedure ;
  proc create_setCLOptions_replacement {namespace_name procName} {
    set procBody "
    # Process arguments using argInterp (including logLib integration)
    set unprocessed_args \[::argInterp::interpret_args \$args \"$namespace_name\" 1\]
    
    # Log final message (matching your style)
    variable procN
    if {\[info exists procN\]} {
      ::logLib::logMsg \"\$procN: unused arguments: \$unprocessed_args\"
    } else {
      ::logLib::logMsg \"$procName: unused arguments: \$unprocessed_args\"
    }
    
    return \$unprocessed_args
    "
    
    namespace eval $namespace_name "
      proc $procName {args} {$procBody}
    "
    
    logMsg "argInterp::create_setCLOptions_replacement: created procedure ${namespace_name}::$procName" 3
  }

#|      -proc validate_argument_value {argName value} :
#|        -validates argument value using defined validator ;
  proc validate_argument_value {argName value} {
    set argDef [get_arg $argName]
    set validator [dict get $argDef validate]
    
    if {$validator eq ""} {
      return 1
    }
    
    # Simple built-in validators
    switch $validator {
      "integer" {
        return [string is integer $value]
      }
      "double" {
        return [string is double $value]
      }
      "file_exists" {
        return [file exists $value]
      }
      default {
        # Try to execute as script
        if {[catch {
          set result [eval $validator [list $value]]
          return [expr {$result ? 1 : 0}]
        } err]} {
          logMsg "argInterp::validate_argument_value: validation error: $err" 2
          return 0
        }
      }
    }
  }

}   ;# namespace eval argInterp

# Initialize the argInterp namespace with default context
::argInterp::argInterp_init

