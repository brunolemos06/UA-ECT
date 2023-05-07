/**
 *  \file 
 *  \brief Group version of function to manage inode blocks
 *
 *  \author Artur Pereira - 2008-2009, 2016-2020
 *  \author Miguel Oliveira e Silva - 2009, 2017
 *  \author António Rui Borges - 2010-2015
 *
 *  \remarks Refer to the main \c inodeblocks header file for documentation
 */

#ifndef __SOFS21_INODEBLOCKS_GROUP__
#define __SOFS21_INODEBLOCKS_GROUP__

#include <inttypes.h>

namespace sofs21
{
    uint32_t grpGetInodeBlock(int ih, uint32_t ibn);

    uint32_t grpAllocInodeBlock(int ih, uint32_t ibn);

    void grpFreeInodeBlocks(int ih, uint32_t fibn);

    void grpReadInodeBlock(int ih, uint32_t ibn, void *buf);

    void grpWriteInodeBlock(int ih, uint32_t ibn, void *buf);

    uint16_t grpNewInode(uint16_t type, uint16_t perm);

    void grpRemoveInode(uint16_t in);
};

#endif /* __SOFS21_INODEBLOCKS_GROUP__ */
