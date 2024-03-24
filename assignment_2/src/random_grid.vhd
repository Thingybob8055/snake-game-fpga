library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use ieee.math_real.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


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
