----------------------------------------------------------------------------------
-- Author: Akshay Gopinath 
-- Module Name: button_debounce - Behavioral
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

entity button_debounce is
    Port ( clk : in STD_LOGIC;
           button : in STD_LOGIC;
           debounce_out : out STD_LOGIC);
end button_debounce;

architecture Behavioral of button_debounce is
    Signal out_int : STD_LOGIC;
begin
    process(clk)
    begin
        debounce_out <= out_int;
        if rising_edge(clk) then
            out_int <= button;
        end if;
    end process;

end Behavioral;
