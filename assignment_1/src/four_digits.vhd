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
    Port ( d3 : in STD_LOGIC_VECTOR (3 downto 0);
           d2 : in STD_LOGIC_VECTOR (3 downto 0);
           d1 : in STD_LOGIC_VECTOR (3 downto 0);
           d0 : in STD_LOGIC_VECTOR (3 downto 0);
           ck : in STD_LOGIC;
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           dp : out STD_LOGIC);
end four_digits;

architecture Behavioral of four_digits is
    Component decoder_2_4
    port (
        a : in STD_LOGIC_VECTOR (1 downto 0);
        y : out STD_LOGIC_VECTOR (3 downto 0)
    );
    End Component;

    Component mux4_1
    port (
        a : in STD_LOGIC_VECTOR (3 downto 0);
        s : in STD_LOGIC_VECTOR (1 downto 0);
        y : out STD_LOGIC
    );
    End Component;

    Component one_digit
    port (
        digit : in STD_LOGIC_VECTOR (3 downto 0);
        seg : out STD_LOGIC_VECTOR (6 downto 0);
        an : out STD_LOGIC_VECTOR (3 downto 0);
        dp : out STD_LOGIC
    );
    End Component;

    Signal count: UNSIGNED (1 downto 0);

    Signal mux_out_1: STD_LOGIC;
    Signal mux_out_2: STD_LOGIC;
    Signal mux_out_3: STD_LOGIC;
    Signal mux_out_4: STD_LOGIC;

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

    U1: decoder_2_4 PORT MAP (
        a => STD_LOGIC_VECTOR(count),
        y => an
    );

    -- the first mux takes input d0(0), d1(0), d2(0), d3(0)
    U2: mux4_1 PORT MAP (
        a(0) => d0(0),
        a(1) => d1(0),
        a(2) => d2(0),
        a(3) => d3(0),
        s => STD_LOGIC_VECTOR(count),
        y => mux_out_1
    );

    -- the second mux takes input d0(1), d1(1), d2(1), d3(1)
    U3: mux4_1 PORT MAP (
        a(0) => d0(1),
        a(1) => d1(1),
        a(2) => d2(1),
        a(3) => d3(1),
        s => STD_LOGIC_VECTOR(count),
        y => mux_out_2
    );

    -- the third mux takes input d0(2), d1(2), d2(2), d3(2)
    U4: mux4_1 PORT MAP (
        a(0) => d0(2),
        a(1) => d1(2),
        a(2) => d2(2),
        a(3) => d3(2),
        s => STD_LOGIC_VECTOR(count),
        y => mux_out_3
    );

    -- the fourth mux takes input d0(3), d1(3), d2(3), d3(3)
    U5: mux4_1 PORT MAP (
        a(0) => d0(3),
        a(1) => d1(3),
        a(2) => d2(3),
        a(3) => d3(3),
        s => STD_LOGIC_VECTOR(count),
        y => mux_out_4
    );

    U6: one_digit PORT MAP (
        digit(0) => mux_out_1,
        digit(1) => mux_out_2,
        digit(2) => mux_out_3,
        digit(3) => mux_out_4,
        seg => seg,
        an => an,
        dp => dp
    );

    -- if count = 2, display dp = 0 else dp = 1
    dp <= '0' when count = 2 else '1';

end Behavioral;
