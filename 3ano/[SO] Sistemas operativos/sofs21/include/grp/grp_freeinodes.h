/**
 * \file
 * \brief Binary version of functions to manage the list of free inodes 
 *      and the list of free blocks
 * 
 *  \author Artur Pereira 2008-2009, 2016-2020
 *  \author Miguel Oliveira e Silva 2009, 2017
 *  \author António Rui Borges - 2010-2015
 *
 *  \remarks Refer to the main \c freeinodes header file for documentation
 *
 */

#ifndef __SOFS21_FREEINODES_GROUP__
#define __SOFS21_FREEINODES_GROUP__

#include <inttypes.h>

namespace sofs21
{
    uint16_t grpAllocInode();

    bool grpHideInode(uint16_t in);

    uint16_t grpUnqueueHiddenInode();

    void grpFreeInode(uint16_t in);
};

#endif /* __SOFS21_FREEINODES_GROUP__ */
