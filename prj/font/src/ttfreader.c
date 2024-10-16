#include <stdio.h>
#include <stdlib.h>

typedef struct
{
    int start;
    int end;
} CodepointRange;

typedef struct
{
    CodepointRange *range;
    int rangeSize;
    int *codepoints;
    int size;
} CodepointInfo;

static int *fetchCodepoints(CodepointInfo *info, int *size)
{
    *size = info->size;
    for (int i = 0; i < info->rangeSize; i++)
    {
        *size += info->range[i].end - info->range[i].start + 1;
    }

    int *codepoints = (int *)malloc(sizeof(int) * *size);

    int counter = 0;
    for (int i = 0; i < info->rangeSize; i++)
    {
        CodepointRange range = info->range[i];
        for (int j = range.start; j <= range.end; j++)
        {
            codepoints[counter++] = j;
        }
    }

    for (int i = 0; i < info->size; i++)
    {
        codepoints[counter++] = info->codepoints[i];
    }

    return codepoints;
}

int main(int argc, char const *argv[])
{
    CodepointInfo info;

    int tmp[4] = {36, 31, 37, 41};
    info.codepoints = tmp;
    info.size = 4;

    CodepointRange rangTmp[2] = {{20013, 20018}, {20320, 20330}};
    info.range = rangTmp;
    info.rangeSize = 2;

    int size;
    int *codepoints = fetchCodepoints(&info, &size);

    printf("%d\n", size);

    for (int i = 0; i < size; i++)
    {
        printf("%d\n", codepoints[i]);
    }
    return 0;
}
