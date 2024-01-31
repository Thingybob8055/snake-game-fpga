----------------------------------------------------------------------------------
-- Author: Akshay Gopinath 
-- Module Name: four_digits - Behavioral
-- Dependancies: decoder_2_4, mux4_1, one_digit
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

entity four_digits is
    Port ( d3 : in std_logic_vector (3 downto 0);
           d2 : in std_logic_vector (3 downto 0);
           d1 : in std_logic_vector (3 downto 0);
           d0 : in std_logic_vector (3 downto 0);
           ck : in std_logic;
           seg : out std_logic_vector (6 downto 0);
           an : out std_logic_vector (3 downto 0);
           dp : out std_logic);
end four_digits;

architecture Behavioral of four_digits is
    component decoder_2_4
    Port (
        a : in std_logic_vector (1 downto 0);
        y : out std_logic_vector (3 downto 0)
    );
    end component;

    component mux4_1
    Port (
        a : in std_logic_vector (3 downto 0);
        s : in std_logic_vector (1 downto 0);
        y : out std_logic
    );
    end component;

    component one_digit
    Port (
        digit : in std_logic_vector (3 downto 0);
        seg : out std_logic_vector (6 downto 0)
    );
    end component;

    signal count: unsigned (1 downto 0);

    signal mux_out_1: std_logic;
    signal mux_out_2: std_logic;
    signal mux_out_3: std_logic;
    signal mux_out_4: std_logic;

begin
    process(ck)
    begin
        if rising_edge(ck) then
            if count = 3 then
                count <= "00";
            else
                count <= count + 1;
            end if;
        end if;
    end process;

    U1: decoder_2_4 Port map (
        a => std_logic_vector(count),
        y => an
    );

    -- the first mux takes input d0(0), d1(0), d2(0), d3(0)
    U2: mux4_1 Port map (
        a(0) => d0(0),
        a(1) => d1(0),
        a(2) => d2(0),
        a(3) => d3(0),
        s => std_logic_vector(count),
        y => mux_out_1
    );

    -- the second mux takes input d0(1), d1(1), d2(1), d3(1)
    U3: mux4_1 Port map (
        a(0) => d0(1),
        a(1) => d1(1),
        a(2) => d2(1),
        a(3) => d3(1),
        s => std_logic_vector(count),
        y => mux_out_2
    );

    -- the third mux takes input d0(2), d1(2), d2(2), d3(2)
    U4: mux4_1 Port map (
        a(0) => d0(2),
        a(1) => d1(2),
        a(2) => d2(2),
        a(3) => d3(2),
        s => std_logic_vector(count),
        y => mux_out_3
    );

    -- the fourth mux takes input d0(3), d1(3), d2(3), d3(3)
    U5: mux4_1 Port map (
        a(0) => d0(3),
        a(1) => d1(3),
        a(2) => d2(3),
        a(3) => d3(3),
        s => std_logic_vector(count),
        y => mux_out_4
    );

    U6: one_digit Port map (
        digit(0) => mux_out_1,
        digit(1) => mux_out_2,
        digit(2) => mux_out_3,
        digit(3) => mux_out_4,
        seg => seg
    );

    -- if count = 2, display dp = 0 else dp = 1
    dp <= '0' when count = 2 else '1';

end Behavioral;
