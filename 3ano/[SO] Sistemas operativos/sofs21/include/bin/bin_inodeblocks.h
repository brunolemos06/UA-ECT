/**
 *  \file 
 *  \brief Binary version of function to manage inode blocks
 *
 *  \author Artur Pereira - 2008-2009, 2016-2020
 *  \author Miguel Oliveira e Silva - 2009, 2017
 *  \author António Rui Borges - 2010-2015
 *
 */

#ifndef __SOFS21_INODEBLOCKS_BIN__
#define __SOFS21_INODEBLOCKS_BIN__

#include <inttypes.h>

namespace sofs21
{
    uint32_t binGetInodeBlock(int ih, uint32_t ibn);

    uint32_t binAllocInodeBlock(int ih, uint32_t ibn);

    void binFreeInodeBlocks(int ih, uint32_t fibn);

    void binReadInodeBlock(int ih, uint32_t ibn, void *buf);

    void binWriteInodeBlock(int ih, uint32_t ibn, void *buf);

    uint16_t binNewInode(uint16_t type, uint16_t perm);

    void binRemoveInode(uint16_t in);
};

#endif /* __SOFS21_INODEBLOCKS_BIN__ */
