#ifndef _BLUE_BITMAP_H_
#define _BLUE_BITMAP_H_

#pragma pack(push, 1)
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
typedef unsigned char  U8;
typedef unsigned short U16;
typedef unsigned int   U32;

typedef struct tagBITMAPFILEHEADER {
    U16 bfType;
    U32 bfSize;
    U16 bfReserved1;
    U16 bfReserved2;
    U32 bfOffBits;
} BITMAPFILEHEADER;

typedef struct tagBITMAPINFOHEADER {
    U32 biSize;
    U32 biWidth;
    U32 biHeight;
    U16 biPlanes;
    U16 biBitCount;
    U32 biCompression;
    U32 biSizeImage;
    U32 biXPelsPerMeter;
    U32 biYPelsPerMeter;
    U32 biClrUsed;
    U32 biClrImportant;
} BITMAPINFOHEADER;

typedef struct tagRGBQUAD {
    U8 rgbBlue;
    U8 rgbGreen;
    U8 rgbRed;
    U8 rgbReserved;
} RGBQUAD;

typedef struct tagBITMAPINFO {
    BITMAPINFOHEADER bmiHeader;
    RGBQUAD bmiColors[1];
} BITMAPINFO;


typedef struct tagBITMAP {
    BITMAPFILEHEADER bfHeader;
    BITMAPINFO biInfo;
}BITMAPFILE;


int GenerateBmpFile(U8 *pData, U8 bitCountPerPix, U32 width, U32 height, const char *filename)
{
    FILE *fp = fopen(filename, "wb");
    if (!fp) {
        printf("fopen failed : %s, %d\n", __FILE__, __LINE__);
        return 0;
    }
    
    U32 bmppitch = ((width*bitCountPerPix + 31) >> 5) << 2;
    U32 filesize = bmppitch*height;
    
    BITMAPFILE bmpfile;
    
    bmpfile.bfHeader.bfType = 0x4D42;
    bmpfile.bfHeader.bfSize = filesize + sizeof(BITMAPFILEHEADER) + sizeof(BITMAPINFOHEADER);
    bmpfile.bfHeader.bfReserved1 = 0;
    bmpfile.bfHeader.bfReserved2 = 0;
    bmpfile.bfHeader.bfOffBits = sizeof(BITMAPFILEHEADER) + sizeof(BITMAPINFOHEADER);
    
    bmpfile.biInfo.bmiHeader.biSize = sizeof(BITMAPINFOHEADER);
    bmpfile.biInfo.bmiHeader.biWidth = width;
    bmpfile.biInfo.bmiHeader.biHeight = height;
    bmpfile.biInfo.bmiHeader.biPlanes = 1;
    bmpfile.biInfo.bmiHeader.biBitCount = bitCountPerPix;
    bmpfile.biInfo.bmiHeader.biCompression = 0;
    bmpfile.biInfo.bmiHeader.biSizeImage = 0;
    bmpfile.biInfo.bmiHeader.biXPelsPerMeter = 0;
    bmpfile.biInfo.bmiHeader.biYPelsPerMeter = 0;
    bmpfile.biInfo.bmiHeader.biClrUsed = 0;
    bmpfile.biInfo.bmiHeader.biClrImportant = 0;
    
    fwrite(&(bmpfile.bfHeader), sizeof(BITMAPFILEHEADER), 1, fp);
    fwrite(&(bmpfile.biInfo.bmiHeader), sizeof(BITMAPINFOHEADER), 1, fp);
    
    U8 *pEachLinBuf = (U8*)malloc(bmppitch);
    memset(pEachLinBuf, 0, bmppitch);
    U8 BytePerPix = bitCountPerPix >> 3;
    U32 pitch = width * BytePerPix;
    if (pEachLinBuf) {
        int h,w;
        for(h = height-1; h >= 0; h--) {
            for(w = 0; w < width; w++) {
                pEachLinBuf[w*BytePerPix+0] = pData[h*pitch + w*BytePerPix + 0];
                pEachLinBuf[w*BytePerPix+1] = pData[h*pitch + w*BytePerPix + 1];
                pEachLinBuf[w*BytePerPix+2] = pData[h*pitch + w*BytePerPix + 2];
            }
            fwrite(pEachLinBuf, bmppitch, 1, fp);
        }
        free(pEachLinBuf);
    }
    
    fclose(fp);
    return 1;
}

int GenerateBmpFileBit8(U8 *pData, U32 width, U32 height, const char *filename) 
{
    int bitCountPerPix = 8;
    FILE *fp = fopen(filename, "wb");
    if(!fp) {
        printf("fopen failed : %s, %d\n", __FILE__, __LINE__);
        return 0;
    }

    U32 bmppitch = ((width*bitCountPerPix + 31) >> 5) << 2;
    U32 filesize = bmppitch*height;
    RGBQUAD rgb[256];
    for(int i=0;i<256;i++) {
        rgb[i].rgbBlue = i;
        rgb[i].rgbGreen = i;
        rgb[i].rgbRed = i;
        rgb[i].rgbReserved = 0;
    }

    BITMAPFILE bmpfile;
    bmpfile.bfHeader.bfType = 0x4D42;
    bmpfile.bfHeader.bfSize = filesize + sizeof(BITMAPFILEHEADER) + sizeof(BITMAPINFOHEADER) + sizeof(rgb);
    bmpfile.bfHeader.bfReserved1 = 0;
    bmpfile.bfHeader.bfReserved2 = 0;
    bmpfile.bfHeader.bfOffBits = sizeof(BITMAPFILEHEADER) + sizeof(BITMAPINFOHEADER)+sizeof(rgb);
    
    bmpfile.biInfo.bmiHeader.biSize = sizeof(BITMAPINFOHEADER);
    bmpfile.biInfo.bmiHeader.biWidth = width;
    bmpfile.biInfo.bmiHeader.biHeight = height;
    bmpfile.biInfo.bmiHeader.biPlanes = 1;
    bmpfile.biInfo.bmiHeader.biBitCount = bitCountPerPix;
    bmpfile.biInfo.bmiHeader.biCompression = 0;
    bmpfile.biInfo.bmiHeader.biSizeImage = 0;
    bmpfile.biInfo.bmiHeader.biXPelsPerMeter = 0;
    bmpfile.biInfo.bmiHeader.biYPelsPerMeter = 0;
    bmpfile.biInfo.bmiHeader.biClrUsed = 0;
    bmpfile.biInfo.bmiHeader.biClrImportant = 0;

    fwrite(&(bmpfile.bfHeader), sizeof(BITMAPFILEHEADER), 1, fp);
    fwrite(&(bmpfile.biInfo.bmiHeader), sizeof(BITMAPINFOHEADER), 1, fp);
    fwrite(rgb,sizeof(rgb),1,fp);
    U8 *pEachLinBuf = (U8 *)malloc(bmppitch);
    memset(pEachLinBuf, 0, bmppitch);

    U8 originBytePerPix = 8 >> 3;
    U32 originpitch = width * originBytePerPix;
    if (pEachLinBuf) {
        int h,w;
        for(h = height-1; h >= 0; h--) {
            for(w = 0; w < width; w++) {
                pEachLinBuf[w] = pData[h*originpitch + w*originBytePerPix];
            }
            fwrite(pEachLinBuf, bmppitch, 1, fp);
        }
        free(pEachLinBuf);
    }
    fclose(fp);
    return 1;
}


U8* GetBmpData24(U8 *bitCountPerPix, U32 *width, U32 *height, const char* filename)
{
    FILE *pf = fopen(filename, "rb");
    if(!pf) {
        printf("fopen failed : %s, %d\n", __FILE__, __LINE__);
        return NULL;
    }
    
    BITMAPFILE bmpfile;
    fread(&(bmpfile.bfHeader), sizeof(BITMAPFILEHEADER), 1, pf);
    fread(&(bmpfile.biInfo.bmiHeader), sizeof(BITMAPINFOHEADER), 1, pf);
    
    if (bitCountPerPix)
        *bitCountPerPix = bmpfile.biInfo.bmiHeader.biBitCount;

    if (width) 
        *width = bmpfile.biInfo.bmiHeader.biWidth;

    if (height) 
        *height = bmpfile.biInfo.bmiHeader.biHeight;
    
    U32 bmppicth = (((*width)*(*bitCountPerPix) + 31) >> 5) << 2;
    U8 *pdata = (U8*)malloc((*height)*bmppicth);
    
    U8 *pEachLinBuf = (U8*)malloc(bmppicth);
    memset(pEachLinBuf, 0, bmppicth);
    U8 BytePerPix = (*bitCountPerPix) >> 3;
    U32 pitch = (*width) * BytePerPix;
    
    if (pdata && pEachLinBuf) {
        int w, h;
        for (h = (*height) - 1; h >= 0; h--) {
            fread(pEachLinBuf, bmppicth, 1, pf);
            for (w = 0; w < (*width); w++) {
                pdata[h*pitch + w*BytePerPix + 0] = pEachLinBuf[w*BytePerPix+0];
                pdata[h*pitch + w*BytePerPix + 1] = pEachLinBuf[w*BytePerPix+1];
                pdata[h*pitch + w*BytePerPix + 2] = pEachLinBuf[w*BytePerPix+2];
            }
        }
        free(pEachLinBuf);
    }
    fclose(pf);
    return pdata;
}

void FreeBmpData(U8 *pdata)
{
    if (pdata) {
        free(pdata);
        pdata = NULL;
    }
}
int YUV2GRAY(U8 *pData, U8 bitCountPerPix, U32 width, U32 height)
{
    U32 bmppitch = ((width*bitCountPerPix + 31) >> 5) << 2;
    U32 filesize = bmppitch*height;
     U8 *pEachLinBuf = (U8*)malloc(bmppitch);
    memset(pEachLinBuf, 0, bmppitch);
    U8 BytePerPix = bitCountPerPix >> 3;
    U32 pitch = width * BytePerPix;
    if (pEachLinBuf) {
        int h,w;
        for(h = height-1; h >= 0; h--) {
            for(w = 0; w < width; w++) {
                pEachLinBuf[w*BytePerPix+2] = ((66*pData[h*pitch + w*BytePerPix + 2]+129*pData[h*pitch + w*BytePerPix + 1]+25*pData[h*pitch + w*BytePerPix + 0])>>8)+16;
                if(pEachLinBuf[w * BytePerPix + 2]>255) pEachLinBuf[w * BytePerPix + 2]=255;
                if(pEachLinBuf[w * BytePerPix + 2]<0) pEachLinBuf[w * BytePerPix + 2]=0;
                pData[h*pitch + w*BytePerPix + 0] = pEachLinBuf[w*BytePerPix + 2];
                pData[h*pitch + w*BytePerPix + 1] = pEachLinBuf[w*BytePerPix + 2];
                pData[h*pitch + w*BytePerPix + 2] = pEachLinBuf[w*BytePerPix + 2];
            }
        }
        free(pEachLinBuf);
    }
    return 1;
}
int RGB2YUV(U8 *pData, U8 bitCountPerPix, U32 width, U32 height, const char *filename)
{
    FILE *fp = fopen(filename, "wb");
    if (!fp) {
        printf("fopen failed : %s, %d\n", __FILE__, __LINE__);
        return 0;
    }
    
    U32 bmppitch = ((width*bitCountPerPix + 31) >> 5) << 2;
    U32 filesize = bmppitch*height;
    
    BITMAPFILE bmpfile;
    
    bmpfile.bfHeader.bfType = 0x4D42;
    bmpfile.bfHeader.bfSize = filesize + sizeof(BITMAPFILEHEADER) + sizeof(BITMAPINFOHEADER);
    bmpfile.bfHeader.bfReserved1 = 0;
    bmpfile.bfHeader.bfReserved2 = 0;
    bmpfile.bfHeader.bfOffBits = sizeof(BITMAPFILEHEADER) + sizeof(BITMAPINFOHEADER);
    
    bmpfile.biInfo.bmiHeader.biSize = sizeof(BITMAPINFOHEADER);
    bmpfile.biInfo.bmiHeader.biWidth = width;
    bmpfile.biInfo.bmiHeader.biHeight = height;
    bmpfile.biInfo.bmiHeader.biPlanes = 1;
    bmpfile.biInfo.bmiHeader.biBitCount = bitCountPerPix;
    bmpfile.biInfo.bmiHeader.biCompression = 0;
    bmpfile.biInfo.bmiHeader.biSizeImage = 0;
    bmpfile.biInfo.bmiHeader.biXPelsPerMeter = 0;
    bmpfile.biInfo.bmiHeader.biYPelsPerMeter = 0;
    bmpfile.biInfo.bmiHeader.biClrUsed = 0;
    bmpfile.biInfo.bmiHeader.biClrImportant = 0;
    
    fwrite(&(bmpfile.bfHeader), sizeof(BITMAPFILEHEADER), 1, fp);
    fwrite(&(bmpfile.biInfo.bmiHeader), sizeof(BITMAPINFOHEADER), 1, fp);
    
    U8 *pEachLinBuf = (U8*)malloc(bmppitch);
    memset(pEachLinBuf, 0, bmppitch);
    U8 BytePerPix = bitCountPerPix >> 3;
    U32 pitch = width * BytePerPix;
    if (pEachLinBuf) {
        int h,w;
        for(h = height-1; h >= 0; h--) {
            for(w = 0; w < width; w++) {
                pEachLinBuf[w*BytePerPix+2] = ((66*pData[h*pitch + w*BytePerPix + 2]+129*pData[h*pitch + w*BytePerPix + 1]+25*pData[h*pitch + w*BytePerPix + 0])>>8)+16;
                pEachLinBuf[w*BytePerPix+1] = ((-38*pData[h*pitch + w*BytePerPix + 2]-74*pData[h*pitch + w*BytePerPix + 1]+112*pData[h*pitch + w*BytePerPix + 0])>>8)+128;
                pEachLinBuf[w*BytePerPix+0] = ((112*pData[h*pitch + w*BytePerPix + 2]-94*pData[h*pitch + w*BytePerPix + 1]-18*pData[h*pitch + w*BytePerPix + 0])>>8)+128;
            }
            fwrite(pEachLinBuf, bmppitch, 1, fp);
        }
        free(pEachLinBuf);
    }
    
    fclose(fp);
    return 1;
}
int YUV2RGB(U8 *pData, U8 bitCountPerPix, U32 width, U32 height, const char *filename)
{
    FILE *fp = fopen(filename, "wb");
    if (!fp) {
        printf("fopen failed : %s, %d\n", __FILE__, __LINE__);
        return 0;
    }
    
    U32 bmppitch = ((width*bitCountPerPix + 31) >> 5) << 2;
    U32 filesize = bmppitch*height;
    
    BITMAPFILE bmpfile;
    
    bmpfile.bfHeader.bfType = 0x4D42;
    bmpfile.bfHeader.bfSize = filesize + sizeof(BITMAPFILEHEADER) + sizeof(BITMAPINFOHEADER);
    bmpfile.bfHeader.bfReserved1 = 0;
    bmpfile.bfHeader.bfReserved2 = 0;
    bmpfile.bfHeader.bfOffBits = sizeof(BITMAPFILEHEADER) + sizeof(BITMAPINFOHEADER);
    
    bmpfile.biInfo.bmiHeader.biSize = sizeof(BITMAPINFOHEADER);
    bmpfile.biInfo.bmiHeader.biWidth = width;
    bmpfile.biInfo.bmiHeader.biHeight = height;
    bmpfile.biInfo.bmiHeader.biPlanes = 1;
    bmpfile.biInfo.bmiHeader.biBitCount = bitCountPerPix;
    bmpfile.biInfo.bmiHeader.biCompression = 0;
    bmpfile.biInfo.bmiHeader.biSizeImage = 0;
    bmpfile.biInfo.bmiHeader.biXPelsPerMeter = 0;
    bmpfile.biInfo.bmiHeader.biYPelsPerMeter = 0;
    bmpfile.biInfo.bmiHeader.biClrUsed = 0;
    bmpfile.biInfo.bmiHeader.biClrImportant = 0;
    
    fwrite(&(bmpfile.bfHeader), sizeof(BITMAPFILEHEADER), 1, fp);
    fwrite(&(bmpfile.biInfo.bmiHeader), sizeof(BITMAPINFOHEADER), 1, fp);
    
     U8 *pEachLinBuf = (U8*)malloc(bmppitch);
    memset(pEachLinBuf, 0, bmppitch);
    U8 BytePerPix = bitCountPerPix >> 3;
    U32 pitch = width * BytePerPix;
    if (pEachLinBuf) {
        int h,w;
        for(h = height-1; h >= 0; h--) {
            for(w = 0; w < width; w++) {
                //copy by a pixel
                pEachLinBuf[w*BytePerPix+2] = ((298*(pData[h*pitch + w*BytePerPix + 2]-16)+0*(pData[h*pitch + w*BytePerPix + 1]-128)+409*(pData[h*pitch + w*BytePerPix + 0]-128)+128)>>8);
                pEachLinBuf[w*BytePerPix+1] = ((298*(pData[h*pitch + w*BytePerPix + 2]-16)-100*(pData[h*pitch + w*BytePerPix + 1]-128)-208*(pData[h*pitch + w*BytePerPix + 0]-128)+128)>>8);
                pEachLinBuf[w*BytePerPix+0] = ((298*(pData[h*pitch + w*BytePerPix + 2]-16)+516*(pData[h*pitch + w*BytePerPix + 1]-128)-0*(pData[h*pitch + w*BytePerPix + 0]-128)+128)>>8);
            }
            fwrite(pEachLinBuf, bmppitch, 1, fp);
        }
        free(pEachLinBuf);
    }
    
    fclose(fp);
    return 1;
}

#pragma pack(pop)

#endif
