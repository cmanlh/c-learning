#include <windows.h>
#include <stdio.h>
#include <processthreadsapi.h>
// #include <memoryapi.h>

void toNeBytes(__int32 value, byte *buffer)
{
    memcpy(buffer, &value, sizeof(value));
}

void fetchProcessMemory(DWORD processID, byte *buffer, size_t valueSize)
{
    // Get a handle to the process.
    HANDLE hProcess = OpenProcess(PROCESS_QUERY_INFORMATION |
                                      PROCESS_VM_READ,
                                  FALSE, processID);

    ULONG_PTR baseAddress = 0;
    MEMORY_BASIC_INFORMATION mbi;
    // Get the process name.
    if (NULL != hProcess)
    {
        while (1 == 1)
        {
            SIZE_T result = VirtualQueryEx(hProcess, (LPCVOID)baseAddress, &mbi, sizeof(mbi));
            if (result == 0)
            {
                break;
            }

            if (mbi.Protect == PAGE_READWRITE || mbi.Protect == PAGE_WRITECOPY || mbi.Protect == PAGE_EXECUTE_READWRITE || mbi.Protect == PAGE_EXECUTE_WRITECOPY)
                {
                    byte targetBuffer[mbi.RegionSize];
                    size_t realSize;
                    ReadProcessMemory(hProcess, (LPCVOID)baseAddress, targetBuffer, mbi.RegionSize, &realSize);

                    byte temp[valueSize];
                    boolean found = FALSE;
                    for (int i = 0; i < realSize; i += valueSize)
                    {
                        memcpy(temp, targetBuffer + i, 4);
                        if (memcmp(buffer, temp, valueSize) == 0)
                        {
                            printf("baseAddress == %d || ", baseAddress);
                            found = TRUE;
                            break;
                        }
                    }
                }
            baseAddress = (ULONG_PTR)mbi.BaseAddress + mbi.RegionSize;
            // The above sum in simpler terms is like moving from one room to the next in a house, where mbi.RegionSize tells you how big the room is, and adding it to mbi.BaseAddress gets you to the start of the next room.
        }
    }

    // Release the handle to the process.
    CloseHandle(hProcess);
}

int main(int argc, char const *argv[])
{
    size_t valueSize = 4;
    int value = 343;
    byte buffer[valueSize];
    toNeBytes(value, buffer);

    fetchProcessMemory(12912, buffer, valueSize);
    return 0;
}
