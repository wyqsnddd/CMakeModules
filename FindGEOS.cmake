# Try to find the GEOS library
#
# In order:
# - try to find_package(geos) (upstream package)
# - try to use geos-config to find the geos installation prefix
# - try to find the geos library
#
# If the library is found, then you can use the GEOS::geos target
#
# This module will use GEOS_PREFIX as an hint to find either the geos-config
# executable or the geos library


message("FindGEOS.cmake start")

if(NOT TARGET GEOS::GEOS)

  if(NOT GEOS_FOUND)
    if(NOT DEFINED GEOS_PREFIX)
      set(GEOS_PREFIX ${CMAKE_INSTALL_PREFIX})
    endif()
    # Find the GEOS-config program
    find_program(GEOS_CONFIG geos-config
      /usr/local/bin
      /usr/bin
      ${GEOS_PREFIX}/bin
      ${CMAKE_INSTALL_PREFIX}/bin
      )
    if(GEOS_CONFIG)
      # Get GEOS_INSTALL_PREFIX from geos-config
      exec_program(${GEOS_CONFIG} ARGS --prefix OUTPUT_VARIABLE GEOS_INSTALL_PREFIX)
      find_library(GEOS_LIBRARY
	NAME geos # Find the C++ library
        HINTS ${GEOS_INSTALL_PREFIX} ${GEOS_PREFIX} ${CMAKE_INSTALL_PREFIX}
        PATH_SUFFIXES lib lib64
	)
      find_library(GEOS_C_LIBRARY
	NAME geos_c # Find the C library
        HINTS ${GEOS_INSTALL_PREFIX} ${GEOS_PREFIX} ${CMAKE_INSTALL_PREFIX}
        PATH_SUFFIXES lib lib64
	)
      if(NOT GEOS_LIBRARY)
	message(FATAL_ERROR "Found GEOS install prefix (${GEOS_INSTALL_PREFIX}) but no geos library")
      endif()
      if(NOT GEOS_C_LIBRARY)
	message(FATAL_ERROR "Found GEOS install prefix (${GEOS_INSTALL_PREFIX}) but no geos_c library")
      endif()
      message("-- Found GEOS by geos-config: ${GEOS_LIBRARY}")
      message("-- Found GEOS by geos-config: ${GEOS_C_LIBRARY}")
    else()
      find_library(GEOS_LIBRARY
	NAMES geos geos_c
	HINTS ${GEOS_PREFIX} ${CMAKE_INSTALL_PREFIX}
	PATH_SUFFIXES lib lib64
	)
      find_library(GEOS_C_LIBRARY
	NAME geos_c # Find the C library
        HINTS ${GEOS_INSTALL_PREFIX} ${GEOS_PREFIX} ${CMAKE_INSTALL_PREFIX}
        PATH_SUFFIXES lib lib64
	)

      if(GEOS_LIBRARY)
	get_filename_component(GEOS_INSTALL_PREFIX ${GEOS_LIBRARY} DIRECTORY)
	set(GEOS_INSTALL_PREFIX "${GEOS_INSTALL_PREFIX}/..")
	get_filename_component(GEOS_INSTALL_PREFIX ${GEOS_INSTALL_PREFIX} ABSOLUTE)
	message("-- Found GEOS library: ${GEOS_LIBRARY}")
      else()
	message(FATAL_ERROR "Could not find the geos package, geos-config or the geos library, either you are missing the dependency or you should provide the GEOS_PREFIX hint")
      endif()

      if(GEOS_C_LIBRARY)
	get_filename_component(GEOS_INSTALL_PREFIX ${GEOS_C_LIBRARY} DIRECTORY)
	set(GEOS_INSTALL_PREFIX "${GEOS_INSTALL_PREFIX}/..")
	get_filename_component(GEOS_INSTALL_PREFIX ${GEOS_INSTALL_PREFIX} ABSOLUTE)
	message("-- Found GEOS_C library: ${GEOS_C_LIBRARY}")
      else()
	message(FATAL_ERROR "Could not find the geos_c package, geos-config or the geos_c library, either you are missing the dependency or you should provide the GEOS_PREFIX hint")
      endif()

    endif()
    # add_library(GEOS::geos INTERFACE IMPORTED)
    add_library(GEOS::GEOS INTERFACE IMPORTED)
    set_target_properties(GEOS::GEOS PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES ${GEOS_INSTALL_PREFIX}/include
      INTERFACE_LINK_LIBRARIES ${GEOS_LIBRARY}
      INTERFACE_LINK_LIBRARIES ${GEOS_C_LIBRARY}
      )
  else()
  endif()

else()
endif()

message("-- Found GEOS library: ${GEOS_LIBRARY}")
message("-- Found GEOS_C library: ${GEOS_C_LIBRARY}")

