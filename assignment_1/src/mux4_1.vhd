----------------------------------------------------------------------------------
-- Author: Akshay Gopinath 
-- Module Name: mux4_1 - Behavioral
-- Dependancies: None
-- Project Name: CE339 Assignment 1
-- Target Devices: Digilent Basys 3 
----------------------------------------------------------------------------------

---------------------------------------------------
-- This module is a geneoric 4:1 mux
-- The input is a 4 bit vector and the select is a 2 bit vector
-- The output is a single bit
---------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux4_1 is
    Port ( a : in std_logic_vector (3 downto 0);  -- 4 bit input
           s : in std_logic_vector (1 downto 0);  -- 2 bit select
           y : out std_logic);                    -- 1 bit output
end mux4_1;

architecture Behavioral of mux4_1 is

begin
    process(a,s)
    begin
        case s is
            when "00" => y <= a(0);  -- select the corresponding bit based on the select
            when "01" => y <= a(1);
            when "10" => y <= a(2);
            when "11" => y <= a(3);
            when others => y <= 'X';
        end case;
    end process;

end Behavioral;
