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


entity snake is
    Port ( clk_100mhz : in STD_LOGIC;
           switch : in STD_LOGIC_VECTOR(7 downto 0);
           btn_up : in STD_LOGIC;
           btn_enter : in STD_LOGIC;
           btn_left : in STD_LOGIC;
           btn_right : in STD_LOGIC;
           btn_down : in STD_LOGIC;
           led : out STD_LOGIC_VECTOR(7 downto 0);
           vgared : out STD_LOGIC_VECTOR(3 downto 0);
           vgagreen : out STD_LOGIC_VECTOR(3 downto 0);
           vgablue : out STD_LOGIC_VECTOR(3 downto 0);
           hsync : out STD_LOGIC;
           vsync : out STD_LOGIC
         );
end snake;

architecture Behavioral of snake is
    signal pixel_clk : STD_LOGIC;

    constant SIZE_INCREMENT : integer := 4;
    
    signal xCount : unsigned(10 downto 0);
    signal yCount : unsigned(10 downto 0);
    signal rand_X : unsigned(6 downto 0);
    signal rand_Y : unsigned(6 downto 0);
    signal size : unsigned(6 downto 0);
    signal pearX : unsigned(6 downto 0) := "0101000";
    signal pearY : unsigned(6 downto 0) := "0001010";
    signal display : std_logic;
    signal R : std_logic;
    signal G : std_logic;
    signal B : std_logic;
    signal game_over : std_logic;
    signal pear, border : std_logic;

    type snake_array is array (0 to 127) of unsigned(6 downto 0);
    -- type snakeY_array is array (0 to 127) of unsigned(6 downto 0);

    signal snakeX : snake_array;
    signal snakeY : snake_array;

    signal snakeBody : unsigned(127 downto 0);
    signal update : std_logic;
    signal direction : std_logic_vector(3 downto 0);

    signal count : integer;

    signal start : std_logic;

    signal up, down, left, right : std_logic;

    signal grid : std_logic;

    type rom_type is array (0 to 15) of std_logic_vector(0 to 15);
    constant ROM : rom_type := 
    (
        "0000011111100000",
        "0001110101011000",
        "0010000010101100",
        "0110000000010110",
        "0100000001010110",
        "1000000000010011",
        "1000000000101111",
        "1000000000010101",
        "1000000001010011",
        "1010100001010111",
        "1010101010111011",
        "0101010101001010",
        "0111010111110110",
        "0011101101011100",
        "0001111011111000",
        "0000011111100000"
    );
    
    type color_sprite is array (0 to 15, 0 to 15) of std_logic_vector(0 to 11);
    constant COLOR_ROM : color_sprite := (
        ("000000000000","000000000000","000000000000","000000000000","000000000000","000000000000","000000000000","000000000000","011000110011","010100110011","010100100010","000000000000","000000000000","000000000000","000000000000","000000000000"),
        ("000000000000","000000000000","000000000000","000101000001","000101010001","000101100001","000101010001","000000000000","011000110011","011000110011","010100110011","000000000000","000000000000","000000000000","000000000000","000000000000"),
        ("000000000000","000000000000","000000000000","000101000001","000101100001","000101100010","000101100001","001100110010","011000110011","010100110011","011000100010","011100100010","011100010010","011100100010","000000000000","000000000000"),
        ("000000000000","000000000000","100100100010","100000110010","001001100010","000101100001","000101110010","001101000010","011000110011","100100100010","101100100010","101100100010","101100100010","100100100010","100000100010","000000000000"),
        ("000000000000","100000100010","101000100010","111000110011","010101010010","000101100001","000101100001","001001000010","011000110011","110000110011","111000110011","111001000100","111101100101","110000110011","100100100010","100100100010"),
        ("000000000000","101000100010","111000110011","111101100101","110101110110","100001000011","010001000010","001001000001","010000110010","110101000011","111101100100","111000110011","111000110011","111001010100","101100100010","100000100010"),
        ("000000000000","101000100010","111001000100","111001110110","111101110110","111101100101","110101010100","101101000011","110001000011","111101100100","111101100100","111000110011","111000100010","111000100010","110000100010","100000100010"),
        ("000000000000","101000100010","111001010101","111101100101","111101100100","111101100100","111101100100","111101100100","111101100100","111101100100","111101010100","111000110011","111000100010","111000100010","110000100010","100000100010"),
        ("000000000000","101000100010","111001010101","111101100100","111101100100","111101100100","111101100100","111101100100","111101100100","111101100100","111000110011","111000100010","111000100010","111000100010","110000100010","100000100010"),
        ("000000000000","101000100010","111001010101","111101100101","111101100100","111101100100","111101100100","111101100100","111101010100","111001000011","111000110010","111000100010","111000100010","110100100010","101100100010","100100100010"),
        ("000000000000","101000100010","111000110011","111001110110","111101100101","111101100100","111101100100","111101010100","111000110011","111000100010","111000100010","111000100010","111000100010","110000100010","101100100010","100100100010"),
        ("000000000000","100100100010","110100100010","111001010100","111001110110","111101100101","111101000011","111000110011","111000100010","111000100010","111000100010","111000100010","110100100010","110000100010","101000100010","100100100010"),
        ("000000000000","100000100010","101000100010","111000100010","111001010100","111001010100","111000100010","111000100010","111000100010","111000100010","111000100010","110100100010","101100100010","101100100010","100100100010","000000000000"),
        ("000000000000","011100100010","100100100010","110100100010","111000100010","111000110011","111000100010","111000100010","111000100010","111000100010","110100100010","101100100010","110000100010","101000100010","100000100010","000000000000"),
        ("000000000000","000000000000","011100100010","100100100010","101100100010","110100100010","111000100010","110100100010","110000100010","110000100010","101100100010","101100100010","101000100010","100100100010","000000000000","000000000000"),
        ("000000000000","000000000000","000000000000","000000000000","100000100010","100100100010","101100100010","101000100010","101000100010","101000100010","100100100010","100100100010","100000100010","000000000000","000000000000","000000000000")
    );
    
    constant BRICK_ROM : color_sprite := (
        ("000000000000","000000000000","000000000000","000000000000","000000000000","000000000000","000000000000","000000000000","000000000000","000000000000","000000000000","000000000000","000000000000","000000000000","000000000000","000000000000"),
        ("000000000000","000100000000","001100000000","001100000000","001100000000","001100000000","001100000000","000000000000","001100000000","001100000000","001100000000","001100000000","001100000000","001100000000","001000000000","000000000000"),
        ("000000000000","001100000000","110000010000","101100010000","101100010000","101100010000","101000010000","001000000000","101000010000","101100010000","101100010000","101100010000","101100010000","101100010000","001100000000","000000000000"),
        ("000000000000","010000000000","110100010000","110100010000","110100010000","110100010000","101000010000","001000000000","101100010000","110100010000","110100010000","110100010000","110100010000","101100010000","001100000000","000000000000"),
        ("000000000000","010000000000","110100010000","110100010000","110100010000","110100010000","101000010000","001000000000","101100010000","110100010000","110100010000","110100010000","110100010000","101100010000","001100000000","000000000000"),
        ("000000000000","000100000000","001100000000","001100000000","001100000000","001100000000","001000000000","000000000000","001100000000","001100000000","001100000000","001100000000","001100000000","001100000000","000000000000","000000000000"),
        ("000000000000","001100000000","101100010000","100100010000","001000000000","011000000000","101100010000","101000010000","101000010000","101000010000","010100000000","001100000000","101100010000","100100010000","001000000000","000000000000"),
        ("000000000000","010000000000","111000010000","110000010000","001100000000","100000010000","111000010000","111000010000","111000010000","110100010000","011100000000","010000000000","111000010000","110000010000","001100000000","000000000000"),
        ("000000000000","001100000000","101100010000","100100010000","001000000000","011000000000","101100010000","101100010000","101100010000","101000010000","010100000000","001100000000","101100010000","100100010000","001000000000","000000000000"),
        ("000000000000","000100000000","001100000000","001100000000","001100000000","001100000000","001100000000","001000000000","000000000000","001100000000","001100000000","001100000000","001100000000","001000000000","000000000000","000000000000"),
        ("000000000000","010000000000","111000010000","110100010000","110100010000","110100010000","110100010000","100100010000","001000000000","110000010000","111000010000","110100010000","111000010000","110000010000","001100000000","000000000000"),
        ("000000000000","001000000000","011100010000","011100010000","100000010000","011100010000","011100010000","010100000000","000000000000","011100000000","100000010000","100000010000","011100010000","011000000000","001000000000","000000000000"),
        ("000000000000","000100000000","011000000000","010100000000","000100000000","001100000000","011000000000","011000000000","011000000000","010100000000","001000000000","000100000000","011000000000","010100000000","000100000000","000000000000"),
        ("000000000000","010000000000","111000010000","110000010000","001100000000","100100010000","111000010000","111000010000","111000010000","111000010000","011100000000","010000000000","111000010000","110000010000","001100000000","000000000000"),
        ("000000000000","001000000000","010000000000","010000000000","000100000000","001000000000","010000000000","010000000000","010000000000","010000000000","001000000000","000100000000","010000000000","010000000000","001000000000","000000000000"),
        ("000000000000","000000000000","000000000000","000000000000","000000000000","000000000000","000000000000","000000000000","000000000000","000000000000","000000000000","000000000000","000000000000","000000000000","000000000000","000000000000")
    );

