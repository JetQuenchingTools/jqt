set(MODULE_NAME execs)
set(MODULE ${PROJECT_NAME}_${MODULE_NAME})

file(GLOB SOURCES_EXE "*.cc")

foreach (_src ${SOURCES_EXE})
	get_filename_component(NAME_EXE ${_src} NAME_WE)
	# string(REPLACE ".cc" "" NAME_EXE ${_src})
	message(STATUS "adding target ${NAME_EXE} with source ${_src}")
	add_executable(${NAME_EXE} ${_src})
	target_link_libraries(${NAME_EXE} ${PROJECT_NAME}_pu14)
	install_targets_custom()
endforeach()

