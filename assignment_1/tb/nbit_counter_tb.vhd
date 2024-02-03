----------------------------------------------------------------------------------
-- Author: Akshay Gopinath 
-- Module Name: nbit_counter_tb - Behavioral
-- Dependancies: nbit_counter
-- Project Name: CE339 Assignment 1
-- Target Devices: Digilent Basys 3 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity nbit_counter_tb is
--  Port ( );
end nbit_counter_tb;

architecture Behavioral of nbit_counter_tb is
    constant width : integer := 6;
    constant modulo : integer := 60;

    Component nbit_counter is
        Generic (width  : NATURAL := 4;
                 modulo : NATURAL := 16);
        Port ( clk : in STD_LOGIC;
               cin : in STD_LOGIC;
               negate : in STD_LOGIC;
               rst : in STD_LOGIC;
               cout : out STD_LOGIC;
               output : out STD_LOGIC_VECTOR ((width-1) downto 0));
    end Component;

    Signal clk : STD_LOGIC;
    Signal negate : STD_LOGIC;
    Signal rst : STD_LOGIC;
    Signal counter : STD_LOGIC_VECTOR ((width-1) downto 0);
    Signal cinput : STD_LOGIC := '1';
    Signal coutput : STD_LOGIC;

begin
    negate <= '0';
    dut : nbit_counter
        GENERIC MAP (width => width,
                     modulo => modulo)
        PORT MAP (clk => clk,
                  cin => cinput,
                  negate => negate,
                  rst => rst,
                  cout => coutput,
                  output => counter);

    clock_process :process
    begin
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process;

    stim_proc: process
    begin        
    -- hold reset state for 100 ns.
    rst <= '0';
    wait for 20 ns;
    wait for 20 ns;
    wait for 20 ns;
    wait;
    end process;

end Behavioral;
