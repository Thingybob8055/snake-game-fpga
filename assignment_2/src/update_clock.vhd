library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity updateClk is
    Generic (
        max_value : NATURAL := 4000000
    );
    Port ( clk_100mhz : in STD_LOGIC;
           update : out STD_LOGIC);
end updateClk;

architecture Behavioral of updateClk is
    signal count : unsigned(64 downto 0);
begin
    process(clk_100mhz)
    begin
        if rising_edge(clk_100mhz) then
            if count = max_value then
                count <= (others => '0');
                update <= '1';
            else
                count <= count + 1;
                update <= '0';
            end if;
        end if;
    end process;
end Behavioral;