----------------------------------------------------------------------------------
-- Author: Akshay Gopinath 
-- Module Name: button_handler - Behavioral
-- Dependancies: None
-- Project Name: CE339 Assignment 1
-- Target Devices: Digilent Basys 3 
----------------------------------------------------------------------------------

-- when a button is held down, the module will convert it into multiple pulses of inreasing frequency
-- So that a counter will increment at an increasing rate when the button is held down. Just like a 7 segment display on a stopwatch

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity button_handler is 
    Port (
        clk : in std_logic;
        btn : in std_logic;
        btn_press : out std_logic
    );
end button_handler;

architecture Behavioral of button_handler is 
begin
    -- if button value is 1, then a counter increments and outputs a pulse to the btn_press output, which is a pulse of 200ms
    -- if button value is 0, then the counter is reset to 0 and the output is 0
    -- the clk is a 100MHz clock, so the counter increments at a rate of 100MHz
    process(clk, btn)
        variable counter : integer := 0;
    begin
        if rising_edge(clk) then
            if btn = '1' then
                counter := counter + 1;
                if counter = 20000000 then
                    counter := 0;
                    btn_press <= '1';
                else
                    btn_press <= '0';
                end if;
            else
                counter := 0;
                btn_press <= '0';
            end if;
        end if;
    end process;

end Behavioral;