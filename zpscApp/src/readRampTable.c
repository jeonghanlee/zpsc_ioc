#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <epicsExport.h>
#include <registryFunction.h>
#include <aSubRecord.h>
#include <dbAccess.h>

#define MAX_BUFFER 4096  // Adjust as needed

static long readFileToWaveform(aSubRecord *prec) {
    // Inputs
    const char *path = (const char *)prec->a;
    const char *filename = (const char *)prec->b;

    // Output: waveform (we expect it to be of type CHAR)
    char *outBuffer = (char *)prec->vala;
    epicsUInt32 *outElements = (epicsUInt32 *)prec->nea;  // Number of elements in waveform

    if (!path || !filename || !outBuffer || !outElements) {
        printf("Missing input(s)\n");
        return -1;
    }

    // Build full path
    char fullPath[512];
    snprintf(fullPath, sizeof(fullPath), "%s/%s", path, filename);

    FILE *file = fopen(fullPath, "r");
    if (!file) {
        printf("Error: cannot open file %s\n", fullPath);
        return -1;
    }

    // Read file into buffer
    size_t bytesRead = fread(outBuffer, 1, MAX_BUFFER, file);
    fclose(file);

    if (bytesRead == 0) {
        printf("Warning: file %s is empty\n", fullPath);
        return -1;
    }

    // Set number of elements read
    *outElements = (epicsUInt32)bytesRead;

    // Null-terminate if space
    if (bytesRead < MAX_BUFFER) {
        outBuffer[bytesRead] = '\0';
    }

    return 0;
}

// Register function with EPICS
epicsRegisterFunction(readFileToWaveform);

