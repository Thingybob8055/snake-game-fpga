----------------------------------------------------------------------------------
-- Author: Akshay Gopinath 
-- Module Name: mux4_1 - Behavioral
-- Dependancies: None
-- Project Name: CE339 Assignment 1
-- Target Devices: Digilent Basys 3 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mux4_1 is
    Port ( a : in STD_LOGIC_VECTOR (3 downto 0);
           s : in STD_LOGIC_VECTOR (1 downto 0);
           y : out STD_LOGIC);
end mux4_1;

architecture Behavioral of mux4_1 is

begin
    process(a,s)
    begin
        case s is
            when "00" => y <= a(0);
            when "01" => y <= a(1);
            when "10" => y <= a(2);
            when "11" => y <= a(3);
            when others => y <= 'X';
        end case;
    end process;

end Behavioral;
