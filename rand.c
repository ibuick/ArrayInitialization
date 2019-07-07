//
//  rand.c
//  tex
//
//  Created by Buick Wong on 7/7/19.
//  Copyright © 2019 Buick Wong. All rights reserved.
//

#include "rand.h"

void rdrand64_step (double *rand)
{
    volatile unsigned char ok;
    asm volatile ("rdrand %0; setc %1"
                  : "=r" (*rand), "=qm" (ok));
}
