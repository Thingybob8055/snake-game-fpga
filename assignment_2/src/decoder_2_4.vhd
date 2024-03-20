----------------------------------------------------------------------------------
-- Author: Akshay Gopinath 
-- Module Name: decoder_2_4 - Behavioral
-- Dependancies: None
-- Project Name: CE339 Assignment 1
-- Target Devices: Digilent Basys 3 
----------------------------------------------------------------------------------

---------------------------------------------------
-- This module is a simple 2 to 4 decoder
-- Used for selecting the 7 segment display anodes
---------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decoder_2_4 is
    Port ( a : in std_logic_vector (1 downto 0);   -- input to the decoder
           y : out std_logic_vector (3 downto 0)); -- output of the decoder
end decoder_2_4;

architecture Behavioral of decoder_2_4 is

begin
    process(a)
    begin
        case a is
            when "00" => y <= "1110";  -- output is active low
            when "01" => y <= "1101";  -- Make the corresponding bit low
            when "10" => y <= "1011";
            when "11" => y <= "0111";
            when others => y <= "1111";
        end case;
    end process;

end Behavioral;
