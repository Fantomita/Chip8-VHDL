----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/21/2026 07:26:04 PM
-- Design Name: 
-- Module Name: top - Behavioral
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


library WORK;
use WORK.common.ALL;

entity top is
    Port ( CLK, RST : in STD_LOGIC;
           row : in STD_LOGIC_VECTOR (0 to 3);
           col : out STD_LOGIC_VECTOR (0 to 3);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           V_SYNC, H_SYNC: out STD_LOGIC;
           RGB : out STD_LOGIC_VECTOR (11 downto 0);
           CAT : out STD_LOGIC_VECTOR (6 downto 0);
           AN : out STD_LOGIC_VECTOR (3 downto 0));
end top;

architecture Behavioral of top is

-- CLOCK DIVIDER SIGNALS
signal tick_cpu_i : STD_LOGIC;
signal tick_vga_i : STD_LOGIC;
signal tick_timer_i : STD_LOGIC;

-- RAM SIGNALS
signal ram_read_address_i : unsigned (11 downto 0);
signal ram_RE_i : STD_LOGIC;
signal ram_write_address_i : unsigned (11 downto 0);
signal ram_write_data_i : unsigned (7 downto 0);
signal ram_WE_i : STD_LOGIC;
signal ram_data_out_i : unsigned (7 downto 0);
signal ram_read_ack_i : STD_LOGIC;
signal gpu_ram_RE_i : STD_LOGIC;
signal gpu_ram_read_address_i : unsigned (11 downto 0);
signal gpu_ram_read_data_i : unsigned (7 downto 0);
signal gpu_ram_read_ack_i : STD_LOGIC;

-- CPU SIGNALS
signal debug_register_file_read_add_i : unsigned (3 downto 0);
signal debug_register_file_read_data_i : unsigned (7 downto 0);

-- SSD SIGNALS 
signal ssd_digit0_i : unsigned (3 downto 0);
signal ssd_digit1_i : unsigned (3 downto 0);
signal ssd_digit2_i : unsigned (3 downto 0);
signal ssd_digit3_i : unsigned (3 downto 0);

-- VGA SIGNALS
signal draw_buffer_i : STD_LOGIC;
signal V_SYNC_i : STD_LOGIC;
signal H_SYNC_i : STD_LOGIC;

-- VRAM SIGNALS
signal vram_addr_vga_i : unsigned (8 downto 0);
signal vram_addr_gpu_i : unsigned (8 downto 0);
signal vram_data_vga_i : unsigned (7 downto 0);
signal vram_data_gpu_i : unsigned (7 downto 0);
signal vram_write_address_i : unsigned (8 downto 0);
signal vram_write_data_i : unsigned (7 downto 0);
signal vram_WE_i : STD_LOGIC;

-- GPU SIGNALS
signal gpu_command_ack_i : STD_LOGIC;
signal gpu_command_i : GpuCommands;
signal gpu_ready_i :  STD_LOGIC;
signal gpu_draw_x_i: unsigned(5 downto 0);
signal gpu_draw_y_i: unsigned(4 downto 0);
signal gpu_draw_n_i: unsigned(3 downto 0);
signal gpu_draw_offset_i: unsigned(11 downto 0);
signal gpu_collision_i : STD_LOGIC;

-- KEYPAD SIGNALS
signal keypad_key_i : unsigned (3 downto 0);
signal keypad_valid_i : STD_LOGIC;

