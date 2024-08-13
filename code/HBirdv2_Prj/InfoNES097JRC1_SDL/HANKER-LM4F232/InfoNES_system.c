/*-------------------------------------------------------------------*/
/*  InfoNES_system.c                                                 */
/*-------------------------------------------------------------------*/
#include "InfoNES.h"

/*-------------------------------------------------------------------*/
/*  Palette data                                                     */
/*-------------------------------------------------------------------*/
WORD NesPalette[64]={
	0
};

/*-------------------------------------------------------------------*/
/*  Function prototypes                                              */
/*-------------------------------------------------------------------*/

/* Menu screen */
int InfoNES_Menu()
{
	return 0;
}

/* Read ROM image file */
int InfoNES_ReadRom( const char *pszFileName )
{
	return 0;
}

/* Release a memory for ROM */
void InfoNES_ReleaseRom()
{
}

/* Transfer the contents of work frame on the screen */
void InfoNES_LoadFrame()
{
}

/* Get a joypad state */
void InfoNES_PadState( DWORD *pdwPad1, DWORD *pdwPad2, DWORD *pdwSystem )
{
}

/* memcpy */
void *InfoNES_MemoryCopy( void *dest, const void *src, int count )
{
	return NULL;
}

/* memset */
void *InfoNES_MemorySet( void *dest, int c, int count )
{
	return NULL;
}

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

