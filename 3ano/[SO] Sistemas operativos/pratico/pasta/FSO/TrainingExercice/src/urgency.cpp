/**
 * @file
 *
 * \brief A hospital pediatric urgency with a Manchester triage system.
 */

#include  <stdio.h>
#include  <stdlib.h>
#include  <string.h>
#include  <libgen.h>
#include  <unistd.h>
#include  <sys/wait.h>
#include  <sys/types.h>
#include  <thread.h>
#include  <math.h>
#include  <stdint.h>
#include  <signal.h>
#include  <utils.h>
#include  "settings.h"
#include  "pfifo.h"

#include "thread.h"
//#include "process.h"

#include <iostream>

#define USAGE "Synopsis: %s [options]\n" \
   "\t----------+-------------------------------------------\n" \
   "\t  Option  |          Description                      \n" \
   "\t----------+-------------------------------------------\n" \
   "\t -p num   | number of patients (dfl: 4)               \n" \
   "\t -n num   | number of nurses (dfl: 1)                 \n" \
   "\t -d num   | number of doctors (dfl: 1)                \n" \
   "\t -h       | this help                                 \n" \
   "\t----------+-------------------------------------------\n"
	//a)
	static pthread_mutex_t accessCR = PTHREAD_MUTEX_INITIALIZER;
	static pthread_cond_t vcond[MAX_PATIENTS];		//é static ou não?
/**
 * \brief Patient data structure
 */
 
typedef struct
{
   char name[MAX_NAME+1];
   int done; // 0: waiting for consultation; 1: consultation finished
} Patient;

typedef struct
{
    int num_patients;
    Patient all_patients[MAX_PATIENTS];
    PriorityFIFO triage_queue;		//estrutura declarada no ficheiro pfifo.h
    PriorityFIFO doctor_queue;
} HospitalData;

typedef struct
{
    unsigned int id;      ///< thread id
    unsigned int niter;   ///< number of iterations
} ARGV;					//para a main gerir os varios pacientes

HospitalData * hd = NULL;

/**
 *  \brief patient verification test
 */
#define check_valid_patient(id) do { check_valid_id(id); check_valid_name(hd->all_patients[id].name); } while(0)

int random_manchester_triage_priority();
void new_patient(Patient* patient); // initializes a new patient
void random_wait();

/* ************************************************* */

/* changes may be required to this function */
void init_simulation(uint32_t np)
{
   printf("Initializing simulation\n");
   //cria o endereço de memoria hd
   hd = (HospitalData*)mem_alloc(sizeof(HospitalData)); // mem_alloc is a malloc with NULL pointer verification
   memset(hd, 0, sizeof(HospitalData));
   hd->num_patients = np;			//define o numero de pacientes para fazer a simulação
   //iniciar fifos
   init_pfifo(&hd->triage_queue);
   init_pfifo(&hd->doctor_queue);
}

/* ************************************************* */

void nurse_iteration()
{
   printf("\e[34;01mNurse: get next patient\e[0m\n");
   uint32_t patient = retrieve_pfifo(&hd->triage_queue);
   check_valid_patient(patient);
   printf("\e[34;01mNurse: evaluate patient %u priority\e[0m\n", patient);
   uint32_t priority = random_manchester_triage_priority();
   printf("\e[34;01mNurse: add patient %u with priority %u to doctor queue\e[0m\n", patient, priority);
   insert_pfifo(&hd->doctor_queue, patient, priority);
}
//c)
void *nurse(void *argp)
{
	ARGV* argv = (ARGV*)argp;
	for (unsigned int i = 0; i < argv->niter; i++)
	{
		nurse_iteration(); 
	}
	return NULL;
}
/* ************************************************* */

void doctor_iteration()
{
   printf("\e[32;01mDoctor: get next patient\e[0m\n");
   uint32_t patient = retrieve_pfifo(&hd->doctor_queue);
   check_valid_patient(patient);
   printf("\e[32;01mDoctor: treat patient %u\e[0m\n", patient);
   random_wait();
   printf("\e[32;01mDoctor: patient %u treated\e[0m\n", patient);
   hd->all_patients[patient].done = 1;
}
void *doctor(void *argp)
{
	ARGV* argv = (ARGV*)argp;
	for (unsigned int i = 0; i < argv->niter; i++)
	{
		doctor_iteration(); 
	}
	return NULL;
}
/* ************************************************* */

void patient_goto_urgency(int id)
{
   new_patient(&hd->all_patients[id]);
   check_valid_name(hd->all_patients[id].name);
   printf("\e[30;01mPatient %s (number %u): get to hospital\e[0m\n", hd->all_patients[id].name, id);
   insert_pfifo(&hd->triage_queue, id, 1); // all elements in triage queue with the same priority!
}

/* changes may be required to this function */
void patient_wait_end_of_consultation(int id)
{	
	
	check_valid_name(hd->all_patients[id].name);
	while (hd->all_patients[id].done==0);
	//mutex_lock(&accessCR);
	//while (hd->all_patients[id].done==0){
	//	cond_wait(&vcond[id],&accessCR);
	//}
	//cond_broadcast(&vcond[id]);
	//mutex_unlock(&accessCR);
	printf("\e[30;01mPatient %s (number %u): health problems treated\e[0m\n", hd->all_patients[id].name, id);
		
}

/* changes are required to this function */
void patient_life(int id)
{
   patient_goto_urgency(id);
   //nurse_iteration();  // to be deleted in concurrent version
   //doctor_iteration(); // to be deleted in concurrent version
   //hd->all_patients[id].done = 0;
   patient_wait_end_of_consultation(id);
   memset(&(hd->all_patients[id]), 0, sizeof(Patient)); // patient finished
}

void *patient(void *argp)
{
	ARGV* argv = (ARGV*)argp;
	
	patient_life(argv->id); 
	
	return NULL;
}
/* ************************************************* */

int main(int argc, char *argv[])
{
   uint32_t npatients = 4;  ///< number of patients
   uint32_t nnurses = 1;    ///< number of triage nurses
   uint32_t ndoctors = 1;   ///< number of doctors

   /* command line processing */
   int option;
   while ((option = getopt(argc, argv, "p:n:d:h")) != -1)
   {
      switch (option)
      {
         case 'p':
            npatients = atoi(optarg);
            if (npatients < 1 || npatients > MAX_PATIENTS)
            {
               fprintf(stderr, "Invalid number of patients!\n");
               return EXIT_FAILURE;
            }
            break;
         case 'n':
            nnurses = atoi(optarg);
            if (nnurses < 1)
            {
               fprintf(stderr, "Invalid number of nurses!\n");
               return EXIT_FAILURE;
            }
            break;
         case 'd':
            ndoctors = atoi(optarg);
            if (ndoctors < 1)
            {
               fprintf(stderr, "Invalid number of doctors!\n");
               return EXIT_FAILURE;
            }
            break;
         case 'h':
            printf(USAGE, basename(argv[0]));
            return EXIT_SUCCESS;
         default:
            fprintf(stderr, "Non valid option!\n");
            fprintf(stderr, USAGE, basename(argv[0]));
            return EXIT_FAILURE;
      }
   }

   /* start random generator */
   srand(getpid());

   /* init simulation */
   init_simulation(npatients);

//launching das threads
	//threads
	pthread_t pthr[npatients];   /* patients*/
    ARGV parg[npatients];        /* patients' args */
    //printf("Launching %d nurses threads, each performing %d iterations\n", nthr, niter);
    
    for (unsigned int i = 0; i < npatients; i++)
    {
        parg[i].id = i;
        parg[i].niter = npatients;
        thread_create(&pthr[i], NULL, patient, &parg[i]);
    }
    
	pthread_t nursethr[nnurses];   /* nurse */
    ARGV narg[nnurses];        /* nurses' args */
    //printf("Launching %d nurses threads, each performing %d iterations\n", nthr, niter);
   
    for (unsigned int i = 0; i < nnurses; i++)
    {
        narg[i].id = i;
        narg[i].niter = npatients;
        thread_create(&nursethr[i], NULL, nurse, &narg[i]);
    }
    
    pthread_t dthr[ndoctors];   /* doctor*/
    ARGV darg[ndoctors];        /* doctor' args */
    //printf("Launching %d nurses threads, each performing %d iterations\n", nthr, niter);
    
    for (unsigned int i = 0; i < ndoctors; i++)
    {
        darg[i].id = i;
        darg[i].niter = npatients;
        thread_create(&dthr[i], NULL, doctor, &darg[i]);
    }
    
	
   /* dummy code to show a very simple sequential behavior
   for(uint32_t i = 0; i < npatients; i++)
   {
      printf("\n");
      random_wait(); // random wait for patience creation
      patient_life(i);
   }
	 */
	  for (unsigned int i = 0; i < npatients; i++)
    {
        thread_join(pthr[i], NULL);
        printf("Patients thread %d has terminated\n", i);
    }
	 for (unsigned int i = 0; i < nnurses; i++)
    {
        thread_join(nursethr[i], NULL);
        printf("Nurse thread %d has terminated\n", i);
    }
    for (unsigned int i = 0; i < ndoctors; i++)
    {
        thread_join(dthr[i], NULL);
        printf("Doctor thread %d has terminated\n", i);
    }
   return EXIT_SUCCESS;
}


/* YOU MAY IGNORE THE FOLLOWING CODE */

int random_manchester_triage_priority()
{
   int result;
   int perc = (int)(100*(double)rand()/((double)RAND_MAX)); // in [0;100]
   if (perc < 10)
      result = RED;
   else if (perc < 30)
      result = ORANGE;
   else if (perc < 50)
      result = YELLOW;
   else if (perc < 75)
      result = GREEN;
   else
      result = BLUE;
   return result;
}

static char **names = (char *[]) {"Ana", "Miguel", "Luis", "Joao", "Artur", "Maria", "Luisa", "Mario", "Augusto", "Antonio", "Jose", "Alice", "Almerindo", "Gustavo", "Paulo", "Paula", NULL};

char* random_name()
{
   static int names_len = 0;
   if (names_len == 0)
   {
      for(names_len = 0; names[names_len] != NULL; names_len++)
         ;
   }

   return names[(int)(names_len*(double)rand()/((double)RAND_MAX+1))];
}

void new_patient(Patient* patient)
{
   strcpy(patient->name, random_name());
   patient->done = 0;
}

void random_wait()
{
   usleep((useconds_t)(MAX_WAIT*(double)rand()/(double)RAND_MAX));
}

