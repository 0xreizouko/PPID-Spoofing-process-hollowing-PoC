
if (NOT DEFINED NAME)
    message(FATAL_ERROR
        "Usage:\n"
        "  cmake -DNAME=<project_name> [-DGUI=ON] [-DSINGLE=ON] -P cmake/new_project.cmake"
    )
endif()

set(PROJECT_NAME ${NAME})
set(IS_GUI OFF)
set(IS_SINGLE OFF)

if (DEFINED GUI AND GUI)
    set(IS_GUI ON)
endif()

if (DEFINED SINGLE AND SINGLE)
    set(IS_SINGLE ON)
endif()

# Template selection
if (IS_GUI)
    set(CMAKE_TEMPLATE "CMakeLists.txt.gui.in")
    set(MAIN_TEMPLATE "main.gui.cpp.in")
else()
    set(CMAKE_TEMPLATE "CMakeLists.txt.cli.in")
    set(MAIN_TEMPLATE "main.cli.cpp.in")
endif()

# Paths
if (IS_SINGLE)
    set(PROJECT_DIR "${CMAKE_CURRENT_LIST_DIR}/..")
    set(SRC_DIR "${PROJECT_DIR}/src")
else()
    set(PROJECT_DIR "${CMAKE_CURRENT_LIST_DIR}/../${PROJECT_NAME}")
    set(SRC_DIR "${PROJECT_DIR}/src")
endif()

if (EXISTS "${SRC_DIR}")
    message(FATAL_ERROR "Target directory already exists")
endif()

message(STATUS "Creating project: ${PROJECT_NAME}")
message(STATUS "Mode: $<$<BOOL:${IS_SINGLE}>:single-project>$<$<NOT:$<BOOL:${IS_SINGLE}>>:multi-project>")

file(MAKE_DIRECTORY "${SRC_DIR}")

# Generate files
configure_file(
    "${CMAKE_CURRENT_LIST_DIR}/templates/${MAIN_TEMPLATE}"
    "${SRC_DIR}/main.cpp"
    @ONLY
)

# CMakeLists handling
if (IS_SINGLE)
    configure_file(
        "${CMAKE_CURRENT_LIST_DIR}/templates/${CMAKE_TEMPLATE}"
        "${PROJECT_DIR}/CMakeLists.txt"
        @ONLY
    )
else()
    configure_file(
        "${CMAKE_CURRENT_LIST_DIR}/templates/${CMAKE_TEMPLATE}"
        "${PROJECT_DIR}/CMakeLists.txt"
        @ONLY
    )

    # Register project in root CMakeLists.txt
    set(ROOT_CMAKELISTS "${CMAKE_CURRENT_LIST_DIR}/../CMakeLists.txt")

    if (EXISTS "${ROOT_CMAKELISTS}")
        file(READ "${ROOT_CMAKELISTS}" ROOT_CONTENTS)
        set(ADD_LINE "add_subdirectory(${PROJECT_NAME})")
        string(FIND "${ROOT_CONTENTS}" "${ADD_LINE}" FOUND_INDEX)

        if (FOUND_INDEX EQUAL -1)
            file(APPEND "${ROOT_CMAKELISTS}" "\n${ADD_LINE}\n")
            message(STATUS "Registered project in root CMakeLists.txt")
        endif()
    endif()
endif()

message(STATUS "Project ready")

