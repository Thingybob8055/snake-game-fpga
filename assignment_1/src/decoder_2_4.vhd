----------------------------------------------------------------------------------
-- Author: Akshay Gopinath 
-- Module Name: decoder_2_4 - Behavioral
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

entity decoder_2_4 is
    Port ( a : in STD_LOGIC_VECTOR (1 downto 0);
           y : out STD_LOGIC_VECTOR (3 downto 0));
end decoder_2_4;

architecture Behavioral of decoder_2_4 is

begin
    process(a)
    begin
        case a is
            when "00" => y <= "1110";
            when "01" => y <= "1101";
            when "10" => y <= "1011";
            when "11" => y <= "0111";
            when others => y <= "1111";
        end case;
    end process;

end Behavioral;
