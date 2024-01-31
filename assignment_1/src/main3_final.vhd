----------------------------------------------------------------------------------
-- Author: Akshay Gopinath 
-- Module Name: main - Behavioral
-- Dependancies: nbit_clk_div, four_digits(one_digit), button_debounce, state_machine, button_handler
-- Project Name: CE339 Assignment 1
-- Target Devices: Digilent Basys 3 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity main is
    Port (
        clk  : in  std_logic;
        btnU, btnD,  btnC  : in  std_logic;
        seg  : out std_logic_vector (6 downto 0);
        dp   : out std_logic;
        an   : out std_logic_vector (3 downto 0));
end main;

architecture Behavioral of main is
    constant div_factor_500Hz : natural := 200000;
    constant high_count_500Hz : natural := div_factor_500Hz/2;
    constant num_of_bits_500Hz : natural := 18;
    
    constant div_factor_4hz : natural := 25000000;
    constant high_count_4hz : natural := div_factor_4hz/2;
    constant num_of_bits_4hz : natural := 25;

    constant div_factor_1hz : natural := 100000000;
    constant high_count_1hz : natural := div_factor_1hz/2;
    constant num_of_bits_1hz : natural := 27;

    constant bcd_width : natural := 8;
    constant max_value_minutes : natural := 60;
    constant max_value_seconds : natural := 59;

    signal clk_500hz : std_logic;
    signal clk_4hz : std_logic;
    signal clk_1hz : std_logic;
    signal btnC_debounced : std_logic;
    signal btnU_debounced : std_logic;
    signal btnD_debounced : std_logic;

    signal state_machine_out : std_logic_vector (15 downto 0);

    signal button_up_handle : std_logic;
    signal button_down_handle : std_logic;

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