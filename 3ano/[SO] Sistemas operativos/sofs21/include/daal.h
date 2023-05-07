/**
 * \file
 * \brief Functions of the disk access abstraction layer (\c daal) module
 */

#ifndef __SOFS21_DAAL__
#define __SOFS21_DAAL__

#include <inttypes.h>

#include "bin_daal.h"
#include "core.h"

namespace sofs21
{

    /**
     * \defgroup daal daal
     * \brief Disk access abstraction layer 
     * \details 
     *   This layer is used to prevent higher level functions
     *   from access disk blocks at raw level.
     */
    
    /**
     * \defgroup a_daal daal/OC 
     *   \brief Opening and closing
     *   \ingroup daal
     * \defgroup b_daal daal/SB
     *   \brief Accessing and saving superblock
     *   \ingroup daal
     * \defgroup c_daal daal/IT
     *   \brief Accessing inodes in the inode table
     *   \ingroup daal
     * \defgroup d_daal daal/BT
     *   \brief Accessing blocks of the bitmap table
     *   \ingroup daal
     * \defgroup e_daal daal/DBP
     *   \brief Accessing data blocks of the data block pool
     *   \ingroup daal
     */

    /* ***************************************** */

    /**
     * \brief Open disk sofs21 abstraction level
     * \ingroup a_daal
     *
     * \details
     * Open disk at raw level and initialize all related data structures
     */
    void soOpenDisk(const char *devname);

    /* ***************************************** */

    /**
     * \brief Close disk sofs21 abstraction level
     * \ingroup a_daal
     *
     * \details
     * First close sofs21 abstraction modules and then
     * close disk at raw level.
     */
    void soCloseDisk();

    /* ***************************************** */
    /* ***************************************** */

    /**
     * \brief Open the superblock dealer
     * \ingroup a_daal
     *
     * \details
     * Prepare the internal data structure of the superblock dealer
     */
    void soOpenSuperblock();

    /* ***************************************** */

    /**
     * \brief Close the superblock dealer
     * \ingroup a_daal
     *
     * \details
     * Save superblock to disk and close dealer
     * Do nothing if not loaded
     */
    void soCloseSuperblock();

    /* ***************************************** */

    /**
     * \brief Save superblock to disk
     * \ingroup b_daal
     *
     * \details
     * Do nothing if not loaded
     */
    void soSaveSuperblock();

    /* ***************************************** */

    /**
     * \anchor soGetSuperblockPointer
     * \brief Get a pointer to the superblock
     * \ingroup b_daal
     *
     * \details
     * Load the superblock, if not done yet
     *
     * \return Pointer to the superblock in memory.
     */
    SOSuperblock *soGetSuperblockPointer();

    /* ***************************************** */
    /* ***************************************** */

    /**
     * \brief Open inode table dealer
     * \ingroup a_daal
     *
     * \details
     * Prepare the internal data structure for the inode table dealer
     */
    void soOpenInodeTable();

    /* ***************************************** */

    /**
     * \brief Close the inode table dealer
     * \ingroup a_daal
     *
     * \details
     * Save to disk all openning inodes and close dealer
     */
    void soCloseInodeTable();

    /* ***************************************** */

    /**
     * \brief open inode
     * \ingroup c_daal
     *
     * \details
     * If inode is already open, just increment usecount;
     * otherwise, transfer the inode from disk and 
     * put usecount at 1.
     *
     * \param in the number of the inode to open
     * \return inode handler
     */
    int soOpenInode(uint16_t in);

    /* ***************************************** */

    /**
     * \brief Check given handler, throwing an exception in case of error
     * \ingroup c_daal
     * \param ih the handler to be checked
     * \param funcname name of the function making the ckeck
     */
    void soCheckInodeHandler(int ih, const char *funcname = __FUNCTION__);

    /* ***************************************** */

    /**
     * \anchor soGetInodePointer
     * 
     * \brief get pointer to an open inode
     * \ingroup c_daal
     *
     * \details
     * A pointer to the SOInode structured where the inode
     * is loaded is returned.
     *
     * \param ih inode handler
     * \return pointer to the inode
     */
    SOInode *soGetInodePointer(int ih);

