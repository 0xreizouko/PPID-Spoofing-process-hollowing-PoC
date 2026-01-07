#define BUILD_WINDOWS
#include<Windows.h>
#include<stdio.h>
#include<tlhelp32.h>
#include<shlwapi.h>
#include <Winternl.h>


#pragma comment(lib, "ntdll.lib")

typedef NTSTATUS (__stdcall *NT_OPEN_FILE)(OUT PHANDLE
FileHandle, IN ACCESS_MASK DesiredAccess, IN POBJECT_ATTRIBUTES
ObjectAttributes, OUT PIO_STATUS_BLOCK IoStatusBlock, IN ULONG
ShareAccess, IN ULONG OpenOptions);

extern "C" void __stdcall RtlGetVersion(OSVERSIONINFO*);

bool CheckIfBrowser(wchar_t* processName) {
      bool res = false;
      const wchar_t* browsers[] = {
            L"chrome.exe",
            L"msedge.exe",
            L"firefox.exe",
            L"opera.exe"
      };
      for(const wchar_t* browser : browsers) {
            if(wcscmp(browser, processName) == 0) res = true;
      }

      return res;
}

int main() {
      // Creates a snapshot of processes
      HANDLE hSnapshot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
      if(hSnapshot == INVALID_HANDLE_VALUE) {
            printf("[*] Failed to enumerate process");
            exit(EXIT_FAILURE);
      }

      PROCESSENTRY32 currentProcess = { sizeof(PROCESSENTRY32) };

      // Process32First(snapshot, [out] processStructure) -> PROCESSENTRY32

      printf("\t[Process name] \t[PID]\t[PPID] \n");
      
      if(!Process32First(hSnapshot, &currentProcess)) {
            printf("[*] Failed to read snapshot");
            CloseHandle(hSnapshot);
            exit(EXIT_FAILURE);
      }

      do {
      if(CheckIfBrowser(currentProcess.szExeFile)) {
            printf("%25S %8d %8d \n",
                        currentProcess.szExeFile, currentProcess.th32ProcessID, currentProcess.th32ParentProcessID);
            break;
       }
      } while(Process32Next(hSnapshot, &currentProcess));

      // OpenProcess to obtain a handle for NTCreateProcessEx
      HANDLE hProcess = OpenProcess(
        PROCESS_QUERY_INFORMATION | PROCESS_VM_READ,
        FALSE,                                     
        currentProcess.th32ProcessID                                  
    );

      // HANDLE hInjectedProcess = NtCreateProcessEx();

      return 0;
}
