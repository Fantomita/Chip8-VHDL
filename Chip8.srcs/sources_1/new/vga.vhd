----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/31/2026 08:48:18 PM
-- Design Name: 
-- Module Name: vga - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
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

entity vga is
    Port ( CLK : in STD_LOGIC;
           tick_vga : in STD_LOGIC;
           H_SYNC : out STD_LOGIC;
           V_SYNC : out STD_LOGIC;
           RGB : out STD_LOGIC_VECTOR (11 downto 0);
           draw_buffer : out STD_LOGIC;
           vram_addr : out unsigned (8 downto 0);
           vram_data : in unsigned (7 downto 0));
end vga;

architecture Behavioral of vga is
-- VGA Signals
signal render_buffer : STD_LOGIC := '0';
signal v_counter_i : unsigned (15 downto 0) := (others => '0');
signal h_counter_i : unsigned (15 downto 0) := (others => '0');
signal v_counter_en_i : STD_LOGIC := '0';
signal active_video_i : STD_LOGIC := '0';

-- SCALING FACTOR
constant SCALE_FACTOR : integer := 8;

-- HORIZONTAL Constants
constant H_FRONT_PORCH : integer := 16;
constant H_SYNC_PULSE : integer := 96; 
constant H_BACK_PORCH : integer := 48;
constant H_ACTIVE_VIDEO : integer := 640;
constant H_TOTAL_PIXELS : integer := 800;
constant H_CHIP8_ACTIVE : integer := 64 * SCALE_FACTOR;
constant H_PADDING : integer := (H_ACTIVE_VIDEO - H_CHIP8_ACTIVE) / 2;
constant H_INACTIVE_AREA_L : integer := H_SYNC_PULSE + H_BACK_PORCH + H_PADDING;
constant H_INACTIVE_AREA_R : integer := H_FRONT_PORCH + H_PADDING;

-- VERTICAL Constants
constant V_FRONT_PORCH : integer := 10;
constant V_SYNC_PULSE : integer := 2; 
constant V_BACK_PORCH : integer := 33;
constant V_ACTIVE_VIDEO : integer := 480;
constant V_TOTAL_PIXELS : integer := 524;
constant V_CHIP8_ACTIVE : integer := 32 * SCALE_FACTOR;
constant V_PADDING : integer := (V_ACTIVE_VIDEO - V_CHIP8_ACTIVE) / 2;
constant V_INACTIVE_AREA_U : integer := V_SYNC_PULSE + V_BACK_PORCH + V_PADDING;
constant V_INACTIVE_AREA_D : integer := V_FRONT_PORCH + V_PADDING;

constant H_VGA_START : integer := H_SYNC_PULSE + H_BACK_PORCH;
constant H_VGA_END   : integer := H_VGA_START + H_ACTIVE_VIDEO;
constant V_VGA_START : integer := V_SYNC_PULSE + V_BACK_PORCH;
constant V_VGA_END   : integer := V_VGA_START + V_ACTIVE_VIDEO;


signal x_i : unsigned (15 downto 0);
signal y_i : unsigned (15 downto 0);

signal pixel_x_i : unsigned (15 downto 0);
signal pixel_y_i : unsigned (15 downto 0);


-- active area
-- h: 64*8 = 512
-- v: 32 * 8 = 256

-- padding area
-- h: 640 - 512 = 128 / 2 = 64
-- v : 480 - 256 = 224 / 2 = 112

begin

x_i <= h_counter_i - H_INACTIVE_AREA_L when (h_counter_i >= H_INACTIVE_AREA_L) else (others => '0');
y_i <= v_counter_i - V_INACTIVE_AREA_U when (v_counter_i >= V_INACTIVE_AREA_U) else (others => '0');

pixel_x_i <= x_i / SCALE_FACTOR; -- bit
pixel_y_i <= y_i / SCALE_FACTOR; -- line

vram_addr <= render_buffer & resize(shift_right(pixel_x_i, 3) + shift_left(pixel_y_i, 3), 8);

active_video_i <= '1' when (h_counter_i >= H_INACTIVE_AREA_L and h_counter_i < (H_TOTAL_PIXELS - H_INACTIVE_AREA_R)) and
                           (v_counter_i >= V_INACTIVE_AREA_U and v_counter_i < (V_TOTAL_PIXELS - V_INACTIVE_AREA_D)) else '0';

-- byte_adress = pixel_x / 8 + pixel_y * 8

horizontal_counter : process(CLK)
begin
    if rising_edge(clk) then
        if tick_vga = '1' then
            if h_counter_i < H_TOTAL_PIXELS - 1 then
                h_counter_i <= h_counter_i + 1;
                v_counter_en_i <= '0';
            else
                h_counter_i <= (others => '0');
                v_counter_en_i <= '1';
            end if;
        end if;
    end if;
    
end process;

vertical_counter : process(CLK)
begin
    if rising_edge(clk) then
        if tick_vga = '1' then
            if v_counter_en_i = '1' then
                if v_counter_i < V_TOTAL_PIXELS - 1 then
                    v_counter_i <= v_counter_i + 1;
                else
                    v_counter_i <= (others => '0');
                    render_buffer <= not render_buffer;
                end if;
            end if;
        end if;
end if; 
end process;

--active_area : process(CLK)
--begin
--    if rising_edge(clK) then
--        if tick_vga = '1' then
--            if (h_counter_i > H_INACTIVE_AREA_L and h_counter_i < (H_TOTAL_PIXELS - H_INACTIVE_AREA_R)) and
--               (v_counter_i > V_INACTIVE_AREA_U and v_counter_i < (V_TOTAL_PIXELS - V_INACTIVE_AREA_D)) then
--                active_video_i <= '1';
--            else
--                active_video_i <= '0';
--            end if;
--        if end if;
--    end if;
--end process;

sync_delay : process(CLK)
begin
    if rising_edge(clk) then
        if tick_vga = '1' then
            if h_counter_i < H_SYNC_PULSE then
                H_SYNC <= '0';
            else
                H_SYNC <= '1';
            end if;
            
            if v_counter_i < V_SYNC_PULSE then
                V_SYNC <= '0';

            else
                V_SYNC <= '1';
            end if;
        end if;
    end if;
end process;


draw : process(CLK)
begin
    if rising_edge(clk) then
        if tick_vga = '1' then
            if (h_counter_i >= H_VGA_START and h_counter_i < H_VGA_END) and
               (v_counter_i >= V_VGA_START and v_counter_i < V_VGA_END) then
                if active_video_i = '1' then
                    if vram_data(7 - (to_integer(pixel_x_i) mod 8)) = '1' then
                        RGB <= x"FFF";
                    else
                        RGB <= x"000";
                    end if;
                else 
                    RGB <= x"0F0";
                end if;
            else
                RGB <= x"000";
            end if;
            
        end if; 
    end if;
end process;

--process(CLK)
--begin
--    if rising_edge(clk) then
--        vram_addr <= render_buffer & resize(shift_right(pixel_x_i, 3) + shift_left(pixel_y_i, 3), 8);
--    end if;
--end process;

draw_buffer <= not render_buffer;
--H_SYNC <= '0' when (h_counter_i < H_SYNC_PULSE) else '1';
--V_SYNC <= '0' when (v_counter_i < V_SYNC_PULSE) else '1';

end Behavioral;