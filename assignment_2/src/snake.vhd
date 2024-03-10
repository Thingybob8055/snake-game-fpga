library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use ieee.math_real.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga_top_file_test is
    Port ( clk : in STD_LOGIC;
           vgaRed : out STD_LOGIC_VECTOR (3 downto 0);
           vgaGreen : out STD_LOGIC_VECTOR (3 downto 0);
           vgaBlue : out STD_LOGIC_VECTOR (3 downto 0);
           HS : out STD_LOGIC;
           VS : out STD_LOGIC);
end vga_top_file_test;

architecture Behavioral of vga_top_file_test is
    Signal blanking : std_logic;
    Signal pixel_clk : std_logic;
    Signal hcount   :   unsigned(10 downto 0);
    Signal vcount   :   unsigned(10 downto 0);

    -- for color gradient
    Signal square : std_logic;
    Signal paint_red : STD_LOGIC_VECTOR(3 downto 0);
    Signal paint_green : STD_LOGIC_VECTOR(3 downto 0);
    Signal paint_blue : STD_LOGIC_VECTOR(3 downto 0);

begin


    vga_controller : entity work.vga_controller_640_60(Behavioral)
        Port map (rst => '0', pixel_clk => pixel_clk, HS => HS, VS => VS, hcount => hcount, vcount => vcount, blank => blanking);

    clk_div_unit_1hz : entity work.nbit_clk_div(Behavioral)
        Generic map (div_factor => 4,
                     high_count => 2,
                     num_of_bits => 3)
        Port map (clk_in => clk, output => pixel_clk);

    paint_red <= "1111";
    paint_blue <= "0000";
    paint_green <= "0000";

    vgaRed <= paint_red when blanking = '0' else (others => '0');
    vgaGreen <= paint_green when blanking = '0' else (others => '0');
    vgaBlue <= paint_blue when blanking = '0' else (others => '0');


end Behavioral;
