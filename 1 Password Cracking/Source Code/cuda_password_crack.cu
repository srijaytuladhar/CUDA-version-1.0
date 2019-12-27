#include <stdio.h>
#include <cuda_runtime_api.h>
#include <time.h>

/****************************************************************************

     Compilation Code:
     nvcc -o cuda_password_crack cuda_password_crack.cu
  
*****************************************************************************/


__device__ int is_a_match(char *attempt) {
  char plain_password1[] = "BV7842";
  char plain_password2[] = "ES2107";
  char plain_password3[] = "HR2332";
  char plain_password4[] = "RB9669";

  char *a = attempt;
  char *b = attempt;
  char *c = attempt;
  char *d = attempt;
  char *p1 = plain_password1;
  char *p2 = plain_password2;
  char *p3 = plain_password3;
  char *p4 = plain_password4;

  while(*a == *p1) {
   if(*a == '\0')
    {
    printf("%s\n",plain_password1);
      break;
    }

    a++;
    p1++;
  }
    
  while(*b == *p2) {
   if(*b == '\0')
    {
    printf("%s\n",plain_password2);
      break;
}

    b++;
    p2++;
  }

  while(*c == *p3) {
   if(*c == '\0')
    {
    printf("%s\n",plain_password3);
      break;
    }

    c++;
    p3++;
  }

  while(*d == *p4) {
   if(*d == '\0')
    {
    printf("%s",plain_password4);
      return 1;
    }

    d++;
    p4++;
  }
  return 0;

}
/****************************************************************************
  The kernel function assume that there will be only one thread and uses
  nested loops to generate all possible passwords and test whether they match
  the hidden password.
*****************************************************************************/

__global__ void  kernel() {
char k1,k2,k3,k4;
 
  char password[7];
  password[6] = '\0';

int i = blockIdx.x+65;
int j = threadIdx.x+65;
char firstValue = i;
char secondValue = j;
    
password[0] = firstValue;
password[1] = secondValue;
    for(k1='0'; k1<='9'; k1++){
      for(k2='0'; k2<='9'; k2++){
        for(k3='0'; k3<='9'; k3++){
          for(k4='0'; k4<='9'; k4++){
            password[2] = k1;
            password[3] = k2;
            password[4] = k3;
            password[5] = k4;
          if(is_a_match(password)) {
        //printf("Success");
          }
             else {
         //printf("tried: %s\n", password);          
            }
          }
        } 
      }
   }
}
int time_difference(struct timespec *start,
                    struct timespec *finish,
                    long long int *difference) {
  long long int ds =  finish->tv_sec - start->tv_sec;
  long long int dn =  finish->tv_nsec - start->tv_nsec;

  if(dn < 0 ) {
    ds--;
    dn += 1000000000;
  }
  *difference = ds * 1000000000 + dn;
  return !(*difference > 0);
}


int main() {

  struct  timespec start, finish;
  long long int time_elapsed;
  clock_gettime(CLOCK_MONOTONIC, &start);
  printf("\n===============================================================================\n");
  printf("!! MATCHED PASSWORD !! \n");
  printf("===============================================================================\n\n");
  kernel <<<26,26>>>();
  cudaThreadSynchronize();

  
  clock_gettime(CLOCK_MONOTONIC, &finish);
  time_difference(&start, &finish, &time_elapsed);
  printf("\n\n===============================================================================\n");
  printf("!! TIME TAKEN FOR EXECUTION !! \n");
  printf("===============================================================================\n\n");
  printf("Nanoseconds: %lld\n", time_elapsed); 
  printf("Seconds: %0.9lf\n", ((time_elapsed/1.0e9))); 
  printf("Minutes: %0.4lf\n", ((time_elapsed/1.0e9)/60));
  printf("Hours: %0.2lf\n\n", ((time_elapsed/1.0e9)/3600)); 
  

  return 0;
}



