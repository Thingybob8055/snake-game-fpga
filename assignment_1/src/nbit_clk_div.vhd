----------------------------------------------------------------------------------
-- Author: Akshay Gopinath 
-- Module Name: nbit_clk_div - Behavioral
-- Dependancies: nbit_counter
-- Project Name: CE339 Assignment 1
-- Target Devices: Digilent Basys 3 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity nbit_clk_div is
    Generic (
        div_factor : natural := 16;
        high_count : natural := 8; -- num of clk pulses until high; duty cycle = (div_factor - high_count) / div_factor
        num_of_bits : natural := 4
    );
    Port ( clk_in : in std_logic;
           output : out std_logic
    );
end nbit_clk_div;

architecture Behavioral of nbit_clk_div is
    component nbit_counter is
        Generic (
            width : natural;
            modulo : natural 
        );
        Port (
            clk: in std_logic;
            cin    : in  std_logic;
            negate: in std_logic;
            rst : in std_logic;
            cout   : out std_logic;
            output : out std_logic_vector((width-1) downto 0)
        );
    end component;
    signal ignore : std_logic;
    constant HI_TIME : std_logic_vector := std_logic_vector(to_unsigned(high_count-1, num_of_bits));
    signal counter_output : std_logic_vector((num_of_bits-1) downto 0);
begin
    counter : nbit_counter
    Generic Map (
        width => num_of_bits,
        modulo => div_factor
    )
    Port Map (
        clk => clk_in,
        cin => '1',
        negate => '0',
        rst => '0',
        cout => ignore,
        output => counter_output
    );

    process(clk_in)
        variable out_int : std_logic := '0';
    begin
        output <= out_int;
        if rising_edge(clk_in) then
            if counter_output <= HI_TIME then
                out_int := '1';
            else
                out_int := '0';
            end if;
        end if;
    end process;
--    output <= counter_output(num_of_bits - 1);
end Behavioral;
