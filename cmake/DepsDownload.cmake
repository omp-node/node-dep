include(CheckTypeSize)
check_type_size("void*" SIZEOF_VOID_P BUILTIN_TYPES_ONLY)

function(DownloadFile name path urlpath)
    if(NOT EXISTS "${path}/${name}")
        message("Downloading ${name}...")

        set(__download_url "${__deps_url_base_path}/${urlpath}/${name}")

        file(DOWNLOAD "${__download_url}" "${path}/${name}"
            STATUS DOWNLOAD_STATUS
        )
        # Separate the returned status code, and error message.
        list(GET DOWNLOAD_STATUS 0 STATUS_CODE)
        list(GET DOWNLOAD_STATUS 1 ERROR_MESSAGE)
        # Check if download was successful.
        if(${STATUS_CODE} EQUAL 0)
            message(STATUS "Download completed successfully!")
        else()
            # Exit CMake if the download failed, printing the error message.
            message(FATAL_ERROR "Error [${STATUS_CODE}] occurred during download '${__download_url}' : ${ERROR_MESSAGE}")
        endif()
    endif()
endfunction()

function(GetOS os)
    if(WIN32)
        set(__os_name "win")
    elseif(UNIX)
        set(__os_name "linux")
    endif()

    set(${os} ${__os_name} PARENT_SCOPE)
endfunction()

# Set this to false, when using a custom nodejs build for testing
set(__deps_check_enabled true)

function(DownloadDeps)
    set(__base_path "${PROJECT_SOURCE_DIR}/lib")

    GetOS(__deps_os_path_name)
    set(__deps_url_base_path "https://assets.open.mp/node/lib/${__deps_os_path_name}")

    if(__deps_check_enabled)
        if(WIN32)
            message("Checking windows binaries...")
            if(SIZEOF_VOID_P STREQUAL "4")
                DownloadFile("libnode.lib" "${__base_path}/${__deps_os_path_name}/x86/Release" "x86/Release")
                DownloadFile("libnode.dll" "${__base_path}/${__deps_os_path_name}/x86/Release" "x86/Release")
                DownloadFile("libnode.lib" "${__base_path}/${__deps_os_path_name}/x86/Debug" "x86/Debug")
                DownloadFile("libnode.dll" "${__base_path}/${__deps_os_path_name}/x86/Debug" "x86/Debug")

                file(COPY "${__base_path}/${__deps_os_path_name}/x86/Release/libnode.lib" DESTINATION "${__base_path}/${__deps_os_path_name}/x86/RelWithDebInfo")
                file(COPY "${__base_path}/${__deps_os_path_name}/x86/Release/libnode.dll" DESTINATION "${__base_path}/${__deps_os_path_name}/x86/RelWithDebInfo")

                file(COPY "${__base_path}/${__deps_os_path_name}/x86/Release/libnode.lib" DESTINATION "${__base_path}/${__deps_os_path_name}/x86/MinSizeRel")
                file(COPY "${__base_path}/${__deps_os_path_name}/x86/Release/libnode.dll" DESTINATION "${__base_path}/${__deps_os_path_name}/x86/MinSizeRel")
            else()
                DownloadFile("libnode.lib" "${__base_path}/${__deps_os_path_name}/x64/Release" "x64/Release")
                DownloadFile("libnode.dll" "${__base_path}/${__deps_os_path_name}/x64/Release" "x64/Release")
                DownloadFile("libnode.lib" "${__base_path}/${__deps_os_path_name}/x64/Debug" "x64/Debug")
                DownloadFile("libnode.dll" "${__base_path}/${__deps_os_path_name}/x64/Debug" "x64/Debug")

                file(COPY "${__base_path}/${__deps_os_path_name}/x64/Release/libnode.lib" DESTINATION "${__base_path}/${__deps_os_path_name}/x64/RelWithDebInfo")
                file(COPY "${__base_path}/${__deps_os_path_name}/x64/Release/libnode.dll" DESTINATION "${__base_path}/${__deps_os_path_name}/x64/RelWithDebInfo")

                file(COPY "${__base_path}/${__deps_os_path_name}/x64/Release/libnode.lib" DESTINATION "${__base_path}/${__deps_os_path_name}/x64/MinSizeRel")
                file(COPY "${__base_path}/${__deps_os_path_name}/x64/Release/libnode.dll" DESTINATION "${__base_path}/${__deps_os_path_name}/x64/MinSizeRel")
            endif()
        elseif(UNIX)
            message("Checking binaries...")

            if(SIZEOF_VOID_P STREQUAL "4")
                DownloadFile("libnode.so.108" "${__base_path}/${__deps_os_path_name}/x86" "x86")
            else()
                DownloadFile("libnode.so.108" "${__base_path}/${__deps_os_path_name}/x64" "x64")
            endif()
        endif()

        if(__deps_current_version)
            message("NodeJS deps version: ${__deps_current_version}")
        endif()
    endif()
endfunction()