--    vgaRed <= COLOR_ROM(row, col)(11 downto 8);

    constant img_size_x : natural := 16;
    constant img_size_y : natural := 16;

    signal is_img_painted : std_logic;
    signal img_clr : std_logic_vector(11 downto 0);

    signal img_x : unsigned(10 downto 0) := to_unsigned(50, 11);
    signal img_y : unsigned(10 downto 0) := to_unsigned(50, 11);
    
    signal rgb : std_logic_vector(11 downto 0);

    signal is_brick_painted : std_logic;
    signal brick_clr : std_logic_vector(11 downto 0);
begin
    led <= switch;
    start <= switch(7);
    
    is_img_painted <= '1' when (xCount >= img_x and xCount < img_x + img_size_x and yCount >= img_y and yCount < img_y + img_size_y) else '0';
--    img_clr <= ROM((yCount - img_y) mod img_size_y)((xCount - img_x) mod img_size_x) when is_img_painted = '1' else '0';
    img_clr <= COLOR_ROM((to_integer(yCount - img_y) mod img_size_y),(to_integer(xCount - img_x)) mod img_size_x) when is_img_painted = '1' else (others => '0');


    brick_clr <= BRICK_ROM((to_integer(yCount) mod 16),(to_integer(xCount) mod 16)) when border = '1' else (others => '0');

    vga_controller : entity work.vga_controller_640_60(Behavioral)
        Port map (rst => '0', pixel_clk => pixel_clk, HS => hsync, VS => vsync, hcount => xCount, vcount => yCount, blank => display);

    clk_div_unit_25Mhz : entity work.nbit_clk_div(Behavioral)
        Generic map (div_factor => 4,
                     high_count => 2,
                     num_of_bits => 3)
        Port map (clk_in => clk_100mhz, output => pixel_clk);

    -- instatiate random grid
    random_grid : entity work.randomGrid(Behavioral)
        Port map (pixel_clk => pixel_clk, rand_X => rand_X, rand_Y => rand_Y);

    update_clk : entity work.updateClk(Behavioral)
        Generic map (max_value => 4000000)
        Port map (clk_100mhz => clk_100mhz, update => update);

    up_sig : entity work.Debounce(Behavioral)
        Port map (clk => pixel_clk, rst => '0', noisy => btn_up, button_debounced => up);

    down_sig : entity work.Debounce(Behavioral)
        Port map (clk => pixel_clk, rst => '0', noisy => btn_down, button_debounced => down);

    left_sig : entity work.Debounce(Behavioral)
        Port map (clk => pixel_clk, rst => '0', noisy => btn_left, button_debounced => left);

    right_sig : entity work.Debounce(Behavioral)
        Port map (clk => pixel_clk, rst => '0', noisy => btn_right, button_debounced => right);

    process(clk_100mhz)
    begin
        if rising_edge(clk_100mhz) then
        if pixel_clk = '1' then
            if start = '0' then
                snakeX(0) <= to_unsigned(40, 7);
                snakeY(0) <= to_unsigned(30, 7);
                for count in 1 to 127 loop
                    snakeX(count) <= to_unsigned(127, 7);
                    snakeY(count) <= to_unsigned(127, 7);
                end loop;
                size <= to_unsigned(1, 7);
                game_over <= '0';
            elsif game_over = '0' then
                if update = '1' then
                    for count in 1 to 127 loop
                        if size > count then
                            snakeX(count) <= snakeX(count-1);
                            snakeY(count) <= snakeY(count-1);
                        end if;
                    end loop;
                    case direction is
                        when "0001" =>
                            snakeY(0) <= snakeY(0) - to_unsigned(1, 7);
                        when "0010" =>
                            snakeY(0) <= snakeY(0) + to_unsigned(1, 7);
                        when "0100" =>
                            snakeX(0) <= snakeX(0) - to_unsigned(1, 7);
                        when "1000" =>
                            snakeX(0) <= snakeX(0) + to_unsigned(1, 7);
                        when others =>
                            null;
                    end case;
                else 
                    if img_clr /= "000000000000" and (snakeBody /= (127 downto 0 => '0')) then                    
