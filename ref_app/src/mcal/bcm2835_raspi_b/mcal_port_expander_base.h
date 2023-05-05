///////////////////////////////////////////////////////////////////////////////
//  Copyright Christopher Kormanyos 2020 - 2023.
//  Distributed under the Boost Software License,
//  Version 1.0. (See accompanying file LICENSE_1_0.txt
//  or copy at http://www.boost.org/LICENSE_1_0.txt)
//

#ifndef MCAL_PORT_EXPANDER_BASE_2023_05_05_H
  #define MCAL_PORT_EXPANDER_BASE_2023_05_05_H

  namespace mcal { namespace port {

  class port_expander_base
  {
  public:
    port_expander_base() = default;

    virtual ~port_expander_base() = default;

    port_expander_base(const port_expander_base&) = delete;
    port_expander_base(port_expander_base&&) noexcept = delete;

    auto operator=(const port_expander_base&) -> port_expander_base& = delete;
    auto operator=(port_expander_base&&) noexcept -> port_expander_base& = delete;

    virtual std::uint16_t read__word(const std::uint8_t) noexcept = 0;
    virtual void          write_word(const std::uint8_t, const std::uint16_t) noexcept = 0;

    virtual void set_direction_output(const std::uint8_t bpos) noexcept = 0;
    virtual void set_direction_input (const std::uint8_t bpos) noexcept = 0;
    virtual void set_pin_high        (const std::uint8_t bpos) noexcept = 0;
    virtual void set_pin_low         (const std::uint8_t bpos) noexcept = 0;
    virtual void toggle_pin          (const std::uint8_t bpos) noexcept = 0;
  };

  } } // namespace mcal::port

#endif // MCAL_PORT_EXPANDER_BASE_2023_05_05_H
