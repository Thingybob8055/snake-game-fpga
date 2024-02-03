----------------------------------------------------------------------------------
-- Author: Akshay Gopinath 
-- Module Name: nbit_clk_div - Behavioral
-- Dependancies: nbit_counter
-- Project Name: CE339 Assignment 1
-- Target Devices: Digilent Basys 3 
----------------------------------------------------------------------------------

---------------------------------------------------
-- This module is a genric n-bit clock divider, which is configurable to divide the input clock by any number.
-- The duty cycle of the output clock is also configurable.
-- The module uses the nbit_counter module to divide the clock.
-- The parameter num_of_bits is used to specify the number of bits in the counter.
-- The parameter div_factor is used to specify the number by which the clock is to be divided.
-- The parameter high_count is used to specify the number of clock pulses until the output clock is high
---------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity nbit_clk_div is
    Generic (
        div_factor : natural := 16; -- divide the clock by this number
        high_count : natural := 8; -- num of clk pulses until high; duty cycle = (div_factor - high_count) / div_factor
        num_of_bits : natural := 4  -- number of bits in the counter needed to divide the clock
    );
    Port ( clk_in : in std_logic;  -- input clock
           output : out std_logic  -- output divided clock
    );
end nbit_clk_div;

architecture Behavioral of nbit_clk_div is
    component nbit_counter is       -- component declaration for nbit_counter
        Generic (
            width : natural;
            modulo : natural 
        );
        Port (
            clk: in std_logic;
            cin    : in  std_logic;
            negate: in std_logic;
            rst : in std_logic;
            cout   : out std_logic;
            output : out std_logic_vector((width-1) downto 0)
        );
    end component;
    signal ignore : std_logic;  -- signal to ignore the carry out of the counter
    constant HI_TIME : std_logic_vector := std_logic_vector(to_unsigned(high_count-1, num_of_bits)); -- constant to compare the counter output
    signal counter_output : std_logic_vector((num_of_bits-1) downto 0);  -- counter output
begin
    counter : nbit_counter
    Generic Map (
        width => num_of_bits,
        modulo => div_factor
    )
    Port Map (
        clk => clk_in,
        cin => '1',
        negate => '0',
        rst => '0',
        cout => ignore,
        output => counter_output  -- output of the counter is used to generat the output clock
    );

    process(clk_in)
        variable out_int : std_logic := '0';  -- internal signal to generate the output clock
    begin
        output <= out_int;
        if rising_edge(clk_in) then
            if counter_output <= HI_TIME then   -- compare the counter output with the high_count to set the duty cycle
                out_int := '1';
            else
                out_int := '0';
            end if;
        end if;
    end process;
--    output <= counter_output(num_of_bits - 1);
end Behavioral;