begin
    clock_divider : entity WORK.clock_divider port map (
        clk => CLK,
        tick_cpu => tick_cpu_i,
        tick_vga => tick_vga_i,
        tick_timer => tick_timer_i
    );
    
    ram : entity WORK.ram port map (
        rom_selection     => unsigned(sw(7 downto 5)),
        cpu_read_address  => ram_read_address_i,
        cpu_RE            => ram_RE_i,
        cpu_write_address => ram_write_address_i,
        cpu_write_data    => ram_write_data_i,
        cpu_WE            => ram_WE_i,
        CLK               => CLK,
        cpu_data_out      => ram_data_out_i,
        cpu_read_ack      => ram_read_ack_i,
        gpu_RE            => gpu_ram_RE_i,
        gpu_read_address  => gpu_ram_read_address_i,
        gpu_data_out      => gpu_ram_read_data_i,
        gpu_read_ack      => gpu_ram_read_ack_i   
    );
    
    cpu : entity WORK.cpu port map (
        CLK => CLK,
        RST => RST,
        tick_cpu => tick_cpu_i,
        tick_timer => tick_timer_i,
        ram_read_address => ram_read_address_i,
        ram_RE => ram_RE_i,
        ram_write_address => ram_write_address_i,
        ram_write_data => ram_write_data_i,
        ram_WE => ram_WE_i,
        ram_read_data => ram_data_out_i,
        ram_read_ack => ram_read_ack_i,
        debug_register_file_read_add => unsigned(sw(4 downto 1)),
        debug_register_file_read_data => debug_register_file_read_data_i,
        gpu_command_ack =>gpu_command_ack_i,
        gpu_command => gpu_command_i,
        gpu_ready => gpu_ready_i,
        gpu_draw_x => gpu_draw_x_i,
        gpu_draw_y => gpu_draw_y_i,
        gpu_draw_n => gpu_draw_n_i,
        gpu_draw_offset => gpu_draw_offset_i,
        gpu_collision => gpu_collision_i,
        keypad_key => keypad_key_i,
        keypad_valid => keypad_valid_i
    );
    
    gpu : entity WORK.gpu port map (
        CLK                => CLK,
        RST                => RST,
        gpu_command_ack    => gpu_command_ack_i,
        gpu_command        => gpu_command_i,
        gpu_ready          => gpu_ready_i,
        gpu_draw_x         => gpu_draw_x_i,
        gpu_draw_y         => gpu_draw_y_i,
        gpu_draw_n         => gpu_draw_n_i,
        gpu_draw_offset    => gpu_draw_offset_i,
        gpu_collision      => gpu_collision_i,
        ram_RE             => gpu_ram_RE_i,
        ram_read_address   => gpu_ram_read_address_i,
        ram_read_data      => gpu_ram_read_data_i,
        ram_read_ack       => gpu_ram_read_ack_i,
        vram_read_address  => vram_addr_gpu_i,
        vram_read_data     => vram_data_gpu_i,
        vram_write_address => vram_write_address_i,
        vram_write_data    => vram_write_data_i,
        vram_WE            => vram_WE_i,
        draw_buffer        => draw_buffer_i,
        vga_V_SYNC         => V_SYNC_i
    );
    
    ssd : entity WORK.ssd port map (
        digit0 => ssd_digit0_i,
        digit1 => ssd_digit1_i,
        digit2 => ssd_digit2_i,
        digit3 => ssd_digit3_i,
        CLK => CLK,
        CAT => CAT,
        AN => AN
    );
    
    ssd_digit0_i <= debug_register_file_read_data_i (3 downto 0);
    ssd_digit1_i <= debug_register_file_read_data_i (7 downto 4);
    ssd_digit2_i <= x"0";
    ssd_digit3_i <= x"0";
    
--    switch_decoder : entity WORK.switch_decoder port map (
--        sw => sw,
--        address => debug_register_file_read_add_i
--    );
    
    vga: entity WORK.vga port map (
           CLK => CLK,
           tick_vga => tick_vga_i,
           H_SYNC => H_SYNC_i,
           V_SYNC => V_SYNC_i,
           RGB => RGB,
           draw_buffer => draw_buffer_i,
           vram_addr => vram_addr_vga_i,
           vram_data => vram_data_vga_i
    );
     vram: entity WORK.vram port map (
        read_address_vga => vram_addr_vga_i,
        read_address_gpu => vram_addr_gpu_i,
        write_address    => vram_write_address_i,
        write_data       => vram_write_data_i, 
        WE               => vram_WE_i,           
        CLK              => CLK,
        data_out_vga     => vram_data_vga_i,
        data_out_gpu     => vram_data_gpu_i
    );
    
    keypad : entity WORK.key_encoder port map (
        CLK => CLK,
        row => row,
        col => col,
        hex_data => keypad_key_i,
        valid => keypad_valid_i
    );
    
    H_SYNC <= H_SYNC_i;
    V_SYNC <= V_SYNC_i;
    

end Behavioral;
