----------------------------------------------------------------------------------
-- Author: Akshay Gopinath 
-- Module Name: button_handler - Behavioral
-- Dependancies: None
-- Project Name: CE339 Assignment 1
-- Target Devices: Digilent Basys 3 
----------------------------------------------------------------------------------

---------------------------------------------------
-- This module is to handle the button press and
-- To generate a pulse when the button is pressed or held down
---------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity button_handler is 
    Port (
        clk : in std_logic;          -- clock input (100MHz)
        btn : in std_logic;          --  debounced button input
        btn_press : out std_logic);  -- pulse output when button is pressed
end button_handler;

architecture Behavioral of button_handler is
    constant no_of_thresholds_to_increment : integer := 15; -- how many thresholds to increment the multiplier (incease the speed)
begin
    process(clk, btn)
        variable counter : integer := 0;          -- counter to count the number of clock cycles
        variable no_of_thresholds : integer := 0; -- counter to count the number of thresholds
        variable multiplier : integer := 1;       -- multiplier to increase the speed
    begin
        if rising_edge(clk) then
            if btn = '1' then   -- button is pressed
                counter := counter + multiplier;  -- increment the counter
                if counter = 20000000 then  -- 20000000 clock cycles = 200ms
                    counter := 0;  -- reset the counter
                    no_of_thresholds := no_of_thresholds + 1;  -- increment the threshold counter
                    if no_of_thresholds = no_of_thresholds_to_increment then
                        -- cap the multiplier at 2
                        if multiplier < 2 then
                            multiplier := multiplier + 1;  -- increase the multiplier
                        end if;
                        no_of_thresholds := 0;   -- reset the threshold counter
                    end if;
                    btn_press <= '1';   -- generate a pulse
                else
                    btn_press <= '0';
                end if;
            else
                counter := 0;    -- reset the all values when button is not pressed
                no_of_thresholds := 0;
                multiplier := 1;
                btn_press <= '0';
            end if;
        end if;
    end process;

end Behavioral;