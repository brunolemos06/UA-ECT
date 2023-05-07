/**
 *  \file 
 *  \brief Functions to manage inode blocks
 *
 *  \author Artur Pereira - 2008-2009, 2016-2020
 *  \author Miguel Oliveira e Silva - 2009, 2017
 *  \author António Rui Borges - 2010-2015
 *
 *  \remarks In case an error occurs, every function throws an SOException
 */

#ifndef __SOFS21_INODEBLOCKS__
#define __SOFS21_INODEBLOCKS__

#include "freeinodes.h"

#include <inttypes.h>
#include <fcntl.h>
#include <unistd.h>

namespace sofs21
{
    /* *************************************************** */

    /** \anchor soNewInode
     *
     *  \brief Get a new inode.
     *  \ingroup c_ilayer
     *  \details An inode is retrieved from the list of free inodes or the queue of deleted inodes.
     * 
     *  The following must be considered:
     *  - \c type must be one of S_IFREG, S_IFDIR, S_IFLNK
     *  - \c perm must be a number in the range 0 and 0777, representing the permissions
     *  - if there are free inodes, one is used (\ref soAllocInode)
     *  - if there is no free but there are deleted inodes,
     *    the oldest deleted (\ref soUnqueueHiddenInode) 
     *    must be cleaned (\ref soFreeInodeBlocks) and used
     *  - after this operation, \ref mode must reflect the given \c type and \c perm (bitwise or)
     *  - \c owner and group are given by system calls \c getuid and \c getgid, respectively
     *  - if no inode is available, exception \c ENOSPC must be thrown.
     *
     *  \throws EINVAL if \c type is not valid.
     *  \throws EINVAL if \c perm is not valid.
     *  \throws ENOSPC if there are no free or hidden (deleted) inodes.
     *
     *  \param [in] type the inode's type
     *  \param [in] perm the inode's permissions 
     *  \return the number (reference) of the inode allocated
     *
     * \difficulty 3 (medium-low)
     *
     * \note
     * When calling a function of any layer, the version with prefix \b so should be used,
     *   not the one with prefix \b grp or \b bin.
     */
    uint16_t soNewInode(uint16_t type, uint16_t perm);

    /* *************************************************** */

    /** \anchor soRemoveInode
     *
     *  \brief transfer inode's reference to the deleted queue.
     *  \ingroup c_ilayer
     *  \details The inode is inserted into the queue of deleted inodes, keeping all its data.
     * 
     *  The following must be considered:
     *  - if the deleted queue is full (\ref soHideInode), the oldest inode there must removed from
     *    the queue (\ref soUnqueueHiddenInode), 
     *    cleaned (\ref soFreeInodeBlocks) and freed (\ref soFreeInode)
     *  - the given inode's reference must be inserted into the queue 
     *    and its managing fields (\ref iqcount) updated.
     *
     *  \throws EINVAL if \c in is not valid (through \ref soHideInode)
     *
     *  \param [in] in number (reference) of inode to be removed
     *
     * \difficulty 3 (medium-low)
     *
     * \note
     * When calling a function of any layer, the version with prefix \b so should be used,
     *   not the one with prefix \b grp or \b bin.
     */
    void soRemoveInode(uint16_t in);

    /* *************************************************** */

    /**
     *  \anchor soGetInodeBlock
     *
     *  \brief Get the data block number corresponding to the given inode block
     *  \ingroup c_ilayer
     *
     *  \details
     *  The following must be considered:
     *  - the inode block number (ibn) is the number of a block from the file (inode) point of view,
     *    0 representing the first block, 1 the second, and so forth
     *  - the data block number corresponding to ibn is given by d[ibn], 
     *    noting, that array d[.] is only partially stored in the inode
     *  - \ref NullBlockReference is a valid return value
     *  .
     *
     *  \throws EINVAL if \c ih is not a valid handler of a open inode (through \ref soGetInodePointer)
     *  \throws EINVAL if \c ibn is not a valid inode block number
     *
     *  \param [in] ih inode handler
     *  \param [in] ibn inode block number
     *  \return the number of the corresponding data block
     *
     * \difficulty 4 (medium)
     *
     *  \note When calling a function of any layer, the version with prefix \b so should be used,
     *     not the one with prefix \b grp or \b bin.
     */
    uint32_t soGetInodeBlock(int ih, uint32_t ibn);

    /* *************************************************** */

