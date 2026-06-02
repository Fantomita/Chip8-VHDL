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

entity top is
    Port ( CLK, RST : in STD_LOGIC;
           --KEYPAD : in STD_LOGIC_VECTOR (15 downto 0);
           sw : STD_LOGIC_VECTOR (15 downto 0);
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

-- VRAM SIGNALS
signal vram_addr_i : unsigned (8 downto 0);
signal vram_data_i : unsigned (7 downto 0);
begin
    clock_divider : entity WORK.clock_divider port map (
        clk => CLK,
        tick_cpu => tick_cpu_i,
        tick_vga => tick_vga_i,
        tick_timer => tick_timer_i
    );
    
    ram : entity WORK.ram port map (
        read_address => ram_read_address_i,
        RE => ram_RE_i,
        write_address => ram_write_address_i,
        write_data => ram_write_data_i,
        WE => ram_WE_i,
        CLK => CLK,
        data_out => ram_data_out_i,
        read_ack => ram_read_ack_i     
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
        debug_register_file_read_add => debug_register_file_read_add_i,
        debug_register_file_read_data => debug_register_file_read_data_i
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
    
    switch_decoder : entity WORK.switch_decoder port map (
        sw => sw,
        address => debug_register_file_read_add_i
    );
    
    vga: entity WORK.vga port map (
           CLK => CLK,
           tick_vga => tick_vga_i,
           H_SYNC => H_SYNC,
           V_SYNC => V_SYNC,
           RGB => RGB,
           draw_buffer => draw_buffer_i,
           vram_addr => vram_addr_i,
           vram_data => vram_data_i
    );
    
    vram: entity WORK.vram port map (
           read_address => vram_addr_i,
           write_address => "111111111",
           write_data => "11111111",
           WE => '0',
           CLK => CLK,
           data_out => vram_data_i
    );
    

end Behavioral;
