/**
 * \file
 * \brief Functions to manage the list of free inodes 
 * 
 *  \author Artur Pereira 2008-2009, 2016-2020
 *  \author Miguel Oliveira e Silva 2009, 2017
 *  \author António Rui Borges - 2010-2015
 *
 */

#ifndef __SOFS21_FREE_INODES__
#define __SOFS21_FREE_INODES__

#include <inttypes.h>

namespace sofs21
{

/* *************************************************** */

/**
 * \anchor soAllocInode
 *
 *  \brief Allocate a free inode.
 *  \ingroup a_ilayer
 *
 *  \details
 *  An inode is retrieved from the bitmap of free inodes, if possible. 
 *  
 *  The following must be considered:
 *  - the \ref ibitmap field of the superblock must be circularly searched and updated:
 *    - starting at the bit position pointed to by the \ref iidx superblock field
 *    - looking for the first bit at one
 *    - putting it at zero and returning its index, which corresponds to the inode number
 *  - the other inode meta data fields in the superblock (\ref iidx, \ref ifree) must be updated
 *  - returns \ref NullInodeReference if there is no free inodes, 
 *    even if the deleted queue is not empty. 
 *
 *  \return the number (reference) of the inode allocated or \ref NullInodeReference
 *
 *  \difficulty 3 (medium-low)
 *
 *  \note
 *  When calling a function of any layer, the version with prefix \b so should be used,
 *    not the one with prefix \b grp or \b bin.
 */
uint16_t soAllocInode();

/* *************************************************** */

/**
 * \anchor soHideInode
 *
 *  \brief Hide the inode
 *  \ingroup a_ilayer
 *
 * \details
 *  The inode is inserted into the queue of deleted inodes, if possible.
 *
 *  The following must be considered:
 *  - if the deleted queue is full (\ref iqcount equal to \ref DELETED_QUEUE_SIZE),
 *    do nothing and return false
 *  - the type bits of the inode's \ref mode field must be complemented (mask \c S_IFMT may be useful)
 *  - the inode reference must be inserted into the deleted queue (\ref iqueue),
 *    knowing that the queue is managed in a circular way
 *  - if given inode number is not valid, EINVAL exception must be thrown
 *
 *  \throw EINVAL if inode number is not valid.
 *
 *  \param [in] in number (reference) of the inode to be hidden
 *
 *  \difficulty 3 (medium-low)
 *
 *  \param [in] in the number of the inode to be hidden
 *  \return \c true if insertion was doen; \c false otherwise
 *
 *  \note
 *  When calling a function of any layer, the version with prefix \b so should be used,
 *    not the one with prefix \b grp or \b bin.
 *
 */
bool soHideInode(uint16_t in);

/* *************************************************** */

/**
 * \anchor soUnqueueHiddenInode
 *
 *  \brief Remove oldest inode from the queue of deleted (hidden) inodes
 *  \ingroup a_ilayer
 *
 * \details
 *  The following must be considered:
 *  - if the queue is empty, do nothing and return \ref NullInodeReference
 *  - remove oldest inode from queue and return its reference
 *  - even if funcionally not necessary, fill the removed position with \ref NullInodeReference
 *  - update the other \c iqueue fields (\ref iqhead, \ref iqcount)
 *
 *  \difficulty 3 (medium-low)
 *
 *  \return number of inode retrieved from queue or \ref NullInodeReference
 *
 *  \note
 *  When calling a function of any layer, the version with prefix \b so should be used,
 *    not the one with prefix \b grp or \b bin.
 *
 */
uint16_t soUnqueueHiddenInode();

/* *************************************************** */

/**
 * \anchor soFreeInode
 *
 *  \brief Free the referenced inode.
 *  \ingroup a_ilayer
 *
 * \details
 *  The inode is cleared and inserted into the bitmap of free inodes.
 *
 *  The following must be considered:
 *  - the corresponding bit of the \ref ibitmap field is put at one.
 *  - inode's \ref mode, \ref owner and \ref group fields are put at 0 
 *  - the other inode meta data fields in the \ref superblock (\ref iidx, ...) must be updated.
 *  - if given inode number is not valid, EINVAL exception must be thrown
 *
 *  \throw EINVAL if inode number is not valid.
 *
 *  \difficulty 3 (medium-low)
 *
 *  \param [in] in number (reference) of the inode to be freed
 *
 *  \note
 *  When calling a function of any layer, the version with prefix \b so should be used,
 *    not the one with prefix \b grp or \b bin.
 *
 */
void soFreeInode(uint16_t in);

/* *************************************************** */

};

#endif /* __SOFS21_FREE_INODES__ */
