Osek_pi_spigot_metal
==================

pi-crunch-metal computes $100,001$ decimal digits
of the mathematical constant $\pi$ on a bare-metal RaspberryPi(R)-Zero system.

This fascinating, educational and fun project combines the domain
of high-performance numerical computing with the raw simplicity of
bare-metal embedded microcontroller systems.

The backbone operating system is taken directly from the
OSEK-like OS implemented in
[Chalandi/OSEK_Raspberry_Pi_Zero](https://github.com/Chalandi/OSEK_Raspberry_Pi_Zero)

# Software Details

In this project, $100,001$ decmal digits of $\pi$ (i.e., one hundred thousand and 1)
are computed with an order $N^2$ pi-spigot algorithm.
The spigot calculation is (having quadratic order)
may be considered slower than the other calculations
(such as AGM) and requires sightly less than an hour
to compute a count of $100,001$ decimal digits on the target system.

The microcontroller boots and performs static initialization via self-written
startup code. Hardware setup including clock initialization,
FPU enable, instruction caching, etc. is carried out with self-written
hybrid assembly/C++ code shortly after reaching `main()`.

Compact code size is in focus and the entire project easily fits within 32k
of program code, with slight variations depending on the target system selected.
The calculation does, however, require ample RAM of about 2 Mbyte.

# Prototype Project

The target hardware on a breadboard is taken directly
from the similar project
[ckormanyos/pi_crunch_metal](https://github.com/ckormanyos/pi-crunch-metal).
