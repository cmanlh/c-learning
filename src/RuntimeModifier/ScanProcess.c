#include <windows.h>
#include <stdio.h>
#include <psapi.h>

void printProcessNameAndID(DWORD processID)
{
    TCHAR szProcessName[MAX_PATH] = TEXT("<unknown>");

    // Get a handle to the process.
    HANDLE hProcess = OpenProcess(PROCESS_QUERY_INFORMATION |
                                      PROCESS_VM_READ,
                                  FALSE, processID);
                                  
    // Get the process name.
    if (NULL != hProcess)
    {
        HMODULE hMod;
        DWORD cbNeeded;

        if (EnumProcessModules(hProcess, &hMod, sizeof(hMod),
                               &cbNeeded))
        {
            GetModuleBaseName(hProcess, hMod, szProcessName,
                              sizeof(szProcessName) / sizeof(TCHAR));
        }
    }

    // Print the process name and identifier.
    printf("%s  (PID: %u)\n", szProcessName, processID);

    // Release the handle to the process.
    CloseHandle(hProcess);
}

int main(int argc, char const *argv[])
{
    DWORD pids[1024], cbNeeded;

    if (!EnumProcesses(pids, sizeof(pids), &cbNeeded))
    {
        return 1;
    }

    DWORD pidQuantity = cbNeeded / sizeof(DWORD);

    for (int i = 0; i < pidQuantity; i++)
    {
        if (pids[i] != 0)
        {
            printProcessNameAndID(pids[i]);
        }
    }
    return 0;
}
