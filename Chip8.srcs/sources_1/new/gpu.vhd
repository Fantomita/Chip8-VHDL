----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/02/2026 05:27:45 PM
-- Design Name: 
-- Module Name: gpu - Behavioral
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

library WORK;
use WORK.common.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity gpu is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           gpu_command_ack : in STD_LOGIC;
           gpu_command : in GpuCommands;
           gpu_ready : out STD_LOGIC;
           gpu_draw_x: in unsigned(5 downto 0);
           gpu_draw_y: in unsigned(4 downto 0);
           gpu_draw_n: in unsigned(3 downto 0);
           gpu_draw_offset: in unsigned(11 downto 0);
           gpu_collision : out STD_LOGIC;
           ram_RE : out STD_LOGIC;
           ram_read_address : out unsigned (11 downto 0);
           ram_read_data : in unsigned (7 downto 0);
           ram_read_ack : in STD_LOGIC;
           vram_read_address : out unsigned (8 downto 0);
           vram_read_data : in unsigned (7 downto 0);
           vram_write_address : out  unsigned (8 downto 0);
           vram_write_data : out unsigned (7 downto 0);
           vram_WE : out STD_LOGIC;
           draw_buffer : in STD_LOGIC;
           vga_V_SYNC : in STD_LOGIC
           );
end gpu;

architecture Behavioral of gpu is

type gpu_states is (
    WAIT_CMD,
    DECODE_CMD,
    READ_MEMORY,
    WAIT_MEMORY,
    WRITE_MEMORY,
    COPY_BUFFER,
    WAIT_READ_BUFFER,
    CLEAR
);

signal state_i : gpu_states := WAIT_CMD;
signal clear_counter_i : unsigned (8 downto 0) := (others => '0');
signal copy_counter_i : unsigned (7 downto 0) := (others => '0');
signal row_counter_i : unsigned (3 downto 0) := (others => '0');
signal col_counter_i : unsigned (2 downto 0) := (others => '0');
signal sprite_byte_i : unsigned (7 downto 0) := (others => '0');
signal byte_in_vram_i : unsigned(7 downto 0) := (others => '0');
signal bit_in_byte_i : unsigned(2 downto 0) := (others => '0');
signal x_i : unsigned(5 downto 0) := (others => '0');
signal y_i : unsigned(4 downto 0) := (others => '0');
signal sprite_current_bit_i : STD_LOGIC := '0';
signal vram_write_data_i : unsigned (7 downto 0) := (others => '0');

signal prev_rst : STD_LOGIC := '0';
signal prev_v_sync : STD_LOGIC := '0';

begin
process (CLK)
begin
    if rising_edge(clk) then
        prev_rst <= rst;
        prev_v_sync <= vga_v_sync;
        if RST = '1' and prev_rst = '0' then
            state_i <= CLEAR;
            clear_counter_i <= (others => '1');
        else
            case state_i is
                when WAIT_CMD =>
                    if vga_v_sync = '0' and prev_v_sync = '1' then
                        copy_counter_i <= (others => '1');
                        state_i <= WAIT_READ_BUFFER;
                    elsif gpu_command_ack = '1' then
                        state_i <= DECODE_CMD;
                    else
                        state_i <= WAIT_CMD;
                    end if;
                 when DECODE_CMD =>
                    if gpu_command = CLEAR_SCREEN then
                        state_i <= CLEAR;
                        clear_counter_i <= (others => '1');
                    elsif gpu_command = DRAW_SCREEN then
                        state_i <= READ_MEMORY;
                        gpu_collision <= '0';
                        row_counter_i <= (others => '0');
                        col_counter_i <= (others => '0');
                    end if;
                 when CLEAR =>
                    if clear_counter_i = 0 then
                        state_i <= WAIT_CMD;
                    else
                        clear_counter_i <= clear_counter_i - 1;
                    end if; 
                 when WAIT_READ_BUFFER => 
                    state_i <= COPY_BUFFER;
                 when COPY_BUFFER => 
                    if copy_counter_i = 0 then
                        state_i <= WAIT_CMD;
                    else
                        copy_counter_i <= copy_counter_i - 1;
                        state_i <= WAIT_READ_BUFFER;
                    end if;
                 when READ_MEMORY =>
                    if ram_read_ack = '1' then
                        state_i <= WAIT_MEMORY;
                        sprite_byte_i <= ram_read_data;
                    end if;
                 when WAIT_MEMORY =>
                    state_i <= WRITE_MEMORY;
                 when WRITE_MEMORY =>
                    if vram_read_data(to_integer(bit_in_byte_i)) = '1' and sprite_current_bit_i = '1' then
                        gpu_collision <= '1';
                    end if;
                    
                    if col_counter_i = 7 then
                        col_counter_i <= (others => '0');
                        if row_counter_i = gpu_draw_n - 1 then
                            state_i <= WAIT_CMD;
                        else
                            row_counter_i <= row_counter_i + 1;
                            state_i <= READ_MEMORY;
                        end if;
                    else
                        col_counter_i <= col_counter_i + 1;
                        state_i <= WAIT_MEMORY;
                    end if;
            end case;
        end if;
    end if;
end process;


ram_RE <= '1' when (state_i = READ_MEMORY and col_counter_i = 0) else '0';
ram_read_address <= gpu_draw_offset + ("00000000" & row_counter_i);

-- X = (Vx + col_counter) % 64
x_i <= resize((gpu_draw_x + ("000" & col_counter_i)), 6);
-- Y = (Vy + row_counter) % 32
y_i <= resize((gpu_draw_y + ("0" & row_counter_i)), 5);
-- Byte in vram: Y * 8 + X / 8
byte_in_vram_i <= y_i & x_i(5 downto 3);
-- Bit in byte: x % 8
bit_in_byte_i <= not x_i(2 downto 0);

vram_read_address <= draw_buffer & byte_in_vram_i when (state_i = WAIT_MEMORY or state_i = WRITE_MEMORY) else (not draw_buffer) & copy_counter_i;

gpu_ready <= '1' when (state_i = WAIT_CMD) else '0';
vram_WE <= '1' when (state_i = CLEAR or state_i = WRITE_MEMORY or state_i = COPY_BUFFER) else '0';
vram_write_address <= clear_counter_i when (state_i = CLEAR) else
                      (draw_buffer & byte_in_vram_i) when (state_i = WRITE_MEMORY) else
                      (draw_buffer & copy_counter_i) when (state_i = COPY_BUFFER) else  
                      (others => '0');
vram_write_data <= x"00" when (state_i = CLEAR) else 
                   vram_read_data when (state_i = COPY_BUFFER) else 
                   vram_write_data_i;

sprite_current_bit_i <= sprite_byte_i(7 - to_integer(col_counter_i));
process(vram_read_data, bit_in_byte_i, sprite_current_bit_i)
    variable temp_byte : unsigned (7 downto 0);
begin
    temp_byte := vram_read_data;
    temp_byte(to_integer(bit_in_byte_i)) := temp_byte(to_integer(bit_in_byte_i)) xor sprite_current_bit_i;
    vram_write_data_i <= temp_byte;
end process;


end Behavioral;
