#include <stdio.h>
char in_name[10];
int main(){
    do{
        printf("please enter the name of student to search:\n");
    }while(!scanf("%s", in_name));
    if(in_name[0] == 0){
       goto terminate;
    }
    printf("processing\n");
terminate:
    return 0;
}