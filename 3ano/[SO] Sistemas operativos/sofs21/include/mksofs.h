/**
 *  \file
 *  \brief The \b sofs21 formatting functions.
 *
 *  \author Artur Pereira - 2007-2009, 2016-2020
 *  \author Miguel Oliveira e Silva - 2009, 2017
 *  \author António Rui Borges - 2010-2015
 */

#ifndef __SOFS21_MKSOFS__
#define __SOFS21_MKSOFS__

#include <inttypes.h>

#include "bin_mksofs.h"
#include "grp_mksofs.h"

namespace sofs21
{

    /**
     * \defgroup mksofs mksofs
     * \brief Auxiliary formatting functions
     * @{ 
     * */

    /* ******************************************************************* */

    /**
     * \brief Computes the structural partition of the disk
     * \details
     *   Based on the total number of blocks of the disk (\c ntotal) and
     *   on the number of inodes (\c itotal) proposed, 
     *   computes the structural partition, that is, the actual number of inodes,
     *   the number of data blocks and the number blocks for the bitmap table,
     *   taking into account the following:
     *   - \c itotal must be rounded up to a multiple of \ref IPB
     *   - \c itotal must be lower than or equal to the rounded up value of <tt>ntotal/8</tt>
     *   - \c itotal must be lower than or equal to \ref MAX_INODES
     *   - \c itotal must be greater than or equal to \c IPB
     *   - if, at entry, the proposed value for \c itotal is 0,
     *     value <tt>ntotal/20</tt> should be used as the proposed value
     *   - for every data block, there must exist a corresponding bit in the bitmap table
     *   - after making the partition, the last block of the bitmap table can be totally used,
     *     partially used, or not used at all; in such cases, it should be assigned
     *     to the inode table
     *   .
     * \difficulty 4 (medium)
     *
     * \note This function does not change any block of the disk.
     *
     * \param [in] ntotal the number of blocks of the disk
     * \param [in] itotal the requested number of inodes
     * \param [out] itsize the number of blocks of the inode table
     * \param [out] dbtotal the number of data blocks
     */
    void soComputeDiskStructure(uint32_t ntotal, uint16_t itotal, uint16_t & itsize, uint32_t & dbtotal);


    /**
     * \brief Fill in the fields of the superblock.
     * \details
     *   The following must be considered:
     *   - the magic number must be put at \c 0xFFFF. Afterwards, it will be put with the
     *     correct value
     *   - all bits of the inode bitmap must be at 1, except the one representing inode 0 and
     *     those that are not used
     *   - bitmap is seen as an array of 32-bits words, 
     *     being bit 0 the least significant bit of word 0
     *   - the deleted queue is initialized empty, 
     *     all of its cells filled with pattern \ref NullInodeReference
     *   - the retrieval cache is initialized empty      
     *   - The insertion cache is initialized empty
     *   .
     * \difficulty 4 (medium)
     *
     * \param [in] name volume name
     * \param [in] ntotal the total number of blocks in the device
     * \param [in] itsize the number of blocks of the inode table
     * \param [in] dbtotal the number of data blocks 
     *
     * \note Access to disk must be done using \ref soWriteRawBlock function
     */
    void soFillInSuperblock(const char *name, uint32_t ntotal, uint16_t itsize, uint32_t dbtotal);


    /**
     * \brief Fill in the blocks of the inode table.
     * \details
     *   The following must be considered:
     *   - the inode table starts on block number 1
     *   - all inodes are free, except inode number 0
     *   - inode number 0 must be filled knowing it is the root directory, considering:
     *     - its data is stored in data block number 0
     *     - field \c mode is the bitwise-or of \c type and \c permissions
     *     - \c type should be \c S_IFDIR
     *     - \c permissions should be 0755
     *     - \c owner and group are given by system calls \c getuid and \c getgid, respectively
     *   - all others inodes must be put in the clean state, meaning:
     *     - all reference fields at \ref NullBlockReference
     *     - all other fields at 0.
     *   .
     * \difficulty 4 (medium)
     *
     * \param [in] itsize the number of blocks of the inode table
     * \param [in] date if \c true current date is set; otherwise date is put at zero
     *
     * \note Access to disk must be done using \ref soWriteRawBlock function
     */
    void soFillInInodeTable(uint16_t itsize, bool date = true);


    /** 
     * \brief Fill in the root directory
     * \details
     *   The following must be considered:
     *   - the root directory occupies a single data block, the first one after the bitmap table
     *   - it contains two entries, filled in with \c "." and \c "..", both pointing to inode 0
     *   - the remaining of the data block must be empty, meaning:
     *     - \c nameBuffer field filled with pattern 0x0;
     *     - \c in field filled with \ref NullInodeReference
     *     .
     *   .
     * \difficulty 3 (medium-low1)
     *
     * \param [in] ntotal the number of blocks in the device
     * \param [in] itsize the number of blocks of the inode table
     * \param [in] dbtotal the number of data blocks
     *
     * \note Access to disk must be done using \ref soWriteRawBlock function
     */
    void soFillInRootDir(uint32_t ntotal, uint16_t itsize, uint32_t dbtotal);


    /**
     * \brief Fill in the bitmap table 
     * \details
     *   The following must be considered:
     *   - all bits of the bitmap must be at 1, except the one representing datablock 0 and
     *     those that are not used
     *   - bitmap is seen as an array of 32-bits words, 
     *     being bit 0 the least significant bit of word 0
     *   - nothing should be done, if there are no reference blocks
     *   .
     * \difficulty 4 (medium)
     *
     * \param [in] ntotal the number of blocks in the device
     * \param [in] itsize the number of blocks of the inode table
     * \param [in] dbtotal the number of data blocks
     *
     * \note Access to disk must be done using \ref soWriteRawBlock function
     */
    void soFillInBitmapTable(uint32_t ntotal, uint16_t itsize, uint32_t dbtotal);


    /**
     * \brief Fill with zeros the free data blocks
     * \details
     *   The following must be considered:
     *   - All data blocks, but the one used by the root directory, must be filled with pattern 0x0.
     *   .
     * \difficulty 2 (low)
     *
     * \param [in] ntotal the number of blocks in the device
     * \param [in] itsize the number of blocks of the inode table
     * \param [in] dbtotal the number of data blocks
     *
     * \note This function is only called if option \c -z is given when calling the formatter.
     * \note Access to disk must be done using \ref soWriteRawBlock function
     */
    void soZeroFreeDataBlocks(uint32_t ntotal, uint16_t itsize, uint32_t dbtotal);

    /* ***************************************** */

    /* ******************************************************************* */

    /** @} close group mksofs */
    /* ******************************************************************* */
};

#endif /* __SOFS21_MKSOFS__ */
