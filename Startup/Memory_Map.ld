/******************************************************************************************
  Filename    : Memory_Map.ld
  
  Core        : ARM1176JZF-S
  
  Author      : Chalandi Amine
 
  Owner       : Chalandi Amine
  
  Date        : 11.03.2020
  
  Description : Linker description file for ARM1176JZF-S(ARMv6)
  
******************************************************************************************/

INPUT(libc.a libm.a libgcc.a)

OUTPUT_FORMAT("elf32-littlearm", "elf32-littlearm", "elf32-littlearm")
OUTPUT_ARCH(arm)

/******************************************************************************************
 ELF Entrypoint
******************************************************************************************/
ENTRY(reset)

/******************************************************************************************
 Globals
******************************************************************************************/
__SYS_STACK_SIZE = 4K;
__SVC_STACK_SIZE = 4K;
__ABT_STACK_SIZE = 4K;
__UND_STACK_SIZE = 4K;
__IRQ_STACK_SIZE = 4K;
__FIQ_STACK_SIZE = 4K;

/******************************************************************************************
 Internal flash configuration
******************************************************************************************/

MEMORY
{
  ROM(rwx) : ORIGIN = 0x00008000, LENGTH = 128K
  RAM(rwx) : ORIGIN = 0x00028000, LENGTH = 16M - 128K
}

/******************************************************************************************
 Sections definition
******************************************************************************************/
SECTIONS
{
  /* Interrupt vector table */
  .intvect :
  {
    PROVIDE(__INTVECT_BASE_ADDRESS = .) ;
    *(.intvect)
    . = ALIGN(4);
    KEEP(*(.intvect))
  } > ROM

  /* Program code (text) */
  .text :
  {
    *(.progmem*)
    . = ALIGN(4);
    *(.text)
    . = ALIGN(4);
    *(.text*)
    . = ALIGN(4);
    *(.glue_7)
    . = ALIGN(4);
    *(.glue_7t)
    . = ALIGN(4);
  } > ROM

  /* Read-only data (.rodata) */
  .rodata :
  {
    *(.rodata)
    . = ALIGN(4);
    *(.rodata*)
    . = ALIGN(4);
  } > ROM

 /* Section for constructors */
  .ctors :
  {
    __CTOR_LIST__ = . ;
    LONG((__CTOR_END__ - __CTOR_LIST__) / 4 - 2);
    KEEP (*(SORT(.ctors.*)))
    KEEP (*(.ctors))
    KEEP (*(SORT(.init_array.*)))
    KEEP (*(.init_array))
    LONG(0) ;
    __CTOR_END__ = . ;
    . = ALIGN(8);
  }  > ROM

  /* Runtime clear table */
  .clear_sec :
  {
    . = ALIGN(8);
    PROVIDE(__RUNTIME_CLEAR_TABLE = .) ;
    LONG(0 + ADDR(.bss));   LONG(SIZEOF(.bss));
    LONG(-1);               LONG(-1);
  } > ROM

  .ARM.extab :
  {
    . = ALIGN(4);
    *(.ARM.extab)
    *(.gnu.linkonce.armextab.*)
    . = ALIGN(4);
  } > ROM

  .exidx :
  {
    . = ALIGN(4);
    PROVIDE(__exidx_start = .);
    *(.ARM.exidx*)
    . = ALIGN(4);
    PROVIDE(__exidx_end = .);
  } > ROM

  .ARM.attributes :
  {
    *(.ARM.attributes)
  } > ROM

  /* Runtime copy table */	
  .copy_sec :
  {
    . = ALIGN(8);
    PROVIDE(__RUNTIME_COPY_TABLE = .) ;
    LONG(LOADADDR(.data));  LONG(0 + ADDR(.data));  LONG(SIZEOF(.data));
    LONG(-1);               LONG(-1);               LONG(-1);
  } > ROM

  /* The ROM-to-RAM initialized data section */
  .data :
  {
    *(.data)
    . = ALIGN(4);
  } > RAM  AT>ROM

  /* The uninitialized (zero-cleared) bss section */
  .bss :
  {
    *(.bss)
    . = ALIGN(4);
  } > RAM

  /* user-system mode stack definition */
  .stack_sys :
  {
    . = ALIGN(MAX(__SYS_STACK_SIZE , .), 8);
    PROVIDE(__SYS_STACK_TOP = .) ;
  } > RAM

  /* Supervisor mode stack definition */
  .stack_svc :
  {
    . = ALIGN(MAX(__SVC_STACK_SIZE , .), 8);
    PROVIDE(__SVC_STACK_TOP = .) ;
  } > RAM

  /* Abort mode stack definition */
  .stack_abt :
  {
    . = ALIGN(MAX(__ABT_STACK_SIZE , .), 8);
    PROVIDE(__ABT_STACK_TOP = .) ;
  } > RAM

  /* Undefined mode stack definition */
  .stack_und :
  {
    . = ALIGN(MAX(__UND_STACK_SIZE , .), 8);
    PROVIDE(__UND_STACK_TOP = .) ;
  } > RAM

  /* Interrupt mode stack definition */
  .stack_irq :
  {
    . = ALIGN(MAX(__IRQ_STACK_SIZE , .), 8);
    PROVIDE(__IRQ_STACK_TOP = .) ;
  } > RAM

  /* Fast interrupt mode stack definition */
  .stack_fiq :
  {
    . = ALIGN(MAX(__FIQ_STACK_SIZE , .), 8);
    PROVIDE(__FIQ_STACK_TOP = .) ;
  } > RAM
}
