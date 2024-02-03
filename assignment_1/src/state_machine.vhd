----------------------------------------------------------------------------------
-- Author: Akshay Gopinath 
-- Module Name: state_machine - Behavioral
-- Dependancies: nbit_bcd_counter
-- Project Name: CE339 Assignment 1
-- Target Devices: Digilent Basys 3 
----------------------------------------------------------------------------------

---------------------------------------------------
-- This is the finite state machine module that defines the control logic for the timer
-- The module has two states, STATE_SET and STATE_GO
-- In STATE_SET, the minutes counter is incremented or decremented based on the btnU and btnD inputs
-- In STATE_GO, the seconds counter is decremented at a rate of 1Hz
-- In STATE_GO, the minutes counter is decremented when the seconds counter reaches 0
-- The module also instantiates two BCD counters, one for minutes and one for seconds
---------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity state_machine is
    Port ( orig_clk : in std_logic;                                       -- 100MHz clock
           ck : in std_logic;                                             -- 1Hz clock
           btnU, btnD : in std_logic;                                     -- Up and Down buttons (un debounced)
           btnC_debounced, btnU_debounced, btnD_debounced : in std_logic; -- Debounced button pulses from the button handler module
           output : out std_logic_vector (15 downto 0)                    -- Output to the 7-segment display multiplexer
        );
end state_machine;

architecture Behavioral of state_machine is
    signal bcd_counter_out_min : std_logic_vector (7 downto 0);           -- BCD counter output for minutes
    signal bcd_clock_min : std_logic := '0';                              -- Clock signal for the minutes counter
    signal bcd_up_down_min : std_logic := '0';                            -- Up/Down signal for the minutes counter
    signal bcd_cout_min : std_logic := '0';                               -- Carry out signal for the minutes counter
    signal bcd_is_zero_min : std_logic := '0';                            -- Zero signal for the minutes counter

    signal bcd_counter_out_sec : std_logic_vector (7 downto 0);           -- BCD counter output for seconds
    signal bcd_clock_sec : std_logic := '0';                              -- Clock signal for the seconds counter
    signal bcd_up_down_sec : std_logic := '0';                            -- Up/Down signal for the seconds counter
    signal bcd_cout_sec : std_logic := '0';                               -- Carry out signal for the seconds counter
    signal bcd_is_zero_sec : std_logic := '0';                            -- Zero signal for the seconds counter

    constant bcd_width : natural := 8;                                    -- BCD counter width
    constant max_value_minutes : natural := 60;                           -- Max value for minutes counter
    constant max_value_seconds : natural := 59;                           -- Max value for seconds counter

    signal btn_reg : std_logic;                                           -- Register to store the state to increment the minutes counter

    type STATE is (STATE_SET, STATE_GO);                                  -- Enum type for the state machine
    signal CURRENT_STATE, NEXT_STATE: STATE := STATE_SET;                 -- Current and next state signals

    signal reset_signal : std_logic := '1';                               -- Internal reset signal for the state machine
    signal bcd_counter_sec_reset : std_logic := '1';                      -- Reset signal for the seconds counter  

    signal bcd_is_zero_sec_int : std_logic := '0';                        -- Internal zero signal for the seconds counter
begin

    SYNC_PROCESS: process(btnC_debounced, reset_signal)
    begin
        if (reset_signal = '1') then        -- reset the state machine
            CURRENT_STATE <= STATE_SET;
        elsif rising_edge(btnC_debounced) then
            CURRENT_STATE <= NEXT_STATE;    -- update the state (sequential logic)
        else
            CURRENT_STATE <= CURRENT_STATE; -- keep the current state
        end if;
    end process;

    OUTPUT_DECODE : process(CURRENT_STATE, btnU_debounced, btnD_debounced)
    begin
        if rising_edge(orig_clk) then
            case CURRENT_STATE is
                when STATE_SET =>
                    -- increment the minutes counter if btnU is pressed and if btnD is pressed decrement the minutes counter
                    bcd_up_down_min <= btn_reg;      -- btn_reg used to decide if the counter should be incremented or decremented
                    -- if the seconds counter is zero, then the minutes counter can be incremented or decremented
                    bcd_clock_min <= (btnU_debounced or (btnD_debounced and bcd_is_zero_sec_int));
                    bcd_clock_sec <= (btnU_debounced or btnD_debounced);    -- decrement or increment the seconds counter if btnU or btnD is pressed
                    bcd_up_down_sec <= '0';      -- Seconds counter is not changed in this state
                    bcd_counter_sec_reset <= (btnU_debounced or btnD_debounced);  -- Reset the seconds counter if btnU or btnD is pressed
                    NEXT_STATE <= STATE_GO;     -- Change the state to STATE_GO if the clock is pressed (center button)
                when STATE_GO =>
                    -- decrement secounds counter
                    bcd_up_down_sec <= '1';   -- Decrement the seconds counter
                    bcd_up_down_min <= '1';   -- Decrement the minutes counter
                    bcd_clock_sec <= ck;      -- Clock signal for the seconds counter (1Hz)
                    bcd_clock_min <= bcd_cout_sec;  -- Minutes counter is decremented when the seconds counter reaches 0
                    bcd_counter_sec_reset <= '0';   -- Do not reset the seconds counter
                    NEXT_STATE <= STATE_SET;      -- Change the state to STATE_SET if the clock is pressed (center button)
            end case;
        end if;
    end process;

    -- instantiate BCD counter for minutes
    bcd_counter_unit : entity work.nbit_bcd_counter(Behavioral)
        Generic map (bcd_width => bcd_width, max_value => max_value_minutes)
        Port map (orig_clk => orig_clk, clk => bcd_clock_min, up_down => bcd_up_down_min, reset=>'0', cout => bcd_cout_min, is_zero => bcd_is_zero_min, output => bcd_counter_out_min);

    -- instantiate BCD counter for seconds
    bcd_counter_unit_1 : entity work.nbit_bcd_counter(Behavioral)
        Generic map (bcd_width => bcd_width, max_value => max_value_seconds)
        Port map (orig_clk => orig_clk, clk => bcd_clock_sec, up_down => bcd_up_down_sec, reset => bcd_counter_sec_reset, cout => bcd_cout_sec, is_zero => bcd_is_zero_sec, output => bcd_counter_out_sec);

    process(btnD, btnU)
    begin
        if btnU = '1' then   -- if btnU is pressed, set the register to increment the minutes counter
            btn_reg <= '0';
        else
            if rising_edge(btnD) then
                btn_reg <= '1';     -- if btnD is pressed, set the register to decrement the minutes counter
            end if;
        end if;
    end process;
    
    process(ck)
    begin
        if rising_edge(ck) then
            reset_signal <= (bcd_is_zero_min and bcd_is_zero_sec);  -- reset the state machine if both the minutes and seconds counters are zero
            bcd_is_zero_sec_int <= bcd_is_zero_sec;   -- internal signal to check if the seconds counter is zero
        end if;
    end process;
    

    output(7 downto 0) <= bcd_counter_out_sec;  -- output the seconds counter to the 7-segment display
    output(15 downto 8) <= bcd_counter_out_min; -- output the minutes counter to the 7-segment display

end Behavioral;