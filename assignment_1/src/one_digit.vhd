----------------------------------------------------------------------------------
-- Author: Akshay Gopinath 
-- Module Name: one_digit - Behavioral
-- Dependancies: None
-- Project Name: CE339 Assignment 1
-- Target Devices: Digilent Basys 3 
----------------------------------------------------------------------------------

---------------------------------------------------
-- This module takes a 4-bit input and outputs a 7-bit pattern to display the input digit on a 7-segment display
-- It's a type of decoder
---------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity one_digit is
    Port ( digit : in std_logic_vector (3 downto 0);   -- input digit
           seg : out std_logic_vector (6 downto 0) );  -- 7-segment display cathode output
end one_digit;

architecture Behavioral of one_digit is

begin
    process(digit)
    begin
    case digit is  -- outout the 7-segment display bit pattern for the input digit
        when "0000" => seg <= "1000000"; -- 0
        when "0001" => seg <= "1001111"; -- 1
        when "0010" => seg <= "0100100"; -- 2
        when "0011" => seg <= "0110000"; -- 3
        when "0100" => seg <= "0011001"; -- 4
        when "0101" => seg <= "0010010"; -- 5
        when "0110" => seg <= "0000010"; -- 6
        when "0111" => seg <= "1111000"; -- 7
        when "1000" => seg <= "0000000"; -- 8
        when "1001" => seg <= "0010000"; -- 9
        when others => seg <= "1111111";
    end case;
    end process;
end Behavioral;