    /* ***************************************** */

    /**
     * \anchor soSaveInode
     * \brief Save an open inode to disk
     * \ingroup c_daal
     *
     * \details
     * The inode is not closed.
     *
     * \param ih inode handler
     */
    void soSaveInode(int ih);

    /* ***************************************** */

    /**
     * \brief Close an open inode
     * \ingroup c_daal
     *
     * \details
     * Decrement usecount of given inode,
     * releasing slot if 0 is reached.
     *
     * \param ih inode handler
     */
    void soCloseInode(int ih);

    /* ***************************************** */

    /**
     * \brief Return the number of the inode associated to the given handler
     * \ingroup c_daal
     * \param ih inode handler
     * \return inode number
     */
    uint16_t soGetInodeNumber(int ih);

    /* ***************************************** */
    /* ***************************************** */

    /**
     * \anchor soCheckInodeAccess
     * \brief check inode access against a requested access
     * \ingroup c_daal
     * \details access is a bitwise OR of one or more of R_OK, W_OK, and X_OK
     * \sa man 2 access
     * \param ih inode handler
     * \param access requested access
     * \return true, for access granted; false for access denied
     */
    bool soCheckInodeAccess(int ih, int access);

    /* ***************************************** */
    /* ***************************************** */

    /**
     * \brief Open data block pool dealer
     * \ingroup a_daal
     *
     * \details
     * Prepare the internal data structure for the data block pool dealer.
     * 
     * Do nothing in the current implementation, but a buffer cache could be
     * inserted here.
     */
    void soOpenDataBlockPool();

    /* ***************************************** */

    /**
     * \brief Close the data block pool dealer
     * \ingroup a_daal
     *
     * \details
     * Do nothing in the current implementation.
     */
    void soCloseDataBlockPool();

    /* ***************************************** */

    /**
     * \anchor soReadDataBlock
     * \brief Read a block of the data zone
     * \ingroup e_daal
     *
     * \param[in] bn number of block to be read
     * \param[in] buf pointer to the buffer where the data must be read into
     */
    void soReadDataBlock(uint32_t bn, void *buf);

    /* ***************************************** */

    /**
     * \anchor soWriteDataBlock
     * \brief Write a block of the data zone
     * \ingroup e_daal
     *
     * \param[in] bn number of block to be read
     * \param[in] buf pointer to the buffer where the data must be written from
     */
    void soWriteDataBlock(uint32_t bn, void *buf);

    /* ***************************************** */
    /* ***************************************** */

    /**
     * \brief Open bitmap table dealer
     * \ingroup a_daal
     *
     * \details
     * Prepare the internal data structure for the bitmap table dealer.
     */
    void soOpenBitmapTable();

    /* ***************************************** */

    /**
     * \brief Close bitmap table pool dealer
     * \ingroup a_daal
     *
     * \details
     * Close dealer, saving to disk any pending data.
     */
    void soCloseBitmapTable();

    /* ***************************************** */

    /**
     * \anchor soGetBitmapBlockPointer
     * \brief Get a pointer to a bitmap block of the bitmap table
     * \ingroup d_daal
     *
     * \details
     * Load from disk a bitmap block, if not done yet,
     * and return a pointer to it.
     *
     * A sofs21 exception is thrown if the dealer is not open.
     *
     * \param rbn index, within the bitmap table, of the required reference block
     * \return Pointer to the bitmap block in memory
     */
    uint32_t *soGetBitmapBlockPointer(uint32_t rbn);

    /* ***************************************** */

    /**
     * \anchor soSaveBitmapBlock
     * \brief Save bitmap block to disk
     * \ingroup d_daal
     *
     * \details
     * The currently open bitmap block, if any,
     * is saved to disk.
     *
     * A sofs21 exception is thrown if no block is open or
     * if the dealer is not open.
     */
    void soSaveBitmapBlock();

    /* ***************************************** */

};


#endif /* __SOFS21_DAAL__ */
