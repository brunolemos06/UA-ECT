// NMEC: Bruno Braguês Costa Lemos
// NICK: 98221

// Complete the functions (marked by ...)
// so that it passes all tests in Tests.

#include "PersonSet.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "SortedList.h"

// NOTE THAT:
// - Field capacity was eliminated.
// - Field size was eliminated, because size==ListGetSize(...).

// Definition of the structure
struct _PersonSet_ {
  List *persons;  // points to a SortedList of Person pointers
};

// Comparison function to be used in generic SortedList.
// Comparison is based on Person ID
static int cmpP(const void *a, const void *b) {
  Person *p1 = (Person *)a;
  Person *p2 = (Person *)b;
  int d = p1->id - p2->id;
  return (d > 0) - (d < 0);
}

// Create a PersonSet.
PersonSet *PersonSetCreate() {
  // You must allocate space for the struct and create an empty persons list!
  PersonSet* ps = (PersonSet*) malloc(sizeof(PersonSet));
  if(ps == NULL) return NULL;
  
  ps->persons = ListCreate(cmpP);
  if(ps->persons == NULL){
    free(ps);
    return NULL;
  }
  return ps;
}

// Destroy PersonSet *pps
void PersonSetDestroy(PersonSet **pps) {
  assert(*pps != NULL);
  PersonSet *ps = *pps;
  ListDestroy(&(ps->persons));
  free(ps);
  *pps = NULL; 
}

int PersonSetSize(const PersonSet *ps) { return ListGetSize(ps->persons); }

int PersonSetIsEmpty(const PersonSet *ps) { return ListIsEmpty(ps->persons); }

void PersonSetPrint(const PersonSet *ps) {
  printf("{\n");
  for (ListMoveToHead(ps->persons); ListCurrentIsInside(ps->persons);
       ListMoveToNext(ps->persons)) {
    Person *p = (Person *)ListGetCurrentItem(ps->persons);
    PersonPrintf(p, ";\n");
  }
  printf("}(size=%d)\n", PersonSetSize(ps));
  ListTestInvariants(ps->persons);
}

// Find node in list ps->persons of person with given id.
// (INTERNAL function.)
static int search(const PersonSet *ps, int id) {
  Person dummyperson;
  dummyperson.id = id;
  return ListSearch(ps->persons, &dummyperson);
}

// Add person *p to *ps.
// Do nothing if *ps already contains a person with the same id.
void PersonSetAdd(PersonSet *ps, Person *p) {
  if(ListSearch(ps->persons,p) < 0) ListInsert(ps->persons,p);
}
// Pop one person out of *ps.
Person *PersonSetPop(PersonSet *ps) {
  assert(!PersonSetIsEmpty(ps));
  // It is easiest to pop and return the person in the first position!
  return ListRemoveHead(ps->persons);
}

// Remove the person with given id from *ps, and return it.
// If no such person is found, return NULL and leave set untouched.
Person *PersonSetRemove(PersonSet *ps, int id) {
  // You may call search here!
  if(search(ps,id) == 0){
    return ListRemoveCurrent(ps->persons);
  }
  return NULL;
  
}

// Get the person with given id of *ps.
// return NULL if it is not in the set.
Person *PersonSetGet(const PersonSet *ps, int id) {
  // You may call search here!
  if(search(ps,id) >= 0){
    return ListGetCurrentItem(ps->persons);
  }
  return NULL;
}

// Return true (!= 0) if set contains person wiht given id, false otherwise.
int PersonSetContains(const PersonSet *ps, int id) {
  return search(ps, id) >= 0;
}

// Return a NEW PersonSet with the union of *ps1 and *ps2.
// NOTE: memory is allocated.  Client must call PersonSetDestroy!
PersonSet *PersonSetUnion(const PersonSet *ps1, const PersonSet *ps2) {
  PersonSet *ps = PersonSetCreate();

  // Merge the two sorted lists (similar to mergesort).

  ListMoveToHead(ps1->persons);
  ListMoveToHead(ps2->persons);

  int size1 = ListGetSize(ps1->persons);
  int size2 = ListGetSize(ps2->persons);

  int pos = 0;
  while(pos < size1 || pos < size2){
    if(pos < size1){
      Person* p = (Person*)ListGetCurrentItem(ps1->persons);
      ListInsert(ps->persons,p);
      ListMoveToNext(ps1->persons);
    }
    if(pos < size2){
      Person* p = (Person*)ListGetCurrentItem(ps2->persons);
      ListInsert(ps->persons,p);
      ListMoveToNext(ps2->persons);
    }
    pos++;
  }  
  return ps;
}

// Return a NEW PersonSet with the intersection of *ps1 and *ps2.
// NOTE: memory is allocated.  Client must call PersonSetDestroy!
PersonSet *PersonSetIntersection(const PersonSet *ps1, const PersonSet *ps2) {
  PersonSet *ps = PersonSetCreate();

  ListMoveToHead(ps1->persons);
  int size = ListGetSize(ps1->persons);
  
  for(int pos = 0;pos<size;pos++){
    Person* p = (Person*)ListGetCurrentItem(ps1->persons);
    if(ListSearch(ps2->persons,p) >= 0){
      ListInsert(ps->persons,p);
    }
    ListMoveToNext(ps1->persons);
  }
  return ps;
}

// Return a NEW PersonSet with the set difference of *ps1 and *ps2.
// NOTE: memory is allocated.  Client must call PersonSetDestroy!
PersonSet *PersonSetDifference(const PersonSet *ps1, const PersonSet *ps2) {
  PersonSet *ps = PersonSetCreate();

  ListMoveToHead(ps1->persons);
  int size = ListGetSize(ps1->persons);
  
  for(int pos = 0;pos<size;pos++){
    Person* p = (Person*)ListGetCurrentItem(ps1->persons);
    if(ListSearch(ps2->persons,p) < 0){
      ListInsert(ps->persons,p);
    }
    ListMoveToNext(ps1->persons);
  }
  return ps;
}

// Return true iff *ps1 is a subset of *ps2.
int PersonSetIsSubset(const PersonSet *ps1, const PersonSet *ps2) {
  ListMoveToHead(ps1->persons);
  int size = ListGetSize(ps1->persons);
  
  for(int pos = 0;pos<size;pos++){
    Person* p = (Person*)ListGetCurrentItem(ps1->persons);
    if(ListSearch(ps2->persons,p) < 0){
      return 0;
    }
    ListMoveToNext(ps1->persons);
  }
  return 1;
}

// Return true if the two sets contain exactly the same elements.
int PersonSetEquals(const PersonSet *ps1, const PersonSet *ps2) {
  // You may call PersonSetIsSubset here!
  int size1 = ListGetSize(ps1->persons);
  int size2 = ListGetSize(ps2->persons);

  if((size1 == size2) && PersonSetIsSubset(ps1,ps2)){
    return 1;
  }
  return 0;
}
