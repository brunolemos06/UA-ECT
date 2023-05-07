/**
 * \file
 * \brief Binary version of functions to manage the list of free inodes 
 *      and the list of free blocks
 * 
 *  \author Artur Pereira 2008-2009, 2016-2020
 *  \author Miguel Oliveira e Silva 2009, 2017
 *  \author António Rui Borges - 2010-2015
 *
 *  \remarks Refer to the main \c freedatablocks header file for documentation
 *
 */

#ifndef __SOFS21_FREEDATAGROUPS_GROUP__
#define __SOFS21_FREEDATAGROUPS_GROUP__

#include <inttypes.h>

namespace sofs21
{
    uint32_t grpAllocDataBlock();

    void grpReplenishFromCache();

    void grpReplenishFromBitmap();

    void grpFreeDataBlock(uint32_t bn);

    void grpDeplete();
};

#endif /* __SOFS21_FREEDATAGROUPS_GROUP__ */
