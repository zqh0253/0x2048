#include <fstream>
#include "bmp.h"
#include <iostream>
#include <string>
using namespace std;
//string s[12]={"2","4","8","16","32","64","128","256","512","1024"};
string s[1] = {"whi"}; 
int main()
{
    U8 bitCountPerPix;
    U32 width, height;
    int kk=1;
    for (int i=0; i<1; i++){
    U8 *pdata = GetBmpData24(&bitCountPerPix, &width, &height,( s[i]+string(".bmp")).c_str());
    printf("%d %d", width, height); 
    ofstream fout (string("file/")+s[i]+string(".coe"));
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
