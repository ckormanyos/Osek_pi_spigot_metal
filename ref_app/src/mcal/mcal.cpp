///////////////////////////////////////////////////////////////////////////////
//  Copyright Christopher Kormanyos 2007 - 2023.
//  Distributed under the Boost Software License,
//  Version 1.0. (See accompanying file LICENSE_1_0.txt
//  or copy at http://www.boost.org/LICENSE_1_0.txt)
//

#include <mcal/mcal.h>

extern "C"
auto mcal_init(void) -> void;

auto mcal_init(void) -> void
{
  mcal::init();
}

void mcal::init()
{
  // Initialize the microcontroller abstraction layer.

  // Note: mcal::cpu::init() has already been called from the startup code.

  mcal::gpt::init(nullptr);
  mcal::spi::init(nullptr);

  static_cast<void>
  (
    mcal::lcd::lcd0().init()
  );
}
