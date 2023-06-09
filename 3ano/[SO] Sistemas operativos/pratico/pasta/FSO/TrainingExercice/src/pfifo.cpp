#include <dbc.h>
#include <string.h>
#include "pfifo.h"

//#include "process.h"
	
	//para pergunta a)

	#include "thread.h"
	/** \brief locking flag which warrants mutual exclusion inside the monitor */
	static pthread_mutex_t accessCR = PTHREAD_MUTEX_INITIALIZER;
	/** \brief condition variable for checking fifo fullness and emptiness */
	static pthread_cond_t fifoNotFull = PTHREAD_COND_INITIALIZER;
	static pthread_cond_t fifoNotEmpty = PTHREAD_COND_INITIALIZER;

/* changes may be required to this function */
void init_pfifo(PriorityFIFO* pfifo)
{
   require (pfifo != NULL, "NULL pointer to FIFO");   // a false value indicates a program error
		//a)
		mutex_lock(&accessCR);
   memset(pfifo->array, 0, sizeof(pfifo->array));
   pfifo->inp = pfifo->out = pfifo->cnt = 0;	//queue tail = queue head = 0 
		//a)
		cond_broadcast(&fifoNotFull);
		mutex_unlock(&accessCR);
}

/* --------------------------------------- */

int empty_pfifo(PriorityFIFO* pfifo)
{
   require (pfifo != NULL, "NULL pointer to FIFO");   // a false value indicates a program error

   return pfifo->cnt == 0;
}

/* --------------------------------------- */

int full_pfifo(PriorityFIFO* pfifo)	//devolve se o fifo está cheio ou não
{
   require (pfifo != NULL, "NULL pointer to FIFO");   // a false value indicates a program error

   return pfifo->cnt == FIFO_MAXSIZE;
}

/* --------------------------------------- */

/* changes may be required to this function */
void insert_pfifo(PriorityFIFO* pfifo, uint32_t id, uint32_t priority)
{
   require (pfifo != NULL, "NULL pointer to FIFO");   // a false value indicates a program error
   require (id <= MAX_ID, "invalid id");              // a false value indicates a program error
   require (priority > 0 && priority <= MAX_PRIORITY, "invalid priority value");  // a false value indicates a program error
   require (!full_pfifo(pfifo), "full FIFO");         // in a shared fifo, it may not result from a program error!

   //printf("[insert_pfifo] value=%d, priority=%d, pfifo->inp=%d, pfifo->out=%d\n", id, priority, pfifo->inp, pfifo->out);
		//a)
		mutex_lock(&accessCR);
		/* wait while fifo is full */
		while (full_pfifo(pfifo))			//espera que outras trheads façam com que o fifo esvazie
		{
			cond_wait(&fifoNotFull, &accessCR); 
		}
   uint32_t idx = pfifo->inp;
   uint32_t prev = (idx + FIFO_MAXSIZE - 1) % FIFO_MAXSIZE;
   while((idx != pfifo->out) && (pfifo->array[prev].priority > priority))
   {
      //printf("[insert_pfifo] idx=%d, prev=%d\n", idx, prev);
      pfifo->array[idx] = pfifo->array[prev];
      idx = prev;
      prev = (idx + FIFO_MAXSIZE - 1) % FIFO_MAXSIZE;
   }
   //printf("[insert_pfifo] idx=%d, prev=%d\n", idx, prev);
   pfifo->array[idx].id = id;
   pfifo->array[idx].priority = priority;
   pfifo->inp = (pfifo->inp + 1) % FIFO_MAXSIZE;
   pfifo->cnt++;
		cond_broadcast(&fifoNotEmpty);	//notificação geral para todas as outras threads de que o fifo não está vazio
		mutex_unlock(&accessCR);
   //printf("[insert_pfifo] pfifo->inp=%d, pfifo->out=%d\n", pfifo->inp, pfifo->out);
}

/* --------------------------------------- */

/* changes may be required to this function */
uint32_t retrieve_pfifo(PriorityFIFO* pfifo)
{
   require (pfifo != NULL, "NULL pointer to FIFO");   // a false value indicates a program error
   require (!empty_pfifo(pfifo), "empty FIFO");       // in a shared fifo, it may not result from a program error!
		check_valid_id(pfifo->array[pfifo->out].id);
		check_valid_priority(pfifo->array[pfifo->out].priority);
		
		//a)
		mutex_lock(&accessCR);
		
		 /* wait while fifo is empty */
		while ( empty_pfifo(pfifo))
		{
			cond_wait(&fifoNotEmpty, &accessCR); 
		}
 

   uint32_t result = pfifo->array[pfifo->out].id;
   pfifo->array[pfifo->out].id = INVALID_ID;
   pfifo->array[pfifo->out].priority = INVALID_PRIORITY;
   pfifo->out = (pfifo->out + 1) % FIFO_MAXSIZE;
   pfifo->cnt--;

   // update priority of all remaing elements (increase priority by one)
   uint32_t idx = pfifo->out;
   for(uint32_t i = 1; i <= pfifo->cnt; i++)
   {
      if (pfifo->array[idx].priority > 1 && pfifo->array[idx].priority != INVALID_PRIORITY)
         pfifo->array[idx].priority--;
      idx = (idx + 1) % FIFO_MAXSIZE;
   }
		//a
		cond_broadcast(&fifoNotFull);		//como eu tirei um vai avisar toda a gente q ele não está cheio
		mutex_unlock(&accessCR);
   return result;
}

/* --------------------------------------- */

/* changes may be required to this function */
void print_pfifo(PriorityFIFO* pfifo)
{
   require (pfifo != NULL, "NULL pointer to FIFO");   // a false value indicates a program error
		
	uint32_t idx = pfifo->out;
		//a
		//mutex_lock(&accessCR);
  
   for(uint32_t i = 1; i <= pfifo->cnt; i++)
   {
      check_valid_id(pfifo->array[pfifo->out].id);
      check_valid_priority(pfifo->array[pfifo->out].priority);
      printf("[%02d] value = %d, priority = %d\n", i, pfifo->array[idx].id, pfifo->array[idx].priority);
      idx = (idx + 1) % FIFO_MAXSIZE;
   }
		//a)
		//mutex_unlock(&accessCR);
}

