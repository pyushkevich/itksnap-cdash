# This is an include file for build_robot.cmake. It includes some functions that 
# can be reused in other such scripts.

# this is a standard macro from http://www.cmake.org/Wiki/CMakeMacroParseArguments
MACRO(PARSE_ARGUMENTS prefix arg_names option_names)
  SET(DEFAULT_ARGS)
  FOREACH(arg_name ${arg_names})    
    SET(${prefix}_${arg_name})
  ENDFOREACH(arg_name)
  FOREACH(option ${option_names})
    SET(${prefix}_${option} FALSE)
  ENDFOREACH(option)

  SET(current_arg_name DEFAULT_ARGS)
  SET(current_arg_list)
  FOREACH(arg ${ARGN})            
    SET(larg_names ${arg_names})    
    LIST(FIND larg_names "${arg}" is_arg_name)                   
    IF (is_arg_name GREATER -1)
      SET(${prefix}_${current_arg_name} ${current_arg_list})
      SET(current_arg_name ${arg})
      SET(current_arg_list)
    ELSE (is_arg_name GREATER -1)
      SET(loption_names ${option_names})    
      LIST(FIND loption_names "${arg}" is_option)            
      IF (is_option GREATER -1)
	     SET(${prefix}_${arg} TRUE)
      ELSE (is_option GREATER -1)
	     SET(current_arg_list ${current_arg_list} ${arg})
      ENDIF (is_option GREATER -1)
    ENDIF (is_arg_name GREATER -1)
  ENDFOREACH(arg)
  SET(${prefix}_${current_arg_name} ${current_arg_list})
ENDMACRO(PARSE_ARGUMENTS)

# Generate the CACHE_ADD function, which can be used by the site-specific
# scripts to conditionally add variables to the cache. The syntax for this
# command is 
#   CACHE_ADD(Line [PRODUCT regex] [CONFIG regex] [BRANCH regex])
#
MACRO(CACHE_ADD Line)

  # Parse out the arguments
  PARSE_ARGUMENTS(ARG "PRODUCT;CONFIG;BRANCH" "" ${ARGN})

  # Check the matches
  SET(CACHE_ADD_FLAG TRUE)
  IF(ARG_PRODUCT)
    IF(NOT ${IN_PRODUCT} MATCHES ${ARG_PRODUCT})
      SET(CACHE_ADD_FLAG FALSE)
    ENDIF(NOT ${IN_PRODUCT} MATCHES ${ARG_PRODUCT})
  ENDIF(ARG_PRODUCT)

  IF(ARG_BRANCH)
    IF(NOT ${IN_BRANCH} MATCHES ${ARG_BRANCH})
      SET(CACHE_ADD_FLAG FALSE)
    ENDIF(NOT ${IN_BRANCH} MATCHES ${ARG_BRANCH})
  ENDIF(ARG_BRANCH)

  IF(ARG_CONFIG)
    IF(NOT ${IN_CONFIG} MATCHES ${ARG_CONFIG})
      SET(CACHE_ADD_FLAG FALSE)
    ENDIF(NOT ${IN_CONFIG} MATCHES ${ARG_CONFIG})
  ENDIF(ARG_CONFIG)

  # Append the value to the INIT_CACHE
  IF(CACHE_ADD_FLAG)
    SET(INIT_CACHE "
      ${INIT_CACHE}
      ${Line}
      ")
  ENDIF(CACHE_ADD_FLAG)

ENDMACRO(CACHE_ADD)

# A conditional set command
# 
#   CONDSET(Variable TestVar TestVal TrueVal FalseVal)

# Check if a variable is defined and exit if it is not
MACRO(CHECK_SITE_VAR Variable)
  IF(NOT DEFINED ${Variable})
    MESSAGE(FATAL_ERROR "Variable ${Variable} not set by site-specific script")
  ENDIF(NOT DEFINED ${Variable})
ENDMACRO(CHECK_SITE_VAR)

