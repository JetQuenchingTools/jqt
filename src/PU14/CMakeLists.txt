set(MODULE_NAME pu14)
set(MODULE ${PROJECT_NAME}_${MODULE_NAME})
set(NAME_LIB ${MODULE})

file(GLOB SOURCES_LIB "*.cc")

add_library(${NAME_LIB} SHARED ${SOURCES_LIB})

install_targets_custom()
