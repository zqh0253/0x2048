#include<bits/stdc++.h>
using namespace std;
int main(){
	FILE *f = fopen("COE.coe", "a+");
	fprintf(f, "D0000000, ");
	fprintf(f, "FF0FFFFF, ");
	fprintf(f, "01000000, ");
	fprintf(f, "000007FC, ");
	fprintf(f, "000F0000, ");
	fprintf(f, "0000F000, ");
	
	int c = 0;
	for (int i = 256; i < 512; i += 4){
		int len = rand() % 7 + 3;
		int t = rand() % (13 - len + 1);
		int upper = t, down = 14 - (13 - len - t);
		int g = c ? 15 : 0;
		int b = !c ? 15 : 0;
		for (int k = 0; k < 4; k++)
			fprintf(f, "00F%X%X0%X%X, ", upper, down, g, b);
		c ^= 1;
	}
}
