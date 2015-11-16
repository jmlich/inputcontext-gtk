find_package(PkgConfig)
pkg_check_modules(PC_GTK3 gtk+-3.0 QUIET)

set(GTK3_DEFINITIONS ${PC_GTK3_CFLAGS_OTHER})
set(GTK3_INCLUDE_DIRS ${PC_GTK3_INCLUDE_DIRS})

foreach(COMP ${PC_GTK3_LIBRARIES})
    find_library(GTK3_${COMP} NAMES ${COMP} HINTS ${PC_GTK3_LIBRARY_DIRS})
    list(APPEND GTK3_LIBRARIES ${GTK3_${COMP}})
endforeach()

execute_process(COMMAND ${PKG_CONFIG_EXECUTABLE} --variable gtk_binary_version gtk+-3.0
        OUTPUT_VARIABLE GTK3_BINARY_VERSION)

string(REGEX REPLACE "[\r\n]" " " GTK3_BINARY_VERSION "${GTK3_BINARY_VERSION}")
string(REGEX REPLACE " +$" "" GTK3_BINARY_VERSION "${GTK3_BINARY_VERSION}")

# handle the QUIETLY and REQUIRED arguments and set GTK3_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(GTK3 DEFAULT_MSG GTK3_LIBRARIES GTK3_INCLUDE_DIRS)

mark_as_advanced(GTK3_DEFINITIONS GTK3_INCLUDE_DIRS GTK3_LIBRARIES GTK3_BINARY_VERSION)

if(PC_GTK3_FOUND AND NOT TARGET Gtk3::Gtk)
    add_library(Gtk3::Gtk INTERFACE IMPORTED)

    set_property(TARGET Gtk3::Gtk PROPERTY INTERFACE_COMPILE_OPTIONS "-pthread")
    set_property(TARGET Gtk3::Gtk PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${GTK3_INCLUDE_DIRS})
    set_property(TARGET Gtk3::Gtk PROPERTY INTERFACE_LINK_LIBRARIES ${GTK3_LIBRARIES})
endif()