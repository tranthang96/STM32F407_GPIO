#ifndef __HW_STM32F407VGT6_H__
#define __HW_STM32F407VGT6_H__

#define write_reg(addr, value)	*((unsigned long int *)(addr)) = value
#define read_reg(addr, mask)	*((unsigned long int *)(addr)) & (mask)

/* RCC */
#define BASE_ADDR_RCC		0x40023800u
#define RCC_AHB1ENR			(BASE_ADDR_RCC + 0x30)

/* GPIO D  */
#define BASE_ADDR_GPIOD		0x40020C00u
#define GPIO_MODER			(BASE_ADDR_GPIOD + 0x00u)
#define GPIO_MODER_INPUT	0x00u
#define GPIO_MODER_OUTPUT	0x01u
#define GPIO_MODER_ALT		0x02u
#define GPIO_MODER_ANALOG	0x03u

#define GPIOD_BSRR			(BASE_ADDR_GPIOD + 0x18u)

/* LED PD 12 */
#define LED_PIN			12

/* end file */
#endif	