/**
 *  \file
 *  \brief Some sofs21 global constants 
 *
 *  \author Artur Pereira - 2016-2020
 */

#ifndef __SOFS21_CONSTANTS__
#define __SOFS21_CONSTANTS__

#include <inttypes.h>

namespace sofs21
{
    /** \defgroup constants constants 
     * \brief Core constants
     * \ingroup core
     */

    /** @{ */

    /** \brief block size (in bytes) */
#define BlockSize 1024U

    /** \brief number of inodes per block \anchor IPB */
#define IPB (BlockSize / sizeof(SOInode))

    /** \brief number of references per block \anchor RPB */
#define RPB (BlockSize / sizeof (uint32_t))

    /** \brief number of direntries per block \anchor DPB */
#define DPB (BlockSize / sizeof(SODirectorySlot))

/**
 * \anchor NullBlockReference 
 * 
 * \brief null reference to a block 
 */
#define NullBlockReference 0xFFFFFFFF

    /** \brief null reference to an inode \anchor NullInodeReference */
#define NullInodeReference 0xFFFF

    /** \brief maximum number of inodes in a sofs21 disk \anchor MAX_INODES */
#define MAX_INODES (8*4*100)

    /** 
     * \brief maximum length of a file name (in characters)
     * \anchor FILENAME_MAXLEN
     */
#define FILENAME_MAXLEN (2*DIRECTORY_SLOT)

    /** @} */

};

#endif /* __SOFS21_CONSTANTS__ */
