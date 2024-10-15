#include "raylib.h"
#include "stb_truetype.h"
#include <stdio.h>
#include <stdlib.h>

typedef struct CodepointRange
{
    int start;
    int end;
} CodepointRange;

typedef struct CodepointInfo
{
    CodepointRange *range;
    int rangeSize;
    int currentRangIndex;
    int currentCodepoint;
    int *codepoints;
    int size;
    int currentIndex;
} CodepointInfo;

static void resetCodepointInfo(CodepointInfo *info)
{
    info->currentRangIndex = 0;
    if (0 == info->rangeSize)
    {
        info->currentRangIndex = -1;
    }
    info->currentCodepoint = 0;

    info->currentIndex = 0;
}

static int nextCodepoint(CodepointInfo *info)
{
    if (-1 == info->currentRangIndex)
    {
        if (info->currentIndex < info->size)
        {
            return info->codepoints[info->currentIndex++];
        }
        else
        {
            return -1;
        }
    }
    else
    {
        CodepointRange codepointRange = info->range[info->currentRangIndex];
        if (0 == info->currentCodepoint)
        {
            info->currentCodepoint = codepointRange.start;
        }

        int tmp = info->currentCodepoint++;
        if (info->currentCodepoint > codepointRange.end)
        {
            info->currentCodepoint = 0;
            info->currentRangIndex++;
        }

        if (info->currentRangIndex >= info->rangeSize)
        {
            info->currentRangIndex = -1;
        }

        return tmp;
    }
}

// Load data from file into a buffer
static unsigned char *LoadFileData(const char *fileName, int *dataSize)
{
    unsigned char *data = NULL;
    *dataSize = 0;

    if (fileName != NULL)
    {
        FILE *file = fopen(fileName, "rb");

        if (file != NULL)
        {
            // WARNING: On binary streams SEEK_END could not be found,
            // using fseek() and ftell() could not work in some (rare) cases
            fseek(file, 0, SEEK_END);
            int size = ftell(file);
            fseek(file, 0, SEEK_SET);

            if (size > 0)
            {
                data = (unsigned char *)RL_MALLOC(size * sizeof(unsigned char));

                // NOTE: fread() returns number of read elements instead of bytes, so we read [1 byte, size elements]
                unsigned int count = (unsigned int)fread(data, sizeof(unsigned char), size, file);
                *dataSize = count;

                if (count != size)
                    TRACELOG(LOG_WARNING, "FILEIO: [%s] File partially loaded", fileName);
                else
                    TRACELOG(LOG_INFO, "FILEIO: [%s] File loaded successfully", fileName);
            }
            else
                TRACELOG(LOG_WARNING, "FILEIO: [%s] Failed to read file", fileName);

            fclose(file);
        }
        else
            TRACELOG(LOG_WARNING, "FILEIO: [%s] Failed to open file", fileName);
    }
    else
        TRACELOG(LOG_WARNING, "FILEIO: File name provided is not valid");

    return data;
}

int main(int argc, char const *argv[])
{
    int dataSize;
    unsigned char *fontData = LoadFileData("wenquanyi_dengkuan.ttf", &dataSize);
    stbtt_fontinfo fontInfo = {0};
    stbtt_InitFont(&fontInfo, (unsigned char *)fontData, 0);

    printf("%d\n", fontInfo.numGlyphs);
    return 0;
}
