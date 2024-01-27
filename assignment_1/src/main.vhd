----------------------------------------------------------------------------------
-- Author: Akshay Gopinath 
-- Module Name: main - Behavioral
-- Dependancies: nbit_clk_div, four_digits(one_digit), button_debounce, state_machine
-- Project Name: CE339 Assignment 1
-- Target Devices: Digilent Basys 3 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity main is
    Port (
        clk  : in  STD_LOGIC;
        btnU, btnD,  btnC  : in  STD_LOGIC; --btnL, btnR,
        seg  : out STD_LOGIC_VECTOR (6 downto 0);
        dp   : out STD_LOGIC;
        an   : out STD_LOGIC_VECTOR (3 downto 0));
end main;

architecture Behavioral of main is
    constant div_factor_500Hz : NATURAL := 200000;
    constant high_count_500Hz : NATURAL := div_factor_500Hz/2;
    constant num_of_bits_500Hz : NATURAL := 18;
    
    constant div_factor_4hz : NATURAL := 25000000;
    constant high_count_4hz : NATURAL := div_factor_4hz/2;
    constant num_of_bits_4hz : NATURAL := 25;

    constant div_factor_1hz : NATURAL := 100000000;
    constant high_count_1hz : NATURAL := div_factor_1hz/2;
    constant num_of_bits_1hz : NATURAL := 27;

    constant bcd_width : NATURAL := 8;
    constant max_value_minutes : NATURAL := 60;
    constant max_value_seconds : NATURAL := 59;

    Signal clk_500hz : STD_LOGIC;
    Signal clk_4hz : STD_LOGIC;
    Signal clk_1hz : STD_LOGIC;
    Signal btnC_debounced : STD_LOGIC;
    Signal btnU_debounced : STD_LOGIC;
    Signal btnD_debounced : STD_LOGIC;

    Signal state_machine_out : STD_LOGIC_VECTOR (15 downto 0);

    Signal button_up_handle : STD_LOGIC;
    Signal button_down_handle : STD_LOGIC;

begin

    -- instantiate a clock divider for the 500Hz clock
    clk_div_unit_500hz : entity work.nbit_clk_div(Behavioral)
        Generic map (div_factor => div_factor_500Hz,
                     high_count => high_count_500Hz,
                     num_of_bits => num_of_bits_500Hz)
        Port map (clk_in => clk, output => clk_500hz);

    -- instantiate a clock divider for the 4Hz clock
    clk_div_unit_4hz : entity work.nbit_clk_div(Behavioral)
        Generic map (div_factor => div_factor_4hz,
                     high_count => high_count_4hz,
                     num_of_bits => num_of_bits_4hz)
        Port map (clk_in => clk, output => clk_4hz);

    -- instantiate a clock divider for the 1Hz clock
    clk_div_unit_1hz : entity work.nbit_clk_div(Behavioral)
        Generic map (div_factor => div_factor_1hz,
                     high_count => high_count_1hz,
                     num_of_bits => num_of_bits_1hz)
        Port map (clk_in => clk, output => clk_1hz);

    -- instantiate one four_digits_unit decoder that will decode and
    -- and display one of the four digits
    four_digits_unit : entity work.four_digits(Behavioral)
        Port map (d3 => state_machine_out(15 downto 12),
                  d2 => state_machine_out(11 downto 8),
                  d1 => state_machine_out(7 downto 4),
                  d0 => state_machine_out(3 downto 0),
                  ck => clk_500hz, seg => seg, an => an, dp => dp);

    -- instantiate a button debouncer for btnC
    button_debounce_unit_center : entity work.button_debounce(Behavioral)
        Port map (clk => clk_4hz, button => btnC, debounce_out => btnC_debounced);
        
    -- instantiate a button debouncer for btnU
    button_debounce_unit_up : entity work.button_debounce(Behavioral)
        Port map (clk => clk_4hz, button => btnU, debounce_out => btnU_debounced);
             
    -- instantiate a button debouncer for btnD
    button_debounce_unit_down : entity work.button_debounce(Behavioral)
        Port map (clk => clk_4hz, button => btnD, debounce_out => btnD_debounced);

    -- instantiate a button handler for btnU
    button_handler_unit_up : entity work.button_handler(Behavioral)
        Port map (clk => clk, btn => btnU_debounced, btn_press => button_up_handle);

    -- instantiate a button handler for btnD
    button_handler_unit_down : entity work.button_handler(Behavioral)
        Port map (clk => clk, btn => btnD_debounced, btn_press => button_down_handle);

    -- instantiate a state machine for thr control logic
    state_machine_unit : entity work.state_machine(Behavioral)
        Port map (orig_clk => clk, ck => clk_1hz, btnC_debounced => btnC_debounced, btnU_debounced => button_up_handle, 
                  btnD_debounced => button_down_handle, btnU => btnU, btnD => btnD, output => state_machine_out);


end Behavioral;