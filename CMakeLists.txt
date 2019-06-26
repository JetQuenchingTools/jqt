cmake_minimum_required(VERSION 3.14.2)

if(POLICY CMP0048)
  cmake_policy(SET CMP0048 NEW)
endif()

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
# list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules")
message(STATUS "CMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}")

project(jqt VERSION 0.1 LANGUAGES CXX)

### Require out-of-source builds
file(TO_CMAKE_PATH "${PROJECT_BINARY_DIR}/CMakeLists.txt" LOC_PATH)
if(EXISTS "${LOC_PATH}")
    message(FATAL_ERROR "No build in a source directory (or any directory with a CMakeLists.txt file). Please make a build subdirectory. Feel free to remove CMakeCache.txt and CMakeFiles.")
endif()

include(safeguards)
include(install_targets_custom)

message( STATUS "CMAKE_CURRENT_SOURCE_DIR is ${CMAKE_CURRENT_SOURCE_DIR}")
# include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include)

find_program ( FASTJETCONFIG fastjet-config )
message(STATUS "Using fjconfig at ${FASTJETCONFIG}")
if (EXISTS ${FASTJETCONFIG})
	execute_process ( COMMAND ${FASTJETCONFIG} --prefix WORKING_DIRECTORY /tmp OUTPUT_VARIABLE FASTJET_DIR OUTPUT_STRIP_TRAILING_WHITESPACE )
	execute_process ( COMMAND ${FASTJETCONFIG} --cxxflags WORKING_DIRECTORY /tmp OUTPUT_VARIABLE FASTJET_CXXFLAGS OUTPUT_STRIP_TRAILING_WHITESPACE )
	execute_process ( COMMAND ${FASTJETCONFIG} --libs --plugins WORKING_DIRECTORY /tmp OUTPUT_VARIABLE FASTJET_LIBS OUTPUT_STRIP_TRAILING_WHITESPACE )
	message( STATUS "FASTJET_DIR: ${FASTJET_DIR}")
	message( STATUS "FASTJET_CXXFLAGS: ${FASTJET_CXXFLAGS}")
	message( STATUS "FASTJET_LIBS: ${FASTJET_LIBS}")
	add_compile_options(${FASTJET_CXXFLAGS})
else()
	message(FATAL_ERROR "This really requires fastjet-config... - must be in your \$PATH")
endif()

find_program ( PYTHIA8CONFIG pythia8-config )
message(STATUS "Using pythia8-config at ${PYTHIA8CONFIG}")
if (EXISTS ${PYTHIA8CONFIG})
	execute_process ( COMMAND ${PYTHIA8CONFIG} --prefix WORKING_DIRECTORY /tmp OUTPUT_VARIABLE PYTHIA8_DIR OUTPUT_STRIP_TRAILING_WHITESPACE )
	execute_process ( COMMAND ${PYTHIA8CONFIG} --cxxflags WORKING_DIRECTORY /tmp OUTPUT_VARIABLE PYTHIA8_CXXFLAGS OUTPUT_STRIP_TRAILING_WHITESPACE )
	execute_process ( COMMAND ${PYTHIA8CONFIG} --ldflags WORKING_DIRECTORY /tmp OUTPUT_VARIABLE PYTHIA8_LDFLAGS OUTPUT_STRIP_TRAILING_WHITESPACE )
	message( STATUS "PYTHIA8_DIR: ${PYTHIA8_DIR}")
	message( STATUS "PYTHIA8_CXXFLAGS: ${PYTHIA8_CXXFLAGS}")
	message( STATUS "PYTHIA8_LDFLAGS: ${PYTHIA8_LDFLAGS}")
	add_compile_options(${PYTHIA8_CXXFLAGS})
else()
	message(FATAL_ERROR "Some of this requires pythia8-config... - must be in your \$PATH")
endif()

# do we need ROOT?
set( CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ROOTSYS}/etc/cmake ${ROOT_DIR}/etc/cmake)
find_package(ROOT REQUIRED EG)
if(DEFINED ROOT_USE_FILE)
  	include(${ROOT_USE_FILE})
else()
	include_directories(${ROOT_INCLUDE_DIRS})
endif()

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include)
link_libraries(${ROOT_LIBRARIES}
               ${FASTJET_LIBS} -lfastjetcontribfragile
               ${PYTHIA8_LDFLAGS}
               ${CMAKE_DL_LIBS} z)

set(BUILD_SHARED_LIBS ON)

# do we need boost?
# find_package(Boost REQUIRED COMPONENTS math_c99 log log_setup system filesystem thread)
# if (BOOST-NOTFOUND)
# 	message(SEND_ERROR "Boost or one of the components not found. Will not compile ${EXE_NAME}")
# else()
# 	set(Boost_NO_BOOST_CMAKE ON)
# 	set(Boost_USE_STATIC_LIBS OFF)
# 	set(Boost_USE_STATIC_RUNTIME OFF)
# 	include_directories(SYSTEM ${Boost_INCLUDE_DIRS})
# 	message( STATUS "BOOST_LIBRARIES: ${Boost_LIBRARYDIR} ${Boost_LIBRARIES}")
# 	link_libraries(Boost::filesystem Boost::thread Boost::log Boost::log_setup)
# 	add_definitions(-DBOOST_LOG_DYN_LINK -DBOOST_SYSTEM_NO_DEPRECATED)
# endif (BOOST-NOTFOUND)

# # do we need HEPMC?
# set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/Modules/")
# find_package(HepMC REQUIRED HepMC)
# if (HEPMC_FOUND)
# 	include_directories(${HEPMC_INCLUDE_DIRS})
# 	add_definitions(-DUSE_HEPMC)
# endif()

# do we need CGAL?
# find_package( CGAL QUIET COMPONENTS  )
# if ( CGAL_FOUND )
# 	include( ${CGAL_USE_FILE} )
# 	# set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CGAL_LIBRARY_DIRS}/cmake/CGAL/")
# 	link_directories( /usr/local/lib )
# 	include_directories( /usr/local/include )
# endif()

# do we need LHAPDF?
# find_package(LHAPDF)

# Layout build dir like install dir
if(UNIX)
	message(STATUS "Building on a unix system")
	set(CMAKE_MACOSX_RPATH 1)
	set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
	# for gmp installed with brew
	if (EXISTS /usr/local/include AND EXISTS /usr/local/lib)
		include_directories("/usr/local/include" SYSTEM)
		link_directories("/usr/local/lib")
		message(STATUS "Assuming that /usr/local has the stuff from homebrew ...")
	endif()
else()
	message(STATUS "Building on non-unix system - that's fine.")
endif()

add_subdirectory(src)

# FILE(GLOB files "${CMAKE_CURRENT_SOURCE_DIR}/../include/*.h")
# INSTALL(FILES ${files} DESTINATION include)

# make install and cpack
# include(install_target)
