cmake_minimum_required(VERSION 3.24)
project(XXX)

if (NOT CMAKE_BUILD_TYPE)
	message("Setting CMAKE_BUILD_TYPE to Debug")
	set(CMAKE_BUILD_TYPE "Debug")
endif()

include(CheckIPOSupported)
check_ipo_supported(RESULT IPO_SUPPORTED)
if(IPO_SUPPORTED)
	set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)
endif()

set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall")
set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -Wextra -ggdb")

add_executable(${PROJECT_NAME} ${PROJECT_NAME}.c)
