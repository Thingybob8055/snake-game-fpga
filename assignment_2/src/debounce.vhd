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


entity Debounce is
    Generic (DELAY : integer := 400000);
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           noisy : in STD_LOGIC;
           button_debounced : out STD_LOGIC);
end Debounce;

architecture Behavioral of Debounce is
    signal counter : unsigned(19 downto 0);
    signal new_sig : std_logic;
begin
    process(clk, rst)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                counter <= (others => '0');
                new_sig <= noisy;
                button_debounced <= noisy;
            elsif noisy /= new_sig then
                new_sig <= noisy;
                counter <= (others => '0');
            elsif counter = DELAY then
                button_debounced <= new_sig;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
end Behavioral;
