----------------------------------------------------------------------------------
-- Author: Akshay Gopinath 
-- Module Name: button_debounce - Behavioral
-- Dependancies: None
-- Project Name: CE339 Assignment 1
-- Target Devices: Digilent Basys 3 
----------------------------------------------------------------------------------

---------------------------------------------------
-- This module is a simple button debounce module
-- Which takes in a button input and a clock input
-- and outputs a debounced button output
---------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity button_debounce is
    Port ( clk : in std_logic;              -- Clock input
           button : in std_logic;           -- Button input
           debounce_out : out std_logic);   -- Debounced button output
end button_debounce;

architecture Behavioral of button_debounce is
    Signal out_int : std_logic;         -- Internal signal to store the button input
begin
    process(clk)
    begin
        debounce_out <= out_int;       -- Set the output to the internal signal
        if rising_edge(clk) then
            out_int <= button;         -- Set the output to the input at the rising edge of the clock
        end if;
    end process;

end Behavioral;
