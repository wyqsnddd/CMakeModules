find_package(PkgConfig)


pkg_check_modules(GUROBI QUIET GUROBI)

# - Try to find GUROBI
# Once done this will define
#  GUROBI_FOUND - System has Gurobi
#  GUROBI_INCLUDE_DIRS - The Gurobi include directories
#  GUROBI_LIBRARIES - The libraries needed to use Gurobi

if (GUROBI_INCLUDE_DIR)
  # in cache already
  set(GUROBI_FOUND TRUE)
  set(GUROBI_INCLUDE_DIRS "${GUROBI_INCLUDE_DIR}" )
  set(GUROBI_LIBRARIES "${GUROBI_LIBRARY};${GUROBI_CXX_LIBRARY}" )
else (GUROBI_INCLUDE_DIR)

find_path(GUROBI_INCLUDE_DIR 
          NAMES gurobi_c++.h
          PATHS
	  "$ENV{GUROBI_HOME}/include"
          )

set(CMAKE_FIND_LIBRARY_SUFFIXES ".so" ".a")

find_library( GUROBI_LIBRARY 
              NAMES gurobi90
              PATHS
	      ENV GUROBI_HOME
	      PATH_SUFFIXES
	      "lib"
              )


      #find_library( GUROBI_CXX_LIBRARY 
      #	      NAMES gurobi_c++
      #	      PATHS "$ENV{GUROBI_HOME}/lib" 
      #              )

set( GUROBI_CXX_LIBRARY $ENV{GUROBI_HOME}/lib/libgurobi_g++5.2.a)

set(GUROBI_INCLUDE_DIRS "${GUROBI_INCLUDE_DIR}" )
set(GUROBI_LIBRARIES "${GUROBI_LIBRARY};${GUROBI_CXX_LIBRARY}" )


# use c++ headers as default
# set(GUROBI_COMPILER_FLAGS "-DIL_STD" CACHE STRING "Gurobi Compiler Flags")

include(FindPackageHandleStandardArgs)
# handle the QUIETLY and REQUIRED arguments and set LIBCPLEX_FOUND to TRUE
# if all listed variables are TRUE
find_package_handle_standard_args(GUROBI  DEFAULT_MSG
                                  GUROBI_LIBRARY GUROBI_CXX_LIBRARY GUROBI_INCLUDE_DIR)

# mark_as_advanced(GUROBI_INCLUDE_DIR GUROBI_LIBRARY GUROBI_CXX_LIBRARY)

endif(GUROBI_INCLUDE_DIR)

