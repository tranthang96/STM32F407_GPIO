/*
 * Linker script.
 */ 

/* 
 * Set the output format. Currently set for Cortex M architectures,
 * may need to be modified if the library has to support other MCUs, 
 * or completelly removed.
 */
OUTPUT_FORMAT ("elf32-littlearm", "elf32-bigarm", "elf32-littlearm")

/* 
 * Just refering a function included in the vector table, and that
 * it is defined in the same file with it, so the vector table does
 * not get optimized out.
 */
EXTERN(Reset_Handler)

/*
 * ST32F103x8 memory setup.
 */
MEMORY
{
    FLASH     (rx)  : ORIGIN = 0x00000000, LENGTH = 64k
    RAM     (xrw)   : ORIGIN = 0x20000000, LENGTH = 20k
}

/*
 * Necessary group so the newlib stubs provided in the library,
 * will correctly be linked with the appropriate newlib functions,
 * and not optimized out, giving errors for undefined symbols.
 * This way the libraries can be fed to the linker in any order.
 */
GROUP(
   libgcc.a
   libg.a
   libc.a
   libm.a
   libnosys.a
 )

/* 
 * Stack start pointer. Here set to the end of the stack
 * memory, as in most architectures (including all the 
 * new ARM ones), the stack starts from the maximum address
 * and grows towards the bottom.
 */
__stack = ORIGIN(RAM) + LENGTH(RAM);

/*
 * Programm entry function. Used by the debugger only.
 */
ENTRY(_start)

/*
 * Memory Allocation Sections
 */
SECTIONS
{
    /* 
     * For normal programs should evaluate to 0, for placing the vector
     * table at the correct position.
     */
    . = ORIGIN(FLASH);

    /*
     * First link the vector table.
     */
    .vectors : ALIGN(4)
    {
        FILL(0xFF)
        __vectors_start__ = ABSOLUTE(.); 
        KEEP(*(.vectors))
        *(.after_vectors .after_vectors.*)
    } > FLASH

    /*
     * Start of text.
     */
    _text = .;

    /*
     * Text section
     */
    .text : ALIGN(4)
    {
        *(.text)
        *(.text.*)
        *(.glue_7t)
        *(.glue_7)
        *(.gcc*)
    } > FLASH

    /*
     * Arm section unwinding.
     * If removed may cause random crashes.
     */
    .ARM.extab :
    {
        *(.ARM.extab* .gnu.linkonce.armextab.*)
    } > FLASH

    /*
     * Arm stack unwinding.
     * If removed may cause random crashes.
     */
    .ARM.exidx :
    {
        __exidx_start = .;
        *(.ARM.exidx* .gnu.linkonce.armexidx.*)
        __exidx_end = .;
    } > FLASH

    /*
     * Section used by C++ to access eh_frame.
     * Generaly not used, but it doesn't harm to be there.
     */ 
    .eh_frame_hdr :
    {
        *(.eh_frame_hdr)
    } > FLASH

    /*
     * Stack unwinding code.
     * Generaly not used, but it doesn't harm to be there.
     */ 
    .eh_frame : ONLY_IF_RO
    {
        *(.eh_frame)
    } > FLASH

    /*
     * Read-only data. Consts should also be here.
     */
    .rodata : ALIGN(4)
    {
        . = ALIGN(4);
        __rodata_start__ = .;
        *(.rodata)
        *(.rodata.*)
        . = ALIGN(4);
        __rodata_end__ = .;
    } > FLASH 

    /*
     * End of text.
     */
    _etext = .;

    /*
     * Data section.
     */
    .data : ALIGN(4)
    {
        FILL(0xFF)
        . = ALIGN(4);
        PROVIDE(__textdata__ = LOADADDR(.data));
        PROVIDE(__data_start__ = .);
        *(.data)
        *(.data.*)
        *(.ramtext)
        . = ALIGN(4);
        PROVIDE(__data_end__ = .);
    } > RAM AT > FLASH

    /*
     * BSS section.
     */
    .bss (NOLOAD) : ALIGN(4)
    {
        . = ALIGN(4);
        PROVIDE(_bss_start = .);
        __bss_start__ = .;
        *(.bss)
        *(.bss.*)
        *(COMMON)
        . = ALIGN(4);
        PROVIDE(_bss_end = .);
        __bss_end__ = .;
        PROVIDE(end = .);
    } > RAM

    /*
     * Non-initialized variables section.
     * A variable should be explicitly placed
     * here, aiming in speeding-up boot time.
     */
    .noinit (NOLOAD) : ALIGN(4)
    {
        __noinit_start__ = .;
        *(.noinit .noinit.*) 
         . = ALIGN(4) ;
        __noinit_end__ = .;   
    } > RAM

    /*
     * Heap section.
     */
    .heap (NOLOAD) :
    {
        . = ALIGN(4);
        __heap_start__ = .;
        __heap_base__ = .;
        . = ORIGIN(HEAP_RAM) + LENGTH(HEAP_RAM);
        __heap_end__ = .;
    } > RAM

}