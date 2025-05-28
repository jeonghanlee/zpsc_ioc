#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#include <aSubRecord.h>
#include <registryFunction.h>
#include <epicsExport.h>
#include <epicsMutex.h>

typedef struct {
    float *buffer;
    int bufidx;
    int size;
    epicsMutexId lock;
} RollingBufState;

static void freeRollingBuf(RollingBufState *state) {
    if (state) {
        if (state->buffer) free(state->buffer);
        if (state->lock) epicsMutexDestroy(state->lock);
        free(state);
    }
}

long rollingBufInit(aSubRecord *prec) {
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

long rollingBufProcess(aSubRecord *prec) {
    float *in = (float *)prec->a;
    float *out = (float *)prec->vala;

    if (!in || !out) return -1;

    RollingBufState *state = (RollingBufState *)prec->dpvt;
    if (!state) {
        if (rollingBufInit(prec) != 0) return -1;
        state = (RollingBufState *)prec->dpvt;
    }

    epicsMutexLock(state->lock);

    int size = state->size;
    int idx = state->bufidx;

    // Store new value
    state->buffer[idx] = *in;
    idx = (idx + 1) % size;
    state->bufidx = idx;

    // Output buffer in chronological order: [bufidx..end] + [0..bufidx-1]
    int tail = size - idx;
    memcpy(out, &state->buffer[idx], tail * sizeof(float));
    memcpy(out + tail, &state->buffer[0], idx * sizeof(float));

    epicsMutexUnlock(state->lock);

    return 0;
}

long rollingBufDel(aSubRecord *prec) {
    if (prec->dpvt) {
        freeRollingBuf((RollingBufState *)prec->dpvt);
        prec->dpvt = NULL;
    }
    return 0;
}

epicsRegisterFunction(rollingBufInit);
epicsRegisterFunction(rollingBufProcess);
epicsRegisterFunction(rollingBufDel);




