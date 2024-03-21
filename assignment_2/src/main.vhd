library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity main is
    Port ( clk_100mhz : in STD_LOGIC;					--  master clock 100MHz
           switch : in STD_LOGIC_VECTOR(7 downto 0);	-- switches 0-7
           btn_up : in STD_LOGIC;						-- up button
           btn_left : in STD_LOGIC;						-- left button
           btn_right : in STD_LOGIC;					-- right button
           btn_down : in STD_LOGIC;						-- down button
           led : out STD_LOGIC_VECTOR(7 downto 0);		-- leds 0-7
           vgared : out STD_LOGIC_VECTOR(3 downto 0);	-- vga red
           vgagreen : out STD_LOGIC_VECTOR(3 downto 0);	-- vga green
           vgablue : out STD_LOGIC_VECTOR(3 downto 0);	-- vga blue
           hsync : out STD_LOGIC;						-- horizontal sync
           vsync : out STD_LOGIC;						-- vertical sync
		   seg  : out std_logic_vector (6 downto 0); 	-- 7-segment display
           dp   : out std_logic; 						-- 7-segment display decimal point
           an   : out std_logic_vector (3 downto 0)		-- 7-segment display anodes
         );
end main;

architecture Behavioral of main is
    signal pixel_clk : std_logic;
    signal clk_500hz : std_logic;
    signal xCount : unsigned(10 downto 0);	-- x position from horizontal counter of vga driver
    signal yCount : unsigned(10 downto 0);  -- y position from vertical counter of vga driver
    signal rand_X : unsigned(6 downto 0);   -- x random position for the food
    signal rand_Y : unsigned(6 downto 0);	-- y random position for the foodq
    signal update : std_logic;				-- signal to update the game
    signal up : std_logic;					-- debounced up button
    signal down : std_logic;				-- debounced down button
    signal left : std_logic;				-- debounced left button
    signal right : std_logic;				-- debounced right button
    signal display : std_logic;				-- signal to display the game
begin
    -- connect the signals to the VGA controller
    vga_controller : entity work.vga_controller_640_60(Behavioral)
        Port map (rst => '0', pixel_clk => pixel_clk, HS => hsync, VS => vsync, hcount => xCount, vcount => yCount, blank => display);

	-- instantiate clock divider for 100MHz to 25MHz
    clk_div_unit_25Mhz : entity work.nbit_clk_div(Behavioral)
        Generic map (div_factor => 4,
                     high_count => 2,
                     num_of_bits => 3)
        Port map (clk_in => clk_100mhz, output => pixel_clk);

	-- instantiate clock divider for 100MHz to 500Hz
	clk_div_unit_500hz : entity work.nbit_clk_div(Behavioral)
        Generic map (div_factor => 200000,
                     high_count => 200000/2,
                     num_of_bits => 18)
        Port map (clk_in => clk_100mhz, output => clk_500hz);

    -- instatiate random grid
    random_grid : entity work.randomGrid(Behavioral)
        Port map (pixel_clk => pixel_clk, rand_X => rand_X, rand_Y => rand_Y);

	-- insitiate update clock
    update_clk : entity work.updateClk(Behavioral)
        Generic map (max_value => 4000000)
        Port map (clk_100mhz => clk_100mhz, update => update);

	-- instantiate debounce for buttons
    up_sig : entity work.Debounce(Behavioral)
        Port map (clk => pixel_clk, rst => '0', noisy => btn_up, button_debounced => up);

    down_sig : entity work.Debounce(Behavioral)
        Port map (clk => pixel_clk, rst => '0', noisy => btn_down, button_debounced => down);

    left_sig : entity work.Debounce(Behavioral)
        Port map (clk => pixel_clk, rst => '0', noisy => btn_left, button_debounced => left);

    right_sig : entity work.Debounce(Behavioral)
        Port map (clk => pixel_clk, rst => '0', noisy => btn_right, button_debounced => right);

    snake_logic: entity work.snake(Behavioral)
        Port map (
            clk_100mhz => clk_100mhz,
            pixel_clk => pixel_clk,
            update => update,
            clk_500hz => clk_500hz,
            xCount => xCount,
            yCount => yCount,
            rand_X => rand_X,
            rand_Y => rand_Y,
            switch => switch,
            btn_up => up,
            btn_left => left,
            btn_right => right,
            btn_down => down,
            display => display,
            led => led,
            vgared => vgared,
            vgagreen => vgagreen,
            vgablue => vgablue,
            seg => seg,
            dp => dp,
            an => an
        );


end Behavioral;
