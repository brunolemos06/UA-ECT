/**
 * \file 
 * \brief Functions to manage directory entries
 *
 * \author Artur Pereira 2008-2009, 2016-2020
 * \author Miguel Oliveira e Silva 2009, 2017
 * \author António Rui Borges - 2012-2015
 *
 * \remarks In case an error occurs, every function throws an SOException
 */

#ifndef __SOFS21_DIRENTRIES__
#define __SOFS21_DIRENTRIES__

#include <inttypes.h>

namespace sofs21
{

    /* ************************************************** */

    /**
     * \anchor soTraversePath
     *
     * \brief Get the inode associated to a given path
     * \ingroup d_ilayer
     *
     * \details
     *   The directory hierarchy of the file system is traversed to find
     *   an entry whose name is the rightmost component of the given path
     *
     *  The following must be considered:
     *  - every components of the path, with the exception of the rightmost one, 
     *    must be a directory
     *  - the user must have traverse (x) permission on every components of the path, 
     *    with exception of the rightmost one (\ref soCheckInodeAccess).
     *
     *  \difficulty 4 (medium)
     *
     * \sa \ref soGetDirentry
     *
     * \pre \c path is an absolute path
     * \pre \c path does not contain symbolic links
     *
     * \throws ENOTDIR if one of the \c path components, with the exception of the rightmost one,
     *   is not a directory
     * \throws EACCES if the process that calls the operation does not have traverse
     *   (x) permission on a component of the path, with
     *   exception of the rightmost one
     *
     * \param [in] path the path to be traversed
     * \return the corresponding inode number
     *
     * \note
     *   When calling a function of any layer, the version with prefix \b so should be used,
     *   not the one with prefix \b grp or \b bin.
     *
     */
    uint16_t soTraversePath(char *path);

    /* ************************************************** */

    /**
     * \anchor soGetDirentry
     *
     * \brief Get the inode associated to a given name
     * \ingroup d_ilayer
     *
     * \details
     *   The directory contents, seen as an array of directory entries,
     *   is searched for an entry whose name matches the given one.
     *
     *  The following must be considered:
     *  - structurally, a direntry can be seen as an array of directory slots
     *    (\ref soDirectorySlot)
     *  - functionally, it can be seen as a sequence of directory entries,
     *    each occupying 1 or 2 slots, depending on its name's length
     *  - when an entry occupies 2 slots, the inode number is only in the last one,
     *    being \ref NullInodeReference in the first one
     *  - the string stored in the \c nameBuffer field of a slot
     *    may be not null terminated (use \c strncpy and \c strncmp for its manipulation)
     *  - there can exist empty slots between ocuppied slots
     *  - a slot is empty if the first character in the \c nameBuffer field is the null character ('\0')
     *  - \ref NullInodeReference is a valid return value, 
     *    happening when \c name doen not exist.
     *
     *  \difficulty 5 (medium-high)
     *
     * \pre \c pih is a valid inode handler of a directory where the user has read access
     * \pre \c name is a valid <em>base name</em> (it doesn't contain '/')
     *
     * \param [in] pih inode handler of the parent directory
     * \param [in] name the name of the entry to be searched for
     * \return the corresponding inode number or NullInodeReference, if \c name doesn't exist
     *
     * \note
     *   When calling a function of any layer, the version with prefix \b so should be used,
     *   not the one with prefix \b grp or \b bin.
     */
    uint16_t soGetDirentry(int pih, const char *name);

    /* ************************************************** */

    /**
     * \anchor soAddDirentry
     *
     * \brief Add a new entry to the parent directory.
     * \ingroup d_ilayer
     *
     * \details
     *   A direntry is added connecting the parent inode to the child inode.
     *
     *  The following must be considered:
     *  - structurally, a direntry can be seen as an array of directory slots
     *    (\ref soDirectorySlot)
     *  - functionally, it can be seen as a sequence of directory entries,
     *    each occupying 1 or 2 slots, depending on its name's length
     *  - when an entry occupies 2 slots, the inode number is only in the last one,
     *    being \ref NullInodeReference in the first one
     *  - the string stored in the \c nameBuffer field of a slot
     *    may be not null terminated (use \c strncpy and \c strncmp for its manipulation)
     *  - there can exist empty slots between ocuppied slots
     *  - a slot is empty if the first character in the \c nameBuffer field is the null character ('\0')
     *  - the first hole (sequence of continuous slots) big enough to hold the new directory entry
     *    must be used
     *  - if an entry with the same name already exists, exception \c EEXIST must be thrown
     *  - the \c lnkcnt field of the child inode is not to be changed by this function.
     *
     *  \difficulty 6 (high)
     *
     * \pre \c pih is a valid inode handler of a directory where the user has write access
     * \pre \c name is a valid <em>base name</em> (it doesn't contain '/')
     * \pre \c cin is a valid inode number
     *
     * \throws EEXIST if \c name already exists
     *
     * \param [in] pih inode handler of the parent inode
     * \param [in] name the name of the entry to be created
     * \param [in] cin inode number of the entry to be created
     * 
     * \note
     *   When calling a function of any layer, the version with prefix \b so should be used,
     *   not the one with prefix \b grp or \b bin.
     */
    void soAddDirentry(int pih, const char *name, uint16_t cin);

    /* ************************************************** */

