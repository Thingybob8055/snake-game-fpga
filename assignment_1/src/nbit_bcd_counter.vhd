----------------------------------------------------------------------------------
-- Author: Akshay Gopinath 
-- Module Name: nbit_bcd_counter - Behavioral
-- Dependancies: None
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

entity nbit_bcd_counter is
    Generic (bcd_width : NATURAL := 8;
             max_value : NATURAL := 60 
    );   
    Port ( orig_clk : in STD_LOGIC;
           clk : in STD_LOGIC;
           up_down : in STD_LOGIC;
           reset : in STD_LOGIC;
           cout : out STD_LOGIC;
           is_zero : out STD_LOGIC;
           output : out STD_LOGIC_VECTOR ((bcd_width-1) downto 0));
end nbit_bcd_counter;

architecture Behavioral of nbit_bcd_counter is
    Signal count_1 : UNSIGNED (3 downto 0) := (others => '0');
    Signal count_2 : UNSIGNED (3 downto 0) := (others => '0');
    Signal cout_int : STD_LOGIC := '0';
    Signal last_clk : STD_LOGIC := '0';
begin
    process(orig_clk, clk , up_down, reset)
    begin
        if reset = '1' then
            count_1 <= (others => '0');
            count_2 <= (others => '0');
            last_clk <= '0';
        elsif rising_edge(orig_clk) then
            last_clk <= clk;
            if (clk = '1' and last_clk = '0') then
                if up_down = '0' then
                    count_1 <= count_1 + 1;
                    if count_1 = "1001" then
                        count_1 <= "0000";
                        count_2 <= count_2 + 1;
                        if count_2 = "1001" then
                            count_2 <= "0000";
                        end if;
                    end if;
                else
                    if count_1 = "0000" then
                        count_1 <= "1001";
                        if count_2 = "0000" then
                            count_2 <= "1001";
                        else
                            count_2 <= count_2 - 1;
                        end if;
                    else
                        count_1 <= count_1 - 1;
                    end if; 
                end if;

                if count_2 = "0000" and count_1 = "0000" then
                    cout_int <= '1';
                else
                    cout_int <= '0';
                end if;

                if (count_2 = (to_unsigned(max_value/10, 4)) and count_1 = (to_unsigned(max_value mod 10, 4))) and up_down = '0' then
                    count_2 <= "0000";
                    count_1 <= "0000";
                elsif (count_2 = "0000" and count_1 = "0000") and up_down = '1' then
                    count_2 <= (to_unsigned(max_value/10, 4)); 
                    count_1 <= (to_unsigned(max_value mod 10, 4));
                end if;
            end if;
        end if;
    end process;

    cout <= cout_int;

    is_zero <= '1' when (count_2 = "0000" and count_1 = "0000") else '0';

    -- output is the concatenation of count_2 and count_1 if bcd_width = 8, if bcd_width = 4 then output is count_1
    output <= STD_LOGIC_VECTOR(count_2 & count_1) when bcd_width = 8 else STD_LOGIC_VECTOR(count_1);

end Behavioral;