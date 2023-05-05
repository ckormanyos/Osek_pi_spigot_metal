Osek_pi_spigot_metal
[![Build Status](https://github.com/ckormanyos/Osek_pi_spigot_metal/actions/workflows/Osek_pi_spigot_metal.yml/badge.svg)](https://github.com/ckormanyos/Osek_pi_spigot_metal/actions)
==================

Osek_pi_spigot_metal computes $100,001$ decimal digits
of the mathematical constant $\pi$ on a bare-metal RaspberryPi(R)-Zero system.

The backbone real-time operating system is taken directly
from the OSEK-like OS implemented in
[Chalandi/OSEK_Raspberry_Pi_Zero](https://github.com/Chalandi/OSEK_Raspberry_Pi_Zero)

This fascinating, educational and fun project combines the domain
of high-performance numerical computing with the raw simplicity of
bare-metal embedded microcontroller systems.

# Software Details

In this project, $100,001$ decmal digits of $\pi$ (i.e., one hundred thousand and 1)
are computed with an order $N^2$ pi-spigot algorithm.
The spigot calculation has quadratic numerical complexity
and is (for high digit counts) generally considered slower
than the other calculation methods such as AGM.
It requires sightly less than an hour to compute $100,001$
decimal digits on the target system.

The microcontroller boots and performs static initialization via self-written
startup code. Hardware setup including clock initialization,
FPU enable, instruction caching, etc. is carried out with self-written
hybrid assembly/C++ code shortly after reaching `main()`.

The pi-spigot calculation runs continuously and successively in the
application idle-task. LED-blinky and calculation progress
presented on an LCD display are controlled in a higher-priority
extended task named `T1`. Calculation correctness is verified with
a hash sum of the character representation of the digits computed.

Compact code size is in focus and the entire project easily fits within 32k
of program code, with slight variations depending on the target system selected.
The calculation does, however, require ample RAM of about 2 Mbyte.

# Prototype Project

The target hardware on a breadboard is taken directly
from the similar project
[ckormanyos/pi_crunch_metal](https://github.com/ckormanyos/pi-crunch-metal).
It runs on a
[RaspberryPi(R)-Zero](https://www.raspberrypi.org/products/raspberry-pi-zero).

The build system is set up to use GCC, making use of the `arm-none-eabi`
compiler taken directly from the
[real-time-cpp-toolchains](https://github.com/ckormanyos/real-time-cpp-toolchains)
repository.

The default optimization setting is `-O2` and the one-hundred-thousand-and-one
decimal digit pi calculation takes slightly under 30 minutes
on this target system with the above-mentioned compiler.

The hardware setup is pictured in the image below.
In this image, the target system has already completed
one pi-spigot calculatoin and has begin a second one
back-to-back.

![](./images/Osek_pi_spigot_metal.jpg)
