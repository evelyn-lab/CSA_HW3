#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
double mabs(double x){ return (x < 0)? -x : x; }
double read_from_file(char* inpath) {
    FILE *input = fopen(inpath, "r");
    if (input) { 
        double num;
        fscanf(input, "%lf", &num);
        fclose(input);
        return num;
    } else {
        perror("Error ");
    }
}
void* calculate_root(double num, char* outpath) {
    register double eps asm ("r12") = 0.0005;
    register double root asm ("r13") = num / 3;   
    register double rn asm ("r15") = num;
    register int i asm ("r14");
    while(mabs(root - rn) >= eps){
        rn = num;
        for(i = 1; i < 3; i++){
            rn = rn / root;
        }
        root = 0.5 * ( rn + root);
    }
    FILE *output = fopen(outpath, "w");
    if (output) { 
        register double rounded asm ("r15") = round(root);
        if ( pow(rounded,3) == num * 1.0) {
            fprintf(output, "root = %lf\n", rounded);
        } else {
            fprintf(output, "root = %lf\n", root);
        }
    } else {
        perror("Error ");
    }
}
int main(int argc, char** argv) {
    double num = read_from_file(argv[1]);
    calculate_root(num, argv[2]);
    return 0;
}
