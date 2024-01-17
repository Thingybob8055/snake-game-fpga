----------------------------------------------------------------------------------
-- Author: Akshay Gopinath 
-- Module Name: state_machine - Behavioral
-- Dependancies: nbit_bcd_counter
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

entity state_machine is
    Port ( orig_clk : in STD_LOGIC; 
           ck : in STD_LOGIC;
           btnC, btnU, btnD : in STD_LOGIC;
           btnC_debounced, btnU_debounced, btnD_debounced : in STD_LOGIC;
           output : out STD_LOGIC_VECTOR (15 downto 0)
        );
end state_machine;

architecture Behavioral of state_machine is
    Signal bcd_counter_out_min : STD_LOGIC_VECTOR (7 downto 0);
    Signal bcd_clock_min : STD_LOGIC := '0';
    Signal bcd_up_down_min : STD_LOGIC := '0';
    Signal bcd_cout_min : STD_LOGIC := '0';
    Signal bcd_is_zero_min : STD_LOGIC := '0';

    Signal bcd_counter_out_sec : STD_LOGIC_VECTOR (7 downto 0);
    Signal bcd_clock_sec : STD_LOGIC := '0';
    Signal bcd_up_down_sec : STD_LOGIC := '0';
    Signal bcd_cout_sec : STD_LOGIC := '0';
    Signal bcd_is_zero_sec : STD_LOGIC := '0';

    constant bcd_width : NATURAL := 8;
    constant max_value_minutes : NATURAL := 60;
    constant max_value_seconds : NATURAL := 59;

    Signal btn_reg : STD_LOGIC;

    type STATE is (STATE_SET, STATE_GO);
    Signal CURRENT_STATE, NEXT_STATE: STATE := STATE_SET;

    Signal reset_signal : STD_LOGIC := '1';
    Signal bcd_counter_sec_reset : STD_LOGIC := '1';

    Signal bcd_is_zero_sec_int : STD_LOGIC := '0';
begin
    -- SYNC_PROCESS: process(btnC_debounced, reset_signal)
    -- begin
    --     if rising_edge(ck) begin
    --         if reset_signal = '1' then
    --             CURRENT_STATE <= STATE_SET;
    --         else
    --             if (btnC_debounced = '1') then
    --                 CURRENT_STATE <= NEXT_STATE;
    --             else
    --                 CURRENT_STATE <= CURRENT_STATE;
    --             end if;
    --         end if;
    --     end if;
    -- end process;

    SYNC_PROCESS: process(btnC_debounced, reset_signal)
    begin
        if (reset_signal = '1') then
            CURRENT_STATE <= STATE_SET;
        elsif rising_edge(btnC_debounced) then
            CURRENT_STATE <= NEXT_STATE;
        else
            CURRENT_STATE <= CURRENT_STATE;
        end if;
    end process;

    OUTPUT_DECODE : process(CURRENT_STATE, btnU_debounced, btnD_debounced)
    begin
        if rising_edge(orig_clk) then
            case CURRENT_STATE is
                when STATE_SET =>
                    -- increment the minutes counter if btnU is pressed and if btnD is pressed decrement the minutes counter
                    bcd_up_down_min <= btn_reg;
                    bcd_clock_min <= (btnU_debounced or (btnD_debounced and bcd_is_zero_sec_int));
                    bcd_clock_sec <= (btnU_debounced or btnD_debounced);
                    bcd_up_down_sec <= '0';
                    bcd_counter_sec_reset <= (btnU_debounced or btnD_debounced);
                    NEXT_STATE <= STATE_GO;
                when STATE_GO =>
                    -- decrement secounds counter
                    bcd_up_down_sec <= '1';
                    bcd_up_down_min <= '1';
                    bcd_clock_sec <= ck;
                    bcd_clock_min <= bcd_cout_sec;
                    bcd_counter_sec_reset <= '0';
                    NEXT_STATE <= STATE_SET;
            end case;
        end if;

        -- case CURRENT_STATE is
        --     when STATE_SET =>
        --         -- increment the minutes counter if btnU is pressed and if btnD is pressed decrement the minutes counter
        --         bcd_up_down_min <= btn_reg;
        --         bcd_clock_min <= (btnU_debounced or btnD_debounced);
        --         bcd_clock_sec <= bcd_clock_min;
        --         bcd_up_down_sec <= '0';
        --         bcd_counter_sec_reset <= bcd_clock_min;
        --     when STATE_GO =>
        --         -- decrement secounds counter
        --         bcd_up_down_sec <= '1';
        --         bcd_up_down_min <= '1';
        --         bcd_clock_sec <= ck;
        --         bcd_clock_min <= bcd_cout_sec;
        --         bcd_counter_sec_reset <= '0';
        -- end case;
    end process;

    -- STATE_DECODE : process(CURRENT_STATE, bcd_counter_out_min, bcd_counter_out_sec)
    -- begin
    --     if rising_edge(orig_clk) then
    --         case CURRENT_STATE is
    --             when STATE_SET =>
    --                 NEXT_STATE <= STATE_GO;
    --             when STATE_GO =>
    --                 NEXT_STATE <= STATE_SET;
    --             when others =>
    --                 NEXT_STATE <= STATE_SET;
    --         end case;
    --     end if;
    -- end process;

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
        if btnU = '1' then
            btn_reg <= '0';
        else
            if rising_edge(btnD) then
                btn_reg <= '1';   
            end if;
        end if;
    end process;
    
    process(ck)
    begin
        if rising_edge(ck) then
            reset_signal <= (bcd_is_zero_min and bcd_is_zero_sec);
            bcd_is_zero_sec_int <= bcd_is_zero_sec;
        end if;
    end process;
    

    output(7 downto 0) <= bcd_counter_out_sec;
    output(15 downto 8) <= bcd_counter_out_min;

end Behavioral;