----------------------------------------------------------------------------------
-- Author: Akshay Gopinath 
-- Module Name: nbit_bcd_counter_tb - Behavioral
-- Dependancies: nbit_bcd_counter
-- Project Name: CE339 Assignment 1
-- Target Devices: Digilent Basys 3 
----------------------------------------------------------------------------------



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity nbit_bcd_counter_tb is
--  Port ( );
end nbit_bcd_counter_tb;

architecture Behavioral of nbit_bcd_counter_tb is
    constant bcd_width : NATURAL := 8;
    constant max_value : NATURAL := 59;
    
    Component nbit_bcd_counter is
        Generic (
            bcd_width : NATURAL;
            max_value : NATURAL
        );
        Port (
            orig_clk : in STD_LOGIC;
            clk : in STD_LOGIC;
            up_down : in STD_LOGIC;
            reset : in STD_LOGIC;
            cout : out STD_LOGIC;
            is_zero : out STD_LOGIC;
            output : out STD_LOGIC_VECTOR(bcd_width-1 downto 0)
        );
    end Component;

    Signal orig_clk : STD_LOGIC;
    Signal clk : STD_LOGIC;
    Signal bcd_out : STD_LOGIC_VECTOR(bcd_width-1 downto 0);
    Signal up_down_sig : STD_LOGIC := '1';
    Signal reset_sig : STD_LOGIC := '0';
    Signal coutput : STD_LOGIC;
    Signal is_zero : STD_LOGIC;

begin
    dut : nbit_bcd_counter
        Generic Map (
            bcd_width => bcd_width,
            max_value => max_value
        )
        Port Map (
            orig_clk => orig_clk,
            clk => clk,
            up_down => up_down_sig,
            reset => reset_sig,
            cout => coutput,
            is_zero => is_zero,
            output => bcd_out
        );

        clock_process : process
        begin
            clk <= '0';
            wait for 10 ns;
            clk <= '1';
            wait for 10 ns;
        end process;

        orig_clock_process : process
        begin
            orig_clk <= '0';
            wait for 5 ns;
            orig_clk <= '1';
            wait for 5 ns;
        end process;

        stim_proc : process
        begin
        wait for 100 ns;
        wait for 100 ns;
        wait for 100 ns;
        wait for 100 ns;
        wait for 100 ns;
        wait for 100 ns;
        wait for 100 ns;
        wait for 100 ns;
        wait for 100 ns;
        reset_sig <= '1';
        wait for 10 ns;
        reset_sig <= '0';
        wait for 100 ns;
        wait;
        end process;

end Behavioral;
