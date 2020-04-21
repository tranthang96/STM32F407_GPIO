#include "hw_stm32f407vgt6.h"


void delay(unsigned int timeout)
{
    unsigned int t1, t2;
    for (t1 = 0; t1 < timeout; t1++)
    {
        for (t2 = 0; t2 < 0xFFF; t2++)
        {
          asm(" nop");
        }
    }
}

void enabled_clock(void)
{
	unsigned int tempreg;
	/* set clock */
	tempreg = read_reg(RCC_AHB1ENR, ~(1 << 3));
	tempreg = tempreg | (1 << 3);
	write_reg(RCC_AHB1ENR, tempreg);
}

void init_pin(void)
{
	unsigned int tempreg;
	/* set mode led pd 12 */
	tempreg = read_reg(GPIO_MODER, ~(0x03 << 24));
	tempreg = tempreg | (GPIO_MODER_OUTPUT << 24);
	write_reg(GPIO_MODER, tempreg); 
}

void led_on(unsigned char pin_number)
{
	write_reg(GPIOD_BSRR, 1u << pin_number);
}

void led_off(unsigned char pin_number)
{
	write_reg(GPIOD_BSRR, 1u << (pin_number + 16u));
}

void main(void)
{
	enabled_clock();
	init_pin();
	while(1)
	{
		led_on(LED_PIN);
		delay(0xff);
		led_off(LED_PIN);
		delay(0xff);
	}
}