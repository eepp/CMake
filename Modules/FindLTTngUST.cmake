#.rst:
# FindLTTngUST
# ------------
#
# Try to find the `LTTng-UST <http://lttng.org/>`_ library.
#
# Once done, this will define:
#
# ``LTTNGUST_FOUND``
#   ``TRUE`` if system has LTTng-UST
# ``LTTNGUST_INCLUDE_DIR``
#   The LTTng-UST include directory
# ``LTTNGUST_LIBRARIES``
#   The libraries needed to use LTTng-UST
# ``LTTNGUST_VERSION_STRING``
#   The LTTng-UST version
# ``LTTNGUST_HAS_TRACEF``
#   ``TRUE`` if the ``tracef()`` API is available in the system's LTTng-UST
# ``LTTNGUST_HAS_TRACELOG``
#   ``TRUE`` if the ``tracelog()`` API is available in the system's LTTng-UST
#
#=============================================================================
# Copyright 2016 Kitware, Inc.
# Copyright 2016 Philippe Proulx <pproulx@efficios.com>
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distribute this file outside of CMake, substitute the full
#  License text for the above reference.)

find_path(LTTNGUST_INCLUDE_DIR NAMES lttng/tracepoint.h)
find_library(LTTNGUST_LIBRARIES NAMES lttng-ust)

if(LTTNGUST_INCLUDE_DIR)
    # find tracef() and tracelog() support
    set(LTTNGUST_HAS_TRACEF 0)
    set(LTTNGUST_HAS_TRACELOG 0)

    if(EXISTS "${LTTNGUST_INCLUDE_DIR}/lttng/tracef.h")
        set(LTTNGUST_HAS_TRACEF TRUE)
    endif()

    if(EXISTS "${LTTNGUST_INCLUDE_DIR}/lttng/tracelog.h")
        set(LTTNGUST_HAS_TRACELOG TRUE)
    endif()

    # get version
    set(lttngust_version_file "${LTTNGUST_INCLUDE_DIR}/lttng/ust-version.h")

    if(EXISTS "${lttngust_version_file}")
        file(STRINGS "${lttngust_version_file}" lttngust_version_major_string
             REGEX "^[\t ]*#define[\t ]+LTTNG_UST_MAJOR_VERSION[\t ]+[0-9]+[\t ]*$")
        file(STRINGS "${lttngust_version_file}" lttngust_version_minor_string
             REGEX "^[\t ]*#define[\t ]+LTTNG_UST_MINOR_VERSION[\t ]+[0-9]+[\t ]*$")
        file(STRINGS "${lttngust_version_file}" lttngust_version_patch_string
             REGEX "^[\t ]*#define[\t ]+LTTNG_UST_PATCHLEVEL_VERSION[\t ]+[0-9]+[\t ]*$")
        string(REGEX REPLACE ".*([0-9]+).*" "\\1"
               lttngust_v_major "${lttngust_version_major_string}")
        string(REGEX REPLACE ".*([0-9]+).*" "\\1"
               lttngust_v_minor "${lttngust_version_minor_string}")
        string(REGEX REPLACE ".*([0-9]+).*" "\\1"
               lttngust_v_patch "${lttngust_version_patch_string}")
        set(LTTNGUST_VERSION_STRING
            "${lttngust_v_major}.${lttngust_v_minor}.${lttngust_v_patch}")
        unset(lttngust_version_major_string)
        unset(lttngust_version_minor_string)
        unset(lttngust_version_patch_string)
        unset(lttngust_v_major)
        unset(lttngust_v_minor)
        unset(lttngust_v_patch)
    endif()

    unset(lttngust_version_file)
endif()

# handle the QUIETLY and REQUIRED arguments and set LTTNGUST_FOUND to
# TRUE if all listed variables are TRUE
include(${CMAKE_CURRENT_LIST_DIR}/FindPackageHandleStandardArgs.cmake)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(LTTngUST FOUND_VAR LTTNGUST_FOUND
                                  REQUIRED_VARS LTTNGUST_LIBRARIES
                                                LTTNGUST_INCLUDE_DIR
                                  VERSION_VAR LTTNGUST_VERSION_STRING)
mark_as_advanced(LTTNGUST_LIBRARIES LTTNGUST_INCLUDE_DIR)
