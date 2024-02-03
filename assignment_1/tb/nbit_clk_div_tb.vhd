----------------------------------------------------------------------------------
-- Author: Akshay Gopinath 
-- Module Name: nbit_clk_div_tb - Behavioral
-- Dependancies: nbit_clk_div
-- Project Name: CE339 Assignment 1
-- Target Devices: Digilent Basys 3 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity nbit_clk_div_tb is
--  Port ( );
end nbit_clk_div_tb;

architecture Behavioral of nbit_clk_div_tb is
    constant div_factor : NATURAL := 200000;
    constant high_count : NATURAL := div_factor/2;
    constant num_of_bits : NATURAL := 18;

    Component nbit_clk_div is
        Generic ( div_factor : NATURAL;
                  high_count : NATURAL;
                  num_of_bits : NATURAL
                );
        Port ( clk_in : in STD_LOGIC;
               output : out STD_LOGIC
             );
    end Component;

    --Inputs
   Signal clk : std_logic := '0';

  --Outputs
   Signal clk_out : std_logic;

    -- Clock period definitions
   constant clk_period : time := 10 ns;

begin
    dut : nbit_clk_div
        Generic Map ( div_factor => div_factor,
                      high_count => high_count,
                      num_of_bits => num_of_bits
                    )
        Port Map ( clk_in => clk,
                   output => clk_out
                 );

    -- creating clock
   clk_50_process :process
   begin
  clk <= '0';
  wait for clk_period/2;
  clk <= '1';
  wait for clk_period/2;
   end process;

   -- Stimulus process
   stim_proc: process
   begin  
      wait for 100 ns; 
      wait for clk_period*10;
      wait;
   end process;

end Behavioral;
