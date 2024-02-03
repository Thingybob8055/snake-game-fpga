----------------------------------------------------------------------------------
-- Author: Akshay Gopinath 
-- Module Name: nbit_bcd_counter - Behavioral
-- Dependancies: None
-- Project Name: CE339 Assignment 1
-- Target Devices: Digilent Basys 3 
----------------------------------------------------------------------------------

---------------------------------------------------
-- This module is a 2 digit BCD counter that can be used to count up or down for 2 7 segment displays
-- The counter can be reset and has a carry out signal to chain multiple counters
-- The counter can be set to count up or down using the up_down signal
-- The max value can be configured using the max_value generic between 0 and 99
-- The bcd+width generic need to set depending on the max value and how many bits is needed to represent the max value
---------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity nbit_bcd_counter is
    Generic (bcd_width : natural := 8;   -- 4 or 8
             max_value : natural := 60   -- 0 to 99
    );   
    Port ( orig_clk : in std_logic;      -- 100MHz clock for synchronisation
           clk : in std_logic;           -- a divided clock for the counter (used as an enabler for the counter)
           up_down : in std_logic;       -- 0 for up, 1 for down
           reset : in std_logic;         -- reset the counter
           cout : out std_logic;         -- carry out signal
           is_zero : out std_logic;      -- 1 when the counter is at 0, 0 otherwise
           output : out std_logic_vector ((bcd_width-1) downto 0));  -- output of the counter
end nbit_bcd_counter;

architecture Behavioral of nbit_bcd_counter is
    signal count_1 : unsigned (3 downto 0) := (others => '0');  -- 4 bit counter for the 1's place
    signal count_2 : unsigned (3 downto 0) := (others => '0');  -- 4 bit counter for the 10's place
    signal cout_int : std_logic := '0';                         -- internal carry out signal
    signal last_clk : std_logic := '0';                         -- last clock signal for synchronisation
begin
    process(orig_clk, clk , up_down, reset)
    begin
        if reset = '1' then                 -- reset the counter
            count_1 <= (others => '0');     
            count_2 <= (others => '0');
            last_clk <= '0';                -- reset the last clock signal
        elsif rising_edge(orig_clk) then    
            last_clk <= clk;                -- synchronise the last clock signal
            if (clk = '1' and last_clk = '0') then
                if up_down = '0' then
                    count_1 <= count_1 + 1;     -- count up and reset the 1's place counter if it reaches 9
                    if count_1 = "1001" then
                        count_1 <= "0000";
                        count_2 <= count_2 + 1; -- count up and reset the 10's place counter if it reaches 9
                        if count_2 = "1001" then
                            count_2 <= "0000";
                        end if;
                    end if;
                else
                    if count_1 = "0000" then   -- count down and reset the 1's place counter if it reaches 0
                        count_1 <= "1001";
                        if count_2 = "0000" then
                            count_2 <= "1001";
                        else
                            count_2 <= count_2 - 1;  -- count down and reset the 10's place counter if it reaches 0
                        end if;
                    else
                        count_1 <= count_1 - 1;
                    end if; 
                end if;

                if count_2 = "0000" and count_1 = "0000" then  -- set the carry out signal if the counter (syncronised to the clock) is at 0
                    cout_int <= '1';
                else
                    cout_int <= '0';
                end if;
                -- reset the counter if the max value is reached
                if (count_2 = (to_unsigned(max_value/10, 4)) and count_1 = (to_unsigned(max_value mod 10, 4))) and up_down = '0' then
                    count_2 <= "0000";  -- reset the both counters
                    count_1 <= "0000";
                elsif (count_2 = "0000" and count_1 = "0000") and up_down = '1' then
                    count_2 <= (to_unsigned(max_value/10, 4));      -- set the counters to the max value if counting down and the counter is at 0
                    count_1 <= (to_unsigned(max_value mod 10, 4));
                end if;
            end if;
        end if;
    end process;

    cout <= cout_int;  -- set the carry out signal

    is_zero <= '1' when (count_2 = "0000" and count_1 = "0000") else '0';   -- set the is_zero signal if output is 0 (combinateional logic)

    -- output is the concatenation of count_2 and count_1 if bcd_width = 8, if bcd_width = 4 then output is count_1
    output <= std_logic_vector(count_2 & count_1) when bcd_width = 8 else std_logic_vector(count_1);

end Behavioral;