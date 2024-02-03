----------------------------------------------------------------------------------
-- Author: Akshay Gopinath 
-- Module Name: nbit_counter - Behavioral
-- Dependancies: None
-- Project Name: CE339 Assignment 1
-- Target Devices: Digilent Basys 3 
----------------------------------------------------------------------------------

---------------------------------------------------
-- This module is a generic n-bit counter that can count upto a specified modulo
-- The counter can be reset, and can be made to count in reverse
-- The counter has a carry out signal that is high when the counter reaches the modulo to chain multiple counters
---------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity nbit_counter is
    Generic (width  : natural := 4;   -- Number of bits in the counter needed to count upto the modulo
             modulo : natural := 16); -- Modulo upto which the counter should count to
    Port ( clk    : in  std_logic;    -- Clock signal
           cin    : in  std_logic;    -- Carry in signal
           negate : in  std_logic;    -- Negate the output
           rst    : in  std_logic;    -- Reset signal
           cout   : out std_logic;    -- Carry out signal
           output : out std_logic_vector ((width-1) downto 0));    -- Output of the counter
end nbit_counter;

architecture Behavioral of nbit_counter is
    signal count : unsigned (output'RANGE) := (others => '0');   -- Counter signal
begin
    process(clk, rst)
    begin
        if rising_edge(clk) then
            if rst = '1' then   -- synchronous reset
                count <= (others => '0');
            elsif (cin = '1') and (count = (modulo-1)) then   -- reset when modulo is reached
                count <= (others => '0');
            elsif (cin = '1') then  -- increment when carry in is high
                count <= count + 1;
            end if;
        end if;
    end process;

    cout <= '1' when (cin = '1') and (count = (modulo-1)) else '0';  -- Carry out signal is high when modulo is reached
    output <= std_logic_vector(count) when negate = '0' else std_logic_vector(not count);  -- Negate the output if negate is high

end Behavioral;
