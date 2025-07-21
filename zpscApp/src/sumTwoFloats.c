#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#include <aSubRecord.h>
#include <registryFunction.h>
#include <epicsExport.h>
#include <epicsMutex.h>
#include <epicsTypes.h>


long sumTwoFloats(aSubRecord *prec) {
    if (!prec->a || !prec->b || !prec->vala) return -1;

    int inA = *(int *)prec->a;       // INPA data
    int inB = *(int *)prec->b;      // INPB data
    float *out = (float *)prec->vala;    // VALA output


    *out = inA + inB;
    
    printf("A=%d   B=%d   Sum=%f\n",inA, inB, *out);

    return 0;
}

epicsRegisterFunction(sumTwoFloats);





