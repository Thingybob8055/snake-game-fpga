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
        sw   : in  STD_LOGIC_VECTOR (15 downto 0);
        clk  : in  STD_LOGIC;
        btnU, btnD,  btnC  : in  STD_LOGIC; --btnL, btnR,
        LED  : out STD_LOGIC;
        seg  : out STD_LOGIC_VECTOR (6 downto 0);
        dp   : out STD_LOGIC;
        an   : out STD_LOGIC_VECTOR (3 downto 0));
end main;

architecture Behavioral of main is
    constant div_factor : NATURAL := 200000;
    constant high_count : NATURAL := div_factor/2;
    constant num_of_bits : NATURAL := 18;
    
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

    -- Signal bcd_counter_out : STD_LOGIC_VECTOR (7 downto 0);
    -- Signal bcd_clock : STD_LOGIC := '0';
    -- Signal bcd_up_down : STD_LOGIC := '0';

    -- Signal bcd_counter_out_1 : STD_LOGIC_VECTOR (7 downto 0);
    -- Signal bcd_clock_1 : STD_LOGIC := '0';
    -- Signal bcd_up_down_1 : STD_LOGIC := '0';
    -- Signal bcd_cout_1 : STD_LOGIC := '0';
    -- Signal bcd_cout : STD_LOGIC := '0';

    -- Signal state_machine_out : STD_LOGIC := '0';
    -- Signal temp : STD_LOGIC := '0';
    
    -- Signal btn_reg : STD_LOGIC;

    -- Signal state_machine_reset : STD_LOGIC := '0';
begin
--    LED <= '1' when bcd_counter_out = "00000000" and bcd_counter_out_1 = "00000000" else '0';
    -- bcd_clock <= bcd_cout_1 when state_machine_out = '1' else (btnD_debounced or btnU_debounced);
    -- bcd_up_down <= '1' when state_machine_out = '1' else btn_reg;
    -- process(btnD, btnU, state_machine_out, bcd_cout_1)
    -- begin
    --     if btnU = '1' then
    --         btn_reg <= '0';
    --     else
    --         if state_machine_out = '1' then
    --             if rising_edge(btnD) then
    --                 btn_reg <= '1';
    --             end if;
    --         elsif state_machine_out = '0' then
    --             btn_reg <= '1';
    --         end if;
    --     end if;
    -- end process;

    -- instantiate a clock divider for the 500Hz clock
    clk_div_unit : entity work.nbit_clk_div(Behavioral)
        Generic map (div_factor => div_factor,
                     high_count => high_count,
                     num_of_bits => num_of_bits)
        Port map (clk_in => clk, output => clk_500hz);

    -- instantiate a clock divider for the 4Hz clock
    clk_div_unit_4hz : entity work.nbit_clk_div(Behavioral)
        Generic map (div_factor => div_factor_4hz,
                     high_count => high_count_4hz,
                     num_of_bits => num_of_bits_4hz)
        Port map (clk_in => clk, output => clk_4hz);

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

    -- instantiate a state machine
    state_machine_unit : entity work.state_machine(Behavioral)
        Port map (orig_clk => clk, ck => clk_1hz, btnC_debounced => btnC_debounced, btnU_debounced => btnU_debounced, 
                  btnD_debounced => btnD_debounced, 
                  btnC => btnC, btnU => btnU, btnD => btnD, output => state_machine_out);


end Behavioral;