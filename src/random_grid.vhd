library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity randomGrid is
    Port ( pixel_clk : in STD_LOGIC;
           rand_X :inout unsigned(6 downto 0);
           rand_Y : inout unsigned(6 downto 0)
         );
end randomGrid;

architecture Behavioral of randomGrid is
    signal rand_X_reg : unsigned(6 downto 0);
    signal rand_Y_reg : unsigned(6 downto 0);
begin
    process(pixel_clk)
    begin
        if rising_edge(pixel_clk) then
            rand_X <= ((rand_X + 3) mod 37) + 1; -- set random x and y position
            rand_Y <= ((rand_Y + 3) mod 27) + 1;
        end if;
    end process;
end Behavioral;
