library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Debounce is
    Generic (DELAY : integer := 400000); --  configurable delay
    Port ( clk : in STD_LOGIC; -- clock
           rst : in STD_LOGIC; -- reset
           noisy : in STD_LOGIC; -- unfiltered signal
           button_debounced : out STD_LOGIC); -- debounced signal
end Debounce;

architecture Behavioral of Debounce is
    signal counter : unsigned(19 downto 0);
    signal new_sig : std_logic;
begin
    process(clk, rst)
    begin
        if rising_edge(clk) then
            if rst = '1' then -- reset
                counter <= (others => '0');
                new_sig <= noisy;
                button_debounced <= noisy;
            elsif noisy /= new_sig then -- if signal changes
                new_sig <= noisy;
                counter <= (others => '0');
            elsif counter = DELAY then
                button_debounced <= new_sig; -- debounced signal
            else
                counter <= counter + 1; -- increment counter
            end if;
        end if;
    end process;
end Behavioral;
