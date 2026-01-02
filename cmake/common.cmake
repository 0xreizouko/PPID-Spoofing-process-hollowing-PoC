set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED ON)

if (MSVC)
    add_compile_definitions(
        _CRT_SECURE_NO_WARNINGS
        UNICODE
        _UNICODE
    )
endif()
