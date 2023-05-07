/**
 * \file
 * \brief Functions to manage the list of free inodes and the list of free data blocks
 * 
 *  \author Artur Pereira 2008-2009, 2016-2020
 *  \author Miguel Oliveira e Silva 2009, 2017
 *  \author António Rui Borges - 2010-2015
 *
 */

#ifndef __SOFS21_FREE_DATABLOCKS__
#define __SOFS21_FREE_DATABLOCKS__

#include <inttypes.h>

namespace sofs21
{

    /* *************************************************** */

    /**
     * \anchor soAllocDataBlock
     *
     * \brief Allocate a free data block.
     * \ingroup b_ilayer
     *
     * \details 
     * A reference to a free data block is retrieved from the retrieval cache.
     *
     *  The following must be considered:
     *  - if the retrieval cache is empty, the replenish functions must be called first:
     *    - the \ref soReplenishFromBitmap must be called, if it is not empty
     *    - otherwise the \ref soReplenishFromCache must be called
     *  - the first reference must be retrieved from the retrieval cache and returned
     *  - some superblock's fields (\ref dbfree, \ref retrieval_cache) must be updated properly.
     *
     * \throw ENOSPC if there are no free data blocks
     *
     * \return the number (reference) of the data block allocated
     *
     * \difficulty 3 (medium-low)
     *
     * \note
     * When calling a function of any layer, the version with prefix \b so should be used,
     *   not the one with prefix \b grp or \b bin.
     */
    uint32_t soAllocDataBlock();

    /* *************************************************** */

    /**
     * \anchor soFreeDataBlock
     *
     * \brief Free the data block referenced.
     * \ingroup b_ilayer
     *
     * details
     *   The reference of the freed data block is inserted into the insertion cache:
     *
     *  The following must be considered:
     *  - if the insertion cache is full, the deplete function (\ref soDeplete) must be called first
     *  - The reference must be inserted at the first empty cell
     *  - some superblock's fields (\ref dbfree, \ref insertion_cache) must be updated properly.
     *
     * \throw EINVAL if data block number is not valid.
     *
     * \param [in] bn the number (reference) of the data block to be freed
     *
     * \difficulty 2 (low)
     *
     * \note
     * When calling a function of any layer, the version with prefix \b so should be used,
     *   not the one with prefix \b grp or \b bin.
     */
    void soFreeDataBlock(uint32_t bn);

    /* *************************************************** */

    /**
     * \anchor soReplenishFromCache
     *
     * \brief Replenish the retrieval cache from the insertion cache
     * \ingroup b_ilayer
     *
     * \details 
     *   References to free data blocks should be transferred from the 
     *   the insertion cache to the retrieval cache:
     *
     *   The following must be considered:
     *   - do nothing if the retrieval cache is not empty
     *   - after transferring a reference from A to B,
     *     the value in A must become \ref NullBlockReference
     *   - \c superblock's fields (\ref retrieval_cache, \ref insertion_cache)
     *     must be properly updated.
     *
     *  \difficulty 3 (medium-low)
     *
     *  \note
     *  When calling a function of any layer, the version with prefix \b so should be used,
     *    not the one with prefix \b grp or \b bin.
     */
    void soReplenishFromCache();

    /* *************************************************** */

    /**
     * \anchor soReplenishFromBitmap
     *
     * \brief Replenish the retrieval cache from the bitmap
     * \ingroup b_ilayer
     *
     * \details 
     *   References to free data blocks should be transferred from the 
     *   bitmap table to the retrieval cache:
     *
     *   The following must be considered:
     *   - do nothing if the retrieval cache is not empty
     *   - after transferring a reference from A to B,
     *     the value in A must become \ref NullBlockReference
     *   - \c superblock's fields (\ref retrieval_cache, \ref rbm_idx)
     *     must be properly updated
     *   - if bitmap becomes empty (no bits at one),
     *     \ref rbm_idx must be assigned \ref NullBlockReference
     *   - be aware of the circularity of the bitmap table.
     * .
     *
     *  \difficulty 5 (medium-high)
     *
     *  \note
     *  When calling a function of any layer, the version with prefix \b so should be used,
     *    not the one with prefix \b grp or \b bin.
     */
    void soReplenishFromBitmap();

    /* *************************************************** */

    /**
     * \anchor soDeplete
     *
     * \brief Deplete the insertion cache
     * \ingroup b_ilayer
     *
     * \details
     *   References to free data blocks should be transferred from the insertion cache
     *   to the bitmap table.
     *
     *   The following must be considered:
     *   - do nothing if the insertion cache is not full
     *   - after transferring a reference from A to B,
     *     the value in A must become \ref NullBlockReference
     *   - if \ref rbm_idx is \ref NullBlockReference, it must be assigned 0
     *   - \c superblock's fields (\ref insertion_cache, \ref rbm_idx)
     *     must be updated properly
     *   - after transferring a reference from A to B, the value in A becomes NullBlockReference
     *   - the data block meta data fields in the superblock must be updated.
     * .
     *
     *  \difficulty 5 (medium-high)
     *
     * \note
     *   When calling a function of any layer, the version with prefix \b so should be used,
     *   not the one with prefix \b grp or \b bin.
     *
     */
    void soDeplete();

    /* *************************************************** */

};

#endif /* __SOFS21_FREE_DATABLOCKS__ */
