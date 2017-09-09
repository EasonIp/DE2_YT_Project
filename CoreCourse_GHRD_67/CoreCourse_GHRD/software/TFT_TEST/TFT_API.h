/*
 * TFT_API.h
 * *
 * v1.1 添加汉字显示功能
 * 	    修改时间: 2016-1-25
 */
#ifndef TFT_API_H_
#define TFT_API_H_

#include "alt_types.h"
#include "stdlib.h"
#include "unistd.h"
#include "system.h"
#include "io.h"

//lcd dir参数取值
#define LCD_HORIZONTAL 1  //横屏显示
#define LCD_VERTICAL   0  //竖屏显示

//LCD重要参数集
typedef struct
{
	alt_u8 dir;			//LCD显示方向,横屏/竖屏。默认横屏
	alt_u16 x_len;		//LCD 宽度
	alt_u16 y_len;		//LCD 高度
}_lcd_dev;

extern alt_u16 POINT_COLOR,BACK_COLOR;


/******************************************************************************
                        LCD_printf函数用到的结构体
******************************************************************************/

typedef struct
{
	alt_u16 cursorx;  //光标当前位置
	alt_u16 cursory;
	alt_u16 cursorx0;  //保存光标位置
	alt_u16 cursory0;
	alt_u16 min_width;  //显示最小宽度，小数时包括小数点在内
	alt_u16 precision;  //显示精度
	alt_u8  mode;  //模式
	alt_u8  charcnt;  //显示字符计数
}_Typedef_lcdprintf;

extern _Typedef_lcdprintf lcd_printf;

//画笔颜色
#define WHITE         	 0xFFFF
#define BLACK         	 0x0000
#define BLUE         	 0x001F
#define BRED             0XF81F
#define GRED 			 0XFFE0
#define GBLUE			 0X07FF
#define RED           	 0xF800
#define MAGENTA       	 0xF81F
#define GREEN         	 0x07E0
#define CYAN          	 0x7FFF
#define YELLOW        	 0xFFE0
#define BROWN 			 0XBC40 //棕色
#define BRRED 			 0XFC07 //棕红色
#define GRAY  			 0X8430 //灰色

//GUI颜色
#define DARKBLUE      	 0X01CF	//深蓝色
#define LIGHTBLUE      	 0X7D7C	//浅蓝色
#define GRAYBLUE       	 0X5458 //灰蓝色
//以上三色为PANEL的颜色

#define LIGHTGREEN     	 0X841F //浅绿色
#define LIGHTGRAY        0XEF5B //浅灰色(PANNEL)
#define LGRAY 			 0XC618 //浅灰色(PANNEL),窗体背景色

#define LGRAYBLUE        0XA651 //浅灰蓝色(中间层颜色)
#define LBBLUE           0X2B12 //浅棕蓝色(选择条目的反色)


/*对TFT液晶底层操作*/
#define TFT_BASE TFT_SRAM_BASE

#define __TFT_CALC_ADDRESS(BASE, offset) \
  ((void *)(((alt_u8*)BASE) + ((offset) * (16/8))))

#define TFT_WR(addr, data) \
  __builtin_sthio (__TFT_CALC_ADDRESS((TFT_BASE), (addr)), (data))

#define TFT_WR_XY(x,y, data) \
  __builtin_sthio (__TFT_CALC_ADDRESS((TFT_BASE), ((x) + (y*480))), (data))



void LCD_Dir(alt_u16 dir);
void LCD_Init(void);
void LCD_Clear(alt_u16 Color);
alt_u8 LCD_DrawPoint(alt_u16 x,alt_u16 y,alt_u16 color);
alt_u8 LCD_Fill(alt_u16 sx,alt_u16 sy,alt_u16 ex,alt_u16 ey,alt_u16 color);
alt_u8 LCD_DrawLine(alt_u16 x1, alt_u16 y1, alt_u16 x2, alt_u16 y2);
alt_u8 LCD_DrawRectangle(alt_u16 xs, alt_u16 ys, alt_u16 xe, alt_u16 ye);
alt_u8 Draw_Circle(alt_u16 x0,alt_u16 y0,alt_u8 r);
alt_u8 LCD_ShowChar(alt_u16 x,alt_u16 y,alt_u8 show,alt_u8 size,alt_u8 overlay);
alt_u8 LCD_ShowNum(alt_u16 x,alt_u16 y,alt_u32 num,alt_u8 len,alt_u8 size);
alt_u8 LCD_ShowString(alt_u16 x,alt_u16 y,alt_u8 size,char *p);
alt_u8 LCD_ShowChinese(alt_u16 x,alt_u16 y,alt_u16 size,alt_u8 overlay,alt_u8 num,const unsigned char *p);
alt_u8 LCD_MoveChinese(alt_u16 x,alt_u16 y,alt_u16 size,alt_u16 total,alt_u16 num,const unsigned char *p);

int LCD_printf(_Typedef_lcdprintf* lcd_pr, const alt_u8 *format, ...);

#endif /* TFT_API_H_ */
