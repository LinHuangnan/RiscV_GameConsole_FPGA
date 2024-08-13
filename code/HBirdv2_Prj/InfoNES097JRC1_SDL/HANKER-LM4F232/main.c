
#include "InfoNES.h"

int main(void)
{
  if(InfoNES_Load(NULL) == 0)
  {
    InfoNES_Main();
  }
  
  while(1);
}

