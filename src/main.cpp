#define BUILD_WINDOWS

#include<Windows.h>
#include<stdio.h>
#include<tlhelp32.h>

#pragma comment(lib, "ntdll.lib")

extern "C" void __stdcall RtlGetVersion(OSVERSIONINFO*);


int main() {
      /// CreateToolHelp32Snapshot(dwflag, th32ProcessID) -> handle to snapshot 
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
        printf("%25S %8d %8d \n",
			currentProcess.szExeFile, currentProcess.th32ProcessID, currentProcess.th32ParentProcessID);
      } while(Process32Next(hSnapshot, &currentProcess));

      return 0;
}
