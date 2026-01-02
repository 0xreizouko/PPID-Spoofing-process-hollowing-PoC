if (EXISTS "${MANIFEST_FILE}")
    message(STATUS "Build-time: embedding manifest ${MANIFEST_FILE}")
    execute_process(
        COMMAND mt.exe
            -nologo
            -manifest "${MANIFEST_FILE}"
            -outputresource:${TARGET_EXE};#1
        RESULT_VARIABLE res
    )
    if (NOT res EQUAL 0)
        message(FATAL_ERROR "mt.exe failed")
    endif()
endif()
