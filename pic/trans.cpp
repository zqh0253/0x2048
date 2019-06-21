#include <fstream>
#include "bmp.h"
#include <iostream>
#include <string>
using namespace std;
//string s[12]={"e2","e4","e8","e16","e32","e64","e128","e256","e512","e1024","e2048"};
string s[1] = {"background"}; 
int main()
{
    U8 bitCountPerPix;
    U32 width, height;
    int kk=1;
    for (int i=0; i<1; i++){
    U8 *pdata = GetBmpData24(&bitCountPerPix, &width, &height,( s[i]+string(".bmp")).c_str());
    printf("%d %d", width, height); 
    ofstream fout (string("PIC_COE_FILE/")+s[i]+string(".coe"));
    int x, y;
    U32 bmppitch = ((width*bitCountPerPix + 31) >> 5) << 2;
    U8 BytePerPix = bitCountPerPix >> 3;
    U32 pitch = width * BytePerPix;
    U32 originpitch = width * BytePerPix;
    fout << "memory_initialization_radix=16;" << endl;
    fout << "memory_initialization_vector=" << endl;
    for(y = 0; y < height; y++) {
        for(x = 0; x < width; x++) {
            int data = pdata[y*originpitch+x*BytePerPix+2] / 16;
            char tmp[4];
            sprintf(tmp, "%01X", data);
            fout << tmp;
            data = pdata[y*originpitch+x*BytePerPix+1] / 16;
            sprintf(tmp, "%01X", data);
            fout << tmp;
            data = pdata[y*originpitch+x*BytePerPix+0] / 16;
            sprintf(tmp, "%01X", data);
            fout << tmp;
            fout << ", ";
        }

    } 
    free(pdata);   
	}
    return 0;
}