    /**
     * \anchor soDeleteDirentry
     *
     * \brief Delete an entry from a parent directory.
     * \ingroup d_ilayer
     *
     * \details
     *  The directory slots associated from the given name are cleaned (become empty).
     *
     *  The following must be considered:
     *  - structurally, a direntry can be seen as an array of directory slots
     *    (\ref soDirectorySlot)
     *  - functionally, it can be seen as a sequence of directory entries,
     *    each occupying 1 or 2 slots, depending on its name's length
     *  - when an entry occupies 2 slots, the inode number is only in the last one,
     *    being \ref NullInodeReference in the first one
     *  - the string stored in the \c nameBuffer field of a slot
     *    may be not null terminated (use \c strncpy and \c strncmp for its manipulation)
     *  - there can exist empty slots between ocuppied slots
     *  - to clean a slot its \c nameBuffer field must be totally filled with the null
     *    character ('\0') (\c memset can be used)
     *    and \c in field with \ref NullInodeReference
     *  - if an entry with the given name does not exist, exception \c ENOENT must be thrown
     *  - the \c lnkcnt field of the child inode is not to be changed by this function.
     *
     *  \difficulty 5 (medium-high)
     *
     * \pre \c pih is a valid inode handler of a directory where the user has write access
     * \pre \c name is a valid <em>base name</em> (it doesn't contain '/')
     *
     * \throws ENOENT if \c name does not exist
     *
     * \param [in] pih inode handler of the parent inode
     * \param [in] name name of the entry
     *
     * \return the inode number associated to the deleted entry
     *
     * \note The \c lnkcnt of the child inode is not to be changed by this function.
     * \note
     *   When calling a function of any layer, the version with prefix \b so should be used,
     *   not the one with prefix \b grp or \b bin.
     */
    uint16_t soDeleteDirentry(int pih, const char *name);

    /* ************************************************** */

    /**
     * \anchor soRenameDirentry
     *
     * \brief Rename an entry of a directory.
     * \ingroup d_ilayer
     *
     * \details
     *   A direntry associated from the given directory is renamed.
     *   - The renaming can not be done deleting the entry and adding a new one.
     *
     *  The following must be considered:
     *  - structurally, a direntry can be seen as an array of directory slots
     *    (\ref soDirectorySlot)
     *  - functionally, it can be seen as a sequence of directory entries,
     *    each occupying 1 or 2 slots, depending on its name's length
     *  - when an entry occupies 2 slots, the inode number is only in the last one,
     *    being \ref NullInodeReference in the first one
     *  - the string stored in the \c nameBuffer field of a slot
     *    may be not null terminated (use \c strncpy and \c strncmp for its manipulation)
     *  - there can exist empty slots between ocuppied slots
     *  - if an entry with the given \c name does not exist, exception \c ENOENT must be thrown
     *  - if an entry with the given \c newName already exists, exception \c EEXIST must be thrown
     *  - note that the number of slots occupied by the entry after the renaming can change:
     *    - if lower, the unused slot must be cleaned
     *    - if bigger and the following slot is empty, the entry extends now to the next slot
     *    - if bigger and the following slot is not empty, the entry must be moved to 
     *      the first hole big enough to hold it
     *  - this function <b>can not be implemented</b> using \ref soDeleteDirentry followed by
     *     \ref soAddDirentry.
     *
     *  \difficulty 7 (very-high)
     *
     * \pre \c pih is a valid inode handler of a directory where the user has write access
     * \pre \c name and \c newName are valid <em>base names</em> (they don't contain '/')
     *
     * \throws ENOENT if \c name does not exist
     * \throws EEXIST if \c newName already exists
     * 
     * \param [in] pih inode handler of the parent inode
     * \param [in] name current name of the entry
     * \param [in] newName new name for the entry
     *
     * \note
     *   When calling a function of any layer, the version with prefix \b so should be used,
     *   not the one with prefix \b grp or \b bin.
     */
    void soRenameDirentry(int pih, const char *name, const char *newName);

    /* ************************************************** */

    /**
     * \anchor soCheckDirEmpty
     *
     * \brief Check directory emptiness
     * \ingroup d_ilayer
     *
     * \details
     *   The directory is traversed to verified if the only existing entries are "." and "..".
     *
     *  The following must be considered:
     *  - structurally, a direntry can be seen as an array of directory slots
     *    (\ref soDirectorySlot)
     *  - functionally, it can be seen as a sequence of directory entries,
     *    each occupying 1 or 2 slots, depending on its name's length
     *  - when an entry occupies 2 slots, the inode number is only in the last one,
     *    being \ref NullInodeReference in the first one
     *  - the string stored in the \c nameBuffer field of a slot
     *    may be not null terminated (use \c strncpy and \c strncmp for its manipulation)
     *  - there can exist empty slots between ocuppied slots.
     *
     *  \difficulty 3 (medium-low)
     *
     * \pre \c pih is a valid inode handler of a directory where the user has read access
     *
     * \param [in] pih handler of the inode to be checked
     * 
     * \note
     *   When calling a function of any layer, the version with prefix \b so should be used,
     *   not the one with prefix \b grp or \b bin.
     */
    bool soCheckDirEmpty(int pih);

    /* ************************************************** */

};

#endif /* __SOFS21_DIRENTRIES__ */
