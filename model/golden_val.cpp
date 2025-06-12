#include <iostream>
#include <string>
#include<math.h>
#include <fstream>
using namespace std;
 
//Converts decimal to binary output
string toBinary(unsigned int n, unsigned int m)
{
    if (m == 0) {
        return "";
    }
 
    return toBinary(n / 2, m-1) + to_string(n % 2);
}

//changes the endianess, splits it into 2 halves and comparing them
//This models the comparator, i.e circuit under test CUT
unsigned int CUT (unsigned int &seed, unsigned int &width){
    unsigned int mask = pow(2,width/2)-1;
    unsigned int mask1 = pow(2,width)-1;
    unsigned int lower = 0;
    unsigned int temp;
    temp = seed;
    for (int i = 0; i < width; ++i){

        lower |= ((mask1&(mask1>>i)) & (temp << ((width)-i-1)));
        temp = temp >> 1;
         
    }
    //std::cout << "-"<<"lower "<<toBinary(lower,width);
   
    if ((lower>>(width/2)) > (lower&mask)){
        return 2;
    }
    else if ((lower>>(width/2)) < (lower&mask)){
        return 4;
    }
    else{
        return 1;
    }
}
// This models the MISR that generates the signature
unsigned int MISR (unsigned int seed, unsigned int M1, unsigned int &width, unsigned int *A){
    
    unsigned int updated_seed = 0;
    unsigned int temp;
        
    for (int j = 0; j < width; ++j){
        //Performs the AND operation of seed and row of matrix A
        temp = seed & A[j];
        //This for loop performs xor operations on the resultant value from AND operation
        for (int k = 0; k < width - 1; ++k){            
            temp = (temp >> 1) ^ (temp & 1);       
            
        }
        updated_seed |= temp << (width-j-1);       
        
    }
    //Updates the seed
    // (((M1&4)<<3) | ((M1&2)<<5) | ((M1&1)<<7)) models the connections of the outputs of CUT to MISR
    seed = updated_seed ^ (((M1&4)<<3) | ((M1&2)<<5) | ((M1&1)<<7));
    return seed;
    
}

void print_matrix_A(unsigned int *A, unsigned int *n){
    for (int i = 0; i < n[0]; ++i){
        std::cout << toBinary(A[i],n[0])<<"\n";
    }
    
    std::cout <<"\n";

}

int main() {
    
    //Primary polynomial
    //n[0] degree of polynomial
    unsigned int n[] = {8,6,5,1,0};
    unsigned int seed = pow(2,n[0])-1;              //Initial seed to LFSR sets all bits to 1
    unsigned int updated_seed = 0;
    unsigned int MISR_seed = 0;                     //Initial seed of MISR set all bits to zero
    unsigned int temp, CUT_val, signature, M1;
    unsigned int updated_MISR_seed = 0;    
    unsigned int pos;
    
    unsigned int A[n[0]];

    ofstream file ("golden_val_file.txt");
    //Creating the A matric from the polynomial
    for(int i = sizeof(A) / sizeof(A[0]); i > 0; --i){
        
        A[i-1] = 1 << sizeof(A) / sizeof(A[0]) - (i-1);
        if (A[i-1] > (1<<(n[0]-1))){
            A[i-1] = 0;
            
        }
    }
    
    for (int i = 1; i < sizeof(n) / sizeof(n[0]); ++i){
        pos = n[i];
        A[pos] = A[pos] + 1;
    }     
    
    //Prints the A matrix 
    print_matrix_A(A, n);
    
    std::cout << "\n- "<< "PRPG" <<"\t"<< "comparator"<<"\t"<< "MISR input"<<"\t"<< "Signature";    

    CUT_val = CUT (seed, n[0]);
    M1 = (((CUT_val&4)<<3) | ((CUT_val&2)<<5) | ((CUT_val&1)<<7));
    updated_MISR_seed = MISR (MISR_seed, CUT_val, n[0], A);
    std::cout << "\n- "<< toBinary(seed,n[0]) <<"\t"<< toBinary(CUT_val,3)<<"\t"<< toBinary(M1,n[0])<<"\t"<< toBinary(MISR_seed,n[0]);
    file<< toBinary(MISR_seed,n[0]);
    MISR_seed = updated_MISR_seed;
    
    for (int i = 0; i < 10; ++i){

        file<< "\n";

        //Implementing the LFSR
        updated_seed = 0;
        
        for (int j = 0; j < n[0]; ++j){
            //And operation with seed and A matrix
            temp = seed & A[j];
            
            //XOR operation of the resultant i.e xor bits of temp
            for (int k = 0; k < n[0] - 1; ++k){
                temp = (temp >> 1) ^ (temp & 1);
            }            
            updated_seed |= temp << (n[0]-j-1);
            
        }
        
        //Generated LFSR output
        //bBecomes the new seed for the next pattern
        seed = updated_seed;
        //To extract the CUT value
        CUT_val = CUT (seed, n[0]);
        //The CUT is a 3 bit output
        //M1 represents where those 3 bits that has been extended to 8 bits that will go into the MISR which has 8 inputs        
        M1 = (((CUT_val&4)<<3) | ((CUT_val&2)<<5) | ((CUT_val&1)<<7));
        updated_MISR_seed = MISR (updated_MISR_seed, CUT_val, n[0], A);
        std::cout << "\n- "<< toBinary(updated_seed,n[0]) <<"\t"<< toBinary(CUT_val,3)<<"\t"<< toBinary(M1,n[0])<<"\t"<< toBinary(MISR_seed,n[0]);
        file<< toBinary(MISR_seed,n[0]);
        MISR_seed = updated_MISR_seed;
        
    }

    file.close();
    

    return 0;
}
