# This module defines the following variables:
#
# ::
#
#   TensorRT_INCLUDE_DIRS
#   TensorRT_LIBRARIES
#   TensorRT_FOUND
#
# ::
#
#   TensorRT_VERSION_STRING - version (x.y.z)
#   TensorRT_VERSION_MAJOR  - major version (x)
#   TensorRT_VERSION_MINOR  - minor version (y)
#   TensorRT_VERSION_PATCH  - patch version (z)
#
# Hints
# ^^^^^
# A user may set ``TensorRT_DIR`` to an installation root to tell this module where to look.
#

# User-overridable cache variables
set(TensorRT_INCLUDE_DIR "" CACHE PATH "Path to TensorRT include directory")
set(TensorRT_LIBRARY "" CACHE FILEPATH "Path to TensorRT nvinfer library")
set(TensorRT_NVONNXPARSER_LIBRARY "" CACHE FILEPATH "Path to TensorRT nvonnxparser library")
set(TensorRT_NVPARSERS_LIBRARY "" CACHE FILEPATH "Path to TensorRT nvparsers library")

set(_TensorRT_SEARCHES)
if(TensorRT_DIR)
    set(_TensorRT_SEARCH_ROOT PATHS ${TensorRT_DIR} NO_DEFAULT_PATH)
    list(APPEND _TensorRT_SEARCHES _TensorRT_SEARCH_ROOT)
endif()
set(_TensorRT_SEARCH_NORMAL PATHS "/usr" "/usr/local")
list(APPEND _TensorRT_SEARCHES _TensorRT_SEARCH_NORMAL)
if(CMAKE_PREFIX_PATH)
    foreach(prefix ${CMAKE_PREFIX_PATH})
        list(APPEND _TensorRT_SEARCHES "PATHS ${prefix}")
    endforeach()
endif()

foreach(search ${_TensorRT_SEARCHES})
    find_path(TensorRT_INCLUDE_DIR NAMES NvInfer.h ${${search}} PATH_SUFFIXES include)
    find_library(TensorRT_LIBRARY NAMES nvinfer ${${search}} PATH_SUFFIXES lib lib64)
    find_library(TensorRT_NVONNXPARSER_LIBRARY NAMES nvonnxparser ${${search}} PATH_SUFFIXES lib lib64)
    find_library(TensorRT_NVPARSERS_LIBRARY NAMES nvparsers ${${search}} PATH_SUFFIXES lib lib64)
endforeach()

mark_as_advanced(TensorRT_INCLUDE_DIR TensorRT_LIBRARY TensorRT_NVONNXPARSER_LIBRARY TensorRT_NVPARSERS_LIBRARY)

if(TensorRT_INCLUDE_DIR AND EXISTS "${TensorRT_INCLUDE_DIR}/NvInfer.h")
    file(STRINGS "${TensorRT_INCLUDE_DIR}/NvInfer.h" TensorRT_MAJOR REGEX "^#define NV_TENSORRT_MAJOR[ \t]+[0-9]+")
    file(STRINGS "${TensorRT_INCLUDE_DIR}/NvInfer.h" TensorRT_MINOR REGEX "^#define NV_TENSORRT_MINOR[ \t]+[0-9]+")
    file(STRINGS "${TensorRT_INCLUDE_DIR}/NvInfer.h" TensorRT_PATCH REGEX "^#define NV_TENSORRT_PATCH[ \t]+[0-9]+")
    string(REGEX REPLACE "^#define NV_TENSORRT_MAJOR[ \t]+([0-9]+).*$" "\\1" TensorRT_VERSION_MAJOR "${TensorRT_MAJOR}")
    string(REGEX REPLACE "^#define NV_TENSORRT_MINOR[ \t]+([0-9]+).*$" "\\1" TensorRT_VERSION_MINOR "${TensorRT_MINOR}")
    string(REGEX REPLACE "^#define NV_TENSORRT_PATCH[ \t]+([0-9]+).*$" "\\1" TensorRT_VERSION_PATCH "${TensorRT_PATCH}")
    set(TensorRT_VERSION_STRING "${TensorRT_VERSION_MAJOR}.${TensorRT_VERSION_MINOR}.${TensorRT_VERSION_PATCH}")
endif()

include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(TensorRT
    REQUIRED_VARS TensorRT_LIBRARY TensorRT_INCLUDE_DIR
    VERSION_VAR TensorRT_VERSION_STRING
)

if(TensorRT_FOUND)
    set(TensorRT_INCLUDE_DIRS ${TensorRT_INCLUDE_DIR})
    set(TensorRT_LIBRARIES ${TensorRT_LIBRARY} ${TensorRT_NVONNXPARSER_LIBRARY} ${TensorRT_NVPARSERS_LIBRARY})
    if(NOT TARGET TensorRT::TensorRT)
        add_library(TensorRT::TensorRT UNKNOWN IMPORTED)
        set_target_properties(TensorRT::TensorRT PROPERTIES
            INTERFACE_INCLUDE_DIRECTORIES "${TensorRT_INCLUDE_DIRS}"
            IMPORTED_LOCATION "${TensorRT_LIBRARY}"
        )
    endif()
endif()
