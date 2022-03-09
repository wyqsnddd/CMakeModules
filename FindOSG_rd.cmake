# Locate gdal
# This module defines
# OSG_LIBRARY
# OSG_FOUND, if false, do not try to link to gdal
# OSG_INCLUDE_DIR, where to find the headers

# $OSG_DIR is an environment variable 

set(OSG_DIR /usr/local/)

FIND_PATH(OSG_INCLUDE_DIR osg/Node
    ${OSG_DIR}/include
    $ENV{OSG_DIR}/include
    $ENV{OSG_DIR}
    $ENV{OSGDIR}/include
    $ENV{OSGDIR}
    $ENV{OSG_ROOT}/include
    NO_DEFAULT_PATH
)

FIND_PATH(OSG_INCLUDE_DIR osg/Node)

MACRO(FIND_OSG_LIBRARY MYLIBRARY MYLIBRARYNAME)

    FIND_LIBRARY("${MYLIBRARY}_DEBUG"
        NAMES "${MYLIBRARYNAME}${CMAKE_DEBUG_POSTFIX}"
        PATHS
        ${OSG_DIR}/lib/Debug
	/usr/local/lib64/
        ${OSG_DIR}/lib64/Debug
        ${OSG_DIR}/lib
        ${OSG_DIR}/lib64
        $ENV{OSG_DIR}/lib/debug
        $ENV{OSG_DIR}/lib64/debug
        $ENV{OSG_DIR}/lib
        $ENV{OSG_DIR}/lib64
        $ENV{OSG_DIR}
        $ENV{OSGDIR}/lib
        $ENV{OSGDIR}/lib64
        $ENV{OSGDIR}
        $ENV{OSG_ROOT}/lib
        $ENV{OSG_ROOT}/lib64
        NO_DEFAULT_PATH
    )

    FIND_LIBRARY("${MYLIBRARY}_DEBUG"
        NAMES "${MYLIBRARYNAME}${CMAKE_DEBUG_POSTFIX}"
        PATHS
        ~/Library/Frameworks
        /Library/Frameworks
        /usr/local/lib
	/usr/local/lib64
        /usr/lib
        /usr/lib64
        /sw/lib
        /opt/local/lib
        /opt/csw/lib
        /opt/lib
        [HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Session\ Manager\\Environment;OSG_ROOT]/lib
        /usr/freeware/lib64
    )

    FIND_LIBRARY(${MYLIBRARY}
        NAMES "${MYLIBRARYNAME}${CMAKE_RELEASE_POSTFIX}"
        PATHS
        ${OSG_DIR}/lib/Release
        ${OSG_DIR}/lib64/Release
        ${OSG_DIR}/lib
        ${OSG_DIR}/lib64
	/usr/local/lib64/
        $ENV{OSG_DIR}/lib/Release
        $ENV{OSG_DIR}/lib64/Release
        $ENV{OSG_DIR}/lib
        $ENV{OSG_DIR}/lib64
        $ENV{OSG_DIR}
        $ENV{OSGDIR}/lib
        $ENV{OSGDIR}/lib64
        $ENV{OSGDIR}
        $ENV{OSG_ROOT}/lib
        $ENV{OSG_ROOT}/lib64
        NO_DEFAULT_PATH
    )

    FIND_LIBRARY(${MYLIBRARY}
        NAMES "${MYLIBRARYNAME}${CMAKE_RELEASE_POSTFIX}"
        PATHS
        ~/Library/Frameworks
        /Library/Frameworks
        /usr/local/lib
        /usr/local/lib64
	# /usr/lib/x86_64-linux-gnu/
        /usr/lib
        /usr/lib64
        /sw/lib
        /opt/local/lib
        /opt/csw/lib
        /opt/lib
        [HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Session\ Manager\\Environment;OSG_ROOT]/lib
        /usr/freeware/lib64
    )

    IF( NOT ${MYLIBRARY}_DEBUG)
        IF(MYLIBRARY)
            SET(${MYLIBRARY}_DEBUG ${MYLIBRARY})
        ENDIF(MYLIBRARY)
    ELSE()
        IF( NOT MYLIBRARY )
            SET(${MYLIBRARY} ${${MYLIBRARY}_DEBUG} )
        ENDIF(NOT MYLIBRARY)

    ENDIF( NOT ${MYLIBRARY}_DEBUG )

ENDMACRO(FIND_OSG_LIBRARY LIBRARY LIBRARYNAME)

FIND_OSG_LIBRARY(OSG_LIBRARY osgrd)
FIND_OSG_LIBRARY(OSGGA_LIBRARY osgGArd)
FIND_OSG_LIBRARY(OSGUTIL_LIBRARY osgUtilrd)
FIND_OSG_LIBRARY(OSGDB_LIBRARY osgDBrd)
FIND_OSG_LIBRARY(OSGTEXT_LIBRARY osgTextrd)
FIND_OSG_LIBRARY(OSGWIDGET_LIBRARY osgWidgetrd)
FIND_OSG_LIBRARY(OSGTERRAIN_LIBRARY osgTerrainrd)
FIND_OSG_LIBRARY(OSGFX_LIBRARY osgFXrd)
FIND_OSG_LIBRARY(OSGVIEWER_LIBRARY osgViewerrd)
FIND_OSG_LIBRARY(OSGVOLUME_LIBRARY osgVolumerd)
FIND_OSG_LIBRARY(OSGMANIPULATOR_LIBRARY osgManipulatorrd)
FIND_OSG_LIBRARY(OSGANIMATION_LIBRARY osgAnimationrd)
FIND_OSG_LIBRARY(OSGPARTICLE_LIBRARY osgParticlerd)
FIND_OSG_LIBRARY(OSGSHADOW_LIBRARY osgShadowrd)
FIND_OSG_LIBRARY(OSGPRESENTATION_LIBRARY osgPresentationrd)
FIND_OSG_LIBRARY(OSGSIM_LIBRARY osgSimrd)
FIND_OSG_LIBRARY(OPENTHREADS_LIBRARY OpenThreadsrd)


SET(OSG_FOUND "NO")
IF(OSG_LIBRARY AND OSG_INCLUDE_DIR)
    SET(OSG_FOUND "YES")
ENDIF(OSG_LIBRARY AND OSG_INCLUDE_DIR)