    /**
     * \anchor soAllocInodeBlock
     *
     * \brief Associate a data block to the given inode block position
     * \ingroup c_ilayer
     *
     * \details
     *  The following must be considered:
     *  - the inode block number (ibn) is the number of a block from the file (inode) point of view,
     *    0 representing the first block, 1 the second, and so forth
     *  - the data block number corresponding to ibn is given by d[ibn], 
     *    noting, that array d[.] is only partially stored in the inode
     *  - if the current value of the corresponding data block is not \ref NullBlockReference,
     *    exception \c ESTALE must be thrown
     *  - depending on the situation, 1, 2, or 3 data blocks may be allocated
     *
     * \sa \ref soAllocDataBlock
     *
     *  \throws EINVAL if \c ih is not a valid handler of a open inode (through \ref soGetInodePointer)
     *  \throws EINVAL if \c ibn is not a valid inode block number
     *  \throws ESTALE if already exists a valid data block assigned to the given inode block position
     *
     * \param [in] ih inode handler
     * \param [in] ibn inode block number to be allocated
     * \return the number of the data block now associated to the given inode block position
     *
     * \difficulty 6 (high)
     *
     * \note
     * When calling a function of any layer, the version with prefix \b so should be used,
     *   not the one with prefix \b grp or \b bin.
     */
    uint32_t soAllocInodeBlock(int ih, uint32_t ibn);

    /* *************************************************** */

    /**
     * \anchor soFreeInodeBlocks
     *
     * \brief Free all inode blocks from the given position on.
     * \ingroup c_ilayer
     * \details
     *  The following must be considered:
     *  - the inode block number (ibn) is the number of a block from the file (inode) point of view,
     *    0 representing the first block, 1 the second, and so forth
     *  - the data block number corresponding to ibn is given by d[ibn], 
     *    noting, that array d[.] is only partially stored in the inode
     *  - an inode can have \e holes, meaning references equal to \ref NullBlockReference
     *    may appear between others that aren't
     *  - data blocks used to store references that become empty must be also freed too
     *  - data blocks used to store references changed, even if they become empty 
     *    (all entries equal to \ref NullBlockReference), must be saved
     *
     * \sa \ref soFreeDataBlock
     *
     *  \throws EINVAL if \c ih is not a valid handler of a open inode (through \ref soGetInodePointer)
     *
     * \param [in] ih inode's handler
     * \param [in] fibn first inode block number to be freed
     *
     * \difficulty 7 (very-high)
     *
     * \note
     * When calling a function of any layer, the version with prefix \b so should be used,
     *   not the one with prefix \b grp or \b bin.
     */
    void soFreeInodeBlocks(int ih, uint32_t fibn);

    /* *************************************************** */

    /**
     * \anchor soReadInodeBlock
     *
     * \brief Read an inode block.
     * \ingroup c_ilayer
     *
     * \details
     *   \ref BlockSize bytes are read from the given inode into the buffer pointed to by \c buf
     *
     *  The following must be considered:
     *  - if the referred inode block has not been allocated yet 
     *    (reference equal to \ref NullBlockReference),
     *    the returned data will consist of a byte stream filled with the
     *    null character (ascii code 0);
     *
     * \sa \ref soGetInodeBlock, \ref soReadDataBlock
     *
     *  \throws EINVAL if \c ih is not a valid handler of a open inode (through \ref soGetInodeBlock)
     *  \throws EINVAL if \c ih is not a valid inode block number (through \ref soGetInodeBlock)
     *
     * \pre \c buf is a valid pointer to a memory portion,
     *   at least \ref BlockSize bytes long, where the user has write permissions.
     *
     * \param [in] ih inode handler
     * \param [in] ibn inode block number
     * \param [in] buf pointer to the buffer where data must be read into
     *
     * \difficulty 2 (low)
     *
     * \note
     * When calling a function of any layer, the version with prefix \b so should be used,
     *   not the one with prefix \b grp or \b bin.
     */
    void soReadInodeBlock(int ih, uint32_t ibn, void *buf);

    /* *************************************************** */

    /**
     * \anchor soWriteInodeBlock
     *
     * \brief Write an inode block.
     * \ingroup c_ilayer
     *
     * \details
     *   \ref BlockSize bytes are written into the given inode block
     *
     *  The following must be considered:
     *  - if the referred block has not been allocated yet,
     *    it should be allocated now so that the data can be stored as its contents
     *
     * \sa \ref soGetInodeBlock, \ref soAllocInodeBlock, \ref soWriteDataBlock
     *
     *  \throws EINVAL if \c ih is not a valid handler of a open inode (through \ref soGetInodeBlock)
     *  \throws EINVAL if \c ih is not a valid inode block number (through \ref soGetInodeBlock)
     *
     * \pre \c buf is a valid pointer to a memory portion,
     *   at least \ref BlockSize bytes long, where the user has read permissions.
     *
     * \param [in] ih inode handler
     * \param [in] ibn inode block number
     * \param [in] buf pointer to the buffer containing data to be written
     *
     * \difficulty 2 (low)
     *
     * \note
     * When calling a function of any layer, the version with prefix \b so should be used,
     *   not the one with prefix \b grp or \b bin.
     */
    void soWriteInodeBlock(int ih, uint32_t ibn, void *buf);

    /* *************************************************** */

};

#endif /* __SOFS21_INODEBLOCKS__ */
