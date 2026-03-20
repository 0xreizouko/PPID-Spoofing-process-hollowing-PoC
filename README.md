## Purpose
A simple PoC for an injection technique that uses PPID Spoofing to spawn a child process under a browser, then it performs process hollowing using the encrypted payload from resources.

### Note

- I tried to replicate the disassembly of [PMA's lab12-02](https://reizouko.me/posts/pma/lab-12-solution/#lab12-02) so some stuff might have better implementation options.
- I'm open to suggestions but still not sure if I will update this project.

### Video

https://github.com/user-attachments/assets/47697127-db33-4491-a442-cc2e34dc9be8

## Building code

configure the project

```sh
cmake -S . -B build
```

To build all projects.

```sh
cmake --build build 
```

To build a specific project

```sh
cmake --build build --target <project_name>
```

By default the project will be built using Debug config, though it can be configured using --config parameter

```sh
cmake --build build --config Release --target <project_name>
```

You can always omit `project_name` to build all projects.

To run the project you will find the final exe at `build/<project_name>/<config>/` (e.g: `build/getVersion/Release`). 


# References

- [Concealed Code Execution](https://www.huntandhackett.com/blog/concealed-code-execution-techniques-and-detection)
- [iredteam - Process Hollowing and Portable Executable Relocations](https://www.ired.team/offensive-security/code-injection-process-injection/process-hollowing-and-pe-image-relocations)
- [iredteam - PPID Spoofing](https://www.ired.team/offensive-security/defense-evasion/parent-process-id-ppid-spoofing)
- [allthingsida - Understanding PE+ file format](https://youtube.com/playlist?list=PLL6vJ4QgqQGEBLuPTgmPqxX5pFqaoc-8u)
- [msdn - PE Format](https://learn.microsoft.com/en-us/windows/win32/debug/pe-format)

# Special Thanks
- [Menoufia Man](https://www.linkedin.com/in/0xf444/)
- [GG](https://www.linkedin.com/in/ahm3dgg/)