--                    if (snakeX(0) = pearX) and (snakeY(0) = pearY) then
                        img_x <= rand_X & "0000";
                        img_y <= rand_Y & "0000";
                        if size < (128 - SIZE_INCREMENT) then
                            size <= size + SIZE_INCREMENT;
                        end if;
                    
                    -- elsif border = '1' and snakeBody(0) = '1' then
                    elsif brick_clr /= "000000000000" and snakeBody(0) = '1' then
                         game_over <= '1';
                    
                    elsif (snakeBody(127 downto 1) /= (127 downto 1 => '0') and snakeBody(0) = '1') then
                        game_over <= '1';
                    end if;
                end if;
            end if;
        end if;
        end if;
    end process;

    process(clk_100mhz)
    begin
        if rising_edge(clk_100mhz) then
            if pixel_clk = '1' then
            if (up = '1' and direction /= "0010") then
                direction <= "0001";
            elsif (down = '1' and direction /= "0001") then
                direction <= "0010";
            elsif (left = '1' and  direction /= "1000") then
                direction <= "0100";
            elsif (right  = '1' and direction /= "0100") then
                direction <= "1000";
            end if;
            end if;
        end if;
    end process;

    process(clk_100mhz)
    begin
        if rising_edge(clk_100mhz) then
        if pixel_clk = '1' then
            if switch(0) = '1' then
                if ((xCount(9 downto 3) = 0) or (xCount(9 downto 3) = 79) or (yCount(9 downto 3) = 0) or (yCount(9 downto 3) = 59) or ((xCount(9 downto 3) = 10) and (yCount(9 downto 3) >= 10 and yCount(9 downto 3) <= 20)) or ((xCount(9 downto 3) = 69) and (yCount(9 downto 3) >= 39 and yCount(9 downto 3) <= 49)) or ((yCount(9 downto 3) = 10) and (xCount(9 downto 3) >= 10 and xCount(9 downto 3) <= 20)) or ((yCount(9 downto 3) = 49) and (xCount(9 downto 3) >= 59 and xCount(9 downto 3) <= 69))) then
                    border <= '1';
                else 
                    border <= '0';
                end if;
            elsif switch(1) = '1' then
                if ((xCount(9 downto 3) = 0) or (xCount(9 downto 3) = 79) or (yCount(9 downto 3) = 0) or (yCount(9 downto 3) = 59) or((yCount(9 downto 3) = 20) and (xCount(9 downto 3) >= 10 and xCount(9 downto 3) <= 69)) or ((yCount(9 downto 3) =40 ) and (xCount(9 downto 3) >= 10 and xCount(9 downto 3) <= 69))) then
                    border <= '1';
                else 
                    border <= '0';
                end if;
            elsif switch(2) = '1' then
                if ((xCount(9 downto 3) = 0) or (xCount(9 downto 3) = 79) or (yCount(9 downto 3) = 0) or (yCount(9 downto 3) = 59) or ((xCount(9 downto 3) = 39) and (yCount(9 downto 3) >= 0 and yCount(9 downto 3) <=10)) or ((xCount(9 downto 3) = 39) and (yCount(9 downto 3) >= 49 and  yCount(9 downto 3)<=59))) then
                    border <= '1';
                else 
                    border <= '0';
                end if;
            else
                -- if (xCount(9 downto 3) = 0) or (xCount(9 downto 3) = 79) or (yCount(9 downto 3) = 0) or (yCount(9 downto 3) = 59) then
                --     border <= '1';
                -- else 
                --     border <= '0';
                -- end if;
                if (xCount < img_size_x or xCount > 640 - img_size_x or yCount < img_size_y or yCount > 480 - img_size_y) then
                    border <= '1';
                else 
                    border <= '0';
                end if;  
            end if;
        end if;
        end if;
    end process;

    process(clk_100mhz)
    begin
        if rising_edge(clk_100mhz) then
        if pixel_clk = '1' then
            if (xCount(9 downto 3) = pearX) and (yCount(9 downto 3) = pearY) then
                pear <= '1';
                
                
                -- pear <= ROM(to_integer(yCount(9 downto 3))) (to_integer(xCount(9 downto 3)));
            else
                pear <= '0';
            end if;
        end if;
        end if;
    end process;

    process(clk_100mhz)
    begin
        if rising_edge(clk_100mhz) then
        if pixel_clk = '1' then
            for count in 0 to 127 loop
                if (xCount(9 downto 3) = snakeX(count)) and (yCount(9 downto 3) = snakeY(count)) then
                    snakeBody(count) <= '1';
                else
                    snakeBody(count) <= '0';
                end if;
            end loop;
        end if;
        end if;
    end process;
    
    vgared <= rgb(11 downto 8);
    vgagreen <= rgb(7 downto 4);
    vgablue <= rgb(3 downto 0);
    
    rgb <= (others => '0') when display = '1' else 
           "111100000000" when game_over = '1' else
           "000011110000" when (snakeBody /= (127 downto 0 => '0')) else
           brick_clr when border = '1' else 
           img_clr;

--    vgared <= "1111" when (display = '0' and (img_clr /= "000000000000" or game_over = '1')) else "0000";
--    vgagreen <= "1111" when display = '0' and (snakeBody /= (127 downto 0 => '0') and game_over = '0') ;
--    vgablue <= "1111" when (display = '0' and (border = '1' and game_over = '0')) else "0000";

end Behavioral;