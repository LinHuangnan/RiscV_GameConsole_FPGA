
//未换源
/*-------------------------------------------------------------------*/
/*  InfoNES_system.c                                                 */
/*-------------------------------------------------------------------*/
#include "InfoNES.h"
#include <string.h>
#include "global.h"
#include "key.h"

/*-------------------------------------------------------------------*/
/*  Palette data                                                     */
/*-------------------------------------------------------------------*/
WORD NesPalette[64]={
#if 0
  0x738E,0x88C4,0xA800,0x9808,0x7011,0x1015,0x0014,0x004F,
  0x0148,0x0200,0x0280,0x11C0,0x59C3,0x0000,0x0000,0x0000,
  0xBDD7,0xEB80,0xE9C4,0xF010,0xB817,0x581C,0x015B,0x0A59,
  0x0391,0x0480,0x0540,0x3C80,0x8C00,0x0000,0x0000,0x0000,
  0xFFDF,0xFDC7,0xFC8B,0xFC48,0xFBDE,0xB39F,0x639F,0x3CDF,
  0x3DDE,0x1690,0x4EC9,0x9FCB,0xDF40,0x0000,0x0000,0x0000,
  0xFFDF,0xFF15,0xFE98,0xFE5A,0xFE1F,0xDE1F,0xB5DF,0xAEDF,
  0xA71F,0xA7DC,0xBF95,0xCFD6,0xF7D3,0x0000,0x0000,0x0000,
#else
  0x738E,0x20D1,0x0015,0x4013,0x880E,0xA802,0xA000,0x7840,
  0x4140,0x0200,0x0280,0x01C2,0x19CB,0x0000,0x0000,0x0000,
  0xBDD7,0x039D,0x21DD,0x801E,0xB817,0xE00B,0xD940,0xCA41,
  0x8B80,0x0480,0x0540,0x0487,0x0411,0x0000,0x0000,0x0000,
  0xFFDF,0x3DDF,0x5C9F,0x445F,0xF3DF,0xFB96,0xFB8C,0xFCC7,
  0xF5C7,0x8682,0x4EC9,0x5FD3,0x075B,0x0000,0x0000,0x0000,
  0xFFDF,0xAF1F,0xC69F,0xD65F,0xFE1F,0xFE1B,0xFDD6,0xFED5,
  0xFF14,0xE7D4,0xAF97,0xB7D9,0x9FDE,0x0000,0x0000,0x0000,
#endif
};


#define pad_up 1
#define pad_down 2
#define pad_left 3
#define pad_right 4
#define pad_run 5
#define pad_back 6
#define pad_key0 7
#define pad_key1 8

/*-------------------------------------------------------------------*/
/*  Function prototypes                                              */
/*-------------------------------------------------------------------*/

/* Menu screen */
int InfoNES_Menu()
{
        return 0;
}

/* Read ROM image file */
extern const BYTE nes_rom[];
int InfoNES_ReadRom( const char *pszFileName )
{
/*
 *  Read ROM image file
 *
 *  Parameters
 *    const char *pszFileName          (Read)
 *
 *  Return values
 *     0 : Normally
 *    -1 : Error
 */


  /* Read ROM Header */
  BYTE * rom = (BYTE*)nes_rom;
  memcpy( &NesHeader, rom, sizeof(NesHeader));
  if ( memcmp( NesHeader.byID, "NES\x1a", 4 ) != 0 )
  {
    /* not .nes file */
    return -1;
  }
  rom += sizeof(NesHeader);

  /* Clear SRAM */
  memset( SRAM, 0, SRAM_SIZE );

  /* If trainer presents Read Triner at 0x7000-0x71ff */
  if ( NesHeader.byInfo1 & 4 )
  {
    //memcpy( &SRAM[ 0x1000 ], rom, 512);
	rom += 512;
  }

  /* Allocate Memory for ROM Image */
  ROM = rom;
  rom += NesHeader.byRomSize * 0x4000;

  if ( NesHeader.byVRomSize > 0 )
  {
    /* Allocate Memory for VROM Image */
	VROM = (BYTE*)rom;
	rom += NesHeader.byVRomSize * 0x2000;
  }

  /* Successful */
  return 0;
}
/* Release a memory for ROM */
void InfoNES_ReleaseRom()
{
}
/* Transfer the contents of work frame on the screen */
void InfoNES_LoadFrame()
{
    uint32_t*P=(uint32_t*)0x80200000;
    uint32_t temp;
    for(int i=0;i<NES_DISP_HEIGHT;i++)
    {
      for(int j=0;j<NES_DISP_WIDTH;j++)
      {
        temp=WorkFrame[i*NES_DISP_WIDTH+j];
        temp=temp|(temp<<16);
        *(P+i*LCD_W_MAX+j)=temp;
        *(P+i*LCD_W_MAX+LCD_W_MAX_HALF+j)=temp;
      }
    }
    
}

/* Transfer the contents of work line on the screen */
void InfoNES_LoadLine()
{
  /*
	int i;
	for(i=0;i<NES_DISP_WIDTH;i++)
	{
    *(LCD_P+PPU_Scanline*LCD_W_MAX+i)=WorkLine[i];
	}
  */

	////////////////////////////////
}


/* Get a joypad state */
void InfoNES_PadState( DWORD *pdwPad1, DWORD *pdwPad2, DWORD *pdwSystem )
{
	static uint8_t flag=0;

	*pdwPad1=0;
//	if(flag)	{*pdwPad1|=PAD_JOY_B;}
    if(PS2_X_In || key_data==pad_back)  switch_game();
		if(PS2_A_In)		*pdwPad1|=PAD_JOY_A;
		if(PS2_DOWN_In || key_data==pad_down)	*pdwPad1|=PAD_JOY_DOWN;
		if(PS2_LEFT_In || key_data == pad_left)	*pdwPad1|=PAD_JOY_LEFT;
		if(PS2_RIGHT_In || key_data==pad_right)	*pdwPad1|=PAD_JOY_RIGHT;
		if(PS2_SELECT_In || key_data==pad_run)	*pdwPad1|=PAD_JOY_SELECT;
		if(PS2_START_In || key_data==pad_key1)	{*pdwPad1|=PAD_JOY_START;}
		if(PS2_UP_In||key_data==pad_up)		*pdwPad1|=PAD_JOY_UP;
		if(PS2_B_In || key_data==pad_key0)		*pdwPad1|=PAD_JOY_B;

}

/* memcpy */
void *InfoNES_MemoryCopy( void *dest, const void *src, int count ){return memcpy(dest,src,count);}

/* memset */
void *InfoNES_MemorySet( void  *dest, int c, int count ){return memset(dest,c,count);}

/* Print debug message */
void InfoNES_DebugPrint( char *pszMsg )
{
}

/* Wait */
void InfoNES_Wait()
{
	
}

/* Sound Initialize */
void InfoNES_SoundInit( void )
{
}

/* Sound Open */
int InfoNES_SoundOpen( int samples_per_sync, int sample_rate )
{
  return 0;
}

/* Sound Close */
void InfoNES_SoundClose( void )
{
}

/* Sound Output 5 Waves - 2 Pulse, 1 Triangle, 1 Noise, 1 DPCM */
void InfoNES_SoundOutput(int samples, BYTE *wave1, BYTE *wave2, BYTE *wave3, BYTE *wave4, BYTE *wave5)
{
}

/* Print system message */
void InfoNES_MessageBox( char *pszMsg, ... )
{
}
