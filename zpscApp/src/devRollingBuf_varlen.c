#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#include <aSubRecord.h>
#include <registryFunction.h>
#include <epicsExport.h>
#include <epicsMutex.h>
#include <epicsTypes.h>


typedef struct {
    float *buffer;
    int bufidx;
    int size;
    epicsMutexId lock;
} RollingBufState;

/*
static void freeRollingBuf(RollingBufState *state) {
    if (state) {
        if (state->buffer) free(state->buffer);
        if (state->lock) epicsMutexDestroy(state->lock);
        free(state);
    }
}
*/

long rollingBufInit_varlen(aSubRecord *prec) {
    int size = prec->nova;
    if (size <= 0) return -1;

    RollingBufState *state = calloc(1, sizeof(RollingBufState));
    if (!state) return -1;

    state->buffer = calloc(size, sizeof(float));
    if (!state->buffer) {
        free(state);
        return -1;
    }

    state->lock = epicsMutexCreate();
    if (!state->lock) {
        free(state->buffer);
        free(state);
        return -1;
    }

    state->size = size;
    state->bufidx = 0;
    prec->dpvt = state;

    return 0;
}

long rollingBufProcess_varlen(aSubRecord *prec) {
    float *in = (float *)prec->a;
    //float *len = (float *)prec->b;
    
    int length = *(int *)prec->b;      // INPB data
    
    //printf("Len=%d\n",length);
    
    float *out = (float *)prec->vala;

    if (!in || !out) return -1;

    RollingBufState *state = (RollingBufState *)prec->dpvt;
    if (!state) {
        if (rollingBufInit_varlen(prec) != 0) return -1;
        state = (RollingBufState *)prec->dpvt;
    }

    epicsMutexLock(state->lock);

    int size = state->size;
    int idx = state->bufidx;

    // Store new value (assume scalar input)
    state->buffer[idx] = *in;
    idx = (idx + 1) % size;
    state->bufidx = idx;

    // Get desired output length from VALB (linked to an ai PV)
    if (!prec->valb) {
      printf("VALB is NULL — likely due to bad INPB link or FTB type\n");
    }

    //int length = 100;
    //double dlength = *(double *)prec->valb;
    //int length = (int)dlength;  // cast safely to int

    
    //int length = *(epicsInt32 *)prec->valb;
    //length = 100;
    //printf("Length = %d\n",length);
    //printf("VALB pointer: %p, value: %f\n", prec->valb, *(double *)prec->valb);



    if (length > size) length = size;
    if (length < 1) length = 1;

    // Copy last 'length' samples in chronological order
    int start = (idx - length + size) % size;

    for (int i = 0; i < length; ++i) {
        int j = (start + i) % size;
        out[i] = state->buffer[j];
    }

    prec->neva = length;

    epicsMutexUnlock(state->lock);

    return 0;
}




/*
long rollingBufDel(aSubRecord *prec) {
    if (prec->dpvt) {
        freeRollingBuf((RollingBufState *)prec->dpvt);
        prec->dpvt = NULL;
    }
    return 0;
}
*/

epicsRegisterFunction(rollingBufInit_varlen);
epicsRegisterFunction(rollingBufProcess_varlen);
//epicsRegisterFunction(rollingBufDel);




