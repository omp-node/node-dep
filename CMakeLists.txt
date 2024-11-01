cmake_minimum_required(VERSION 3.19)
project(node-lib LANGUAGES C CXX VERSION 0.0.1)

include(cmake/DepsDownload.cmake)

function(GroupSourcesByFolder target)
    set(SOURCE_GROUP_DELIMITER "/")
    set(last_dir "")
    set(files "")

    get_target_property(sources ${target} SOURCES)

    foreach(file ${sources})
        file(RELATIVE_PATH relative_file "${CMAKE_CURRENT_SOURCE_DIR}" ${file})
        get_filename_component(dir "${relative_file}" PATH)
        if(NOT "${dir}" STREQUAL "${last_dir}")
            if(files)
                source_group("${last_dir}" FILES ${files})
            endif()
            set(files "")
        endif()
        set(files ${files} ${file})
        set(last_dir "${dir}")
    endforeach()

    if(files)
        source_group("${last_dir}" FILES ${files})
    endif()
endfunction()

include(FetchContent)

DownloadDeps()

add_library(${PROJECT_NAME} INTERFACE)

target_include_directories(${PROJECT_NAME} INTERFACE "include/" "include/node/")

file(GLOB_RECURSE omp_lib_source_list "*.hpp" "*.h")

set_property(TARGET ${PROJECT_NAME} PROPERTY SOURCES ${omp_lib_source_list})

GroupSourcesByFolder(${PROJECT_NAME})
