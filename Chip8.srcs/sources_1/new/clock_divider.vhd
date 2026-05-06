----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/21/2026 10:29:59 PM
-- Design Name: 
-- Module Name: clock_divider - Behavioral
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

entity clock_divider is
    Port ( clk : in STD_LOGIC;
           tick_cpu, tick_vga, tick_timer : out STD_LOGIC);
end clock_divider;

architecture Behavioral of clock_divider is

constant CLK_FREQ : integer := 100_000_000;
constant CPU_FREQ : integer := 500;
constant VGA_FREQ : integer := 25_000_000;
constant TIMER_FREQ : integer := 60;

constant CPU_TOP : integer := (CLK_FREQ / CPU_FREQ) - 1;
constant VGA_TOP : integer := (CLK_FREQ / VGA_FREQ) - 1;
constant TIMER_TOP : integer := (CLK_FREQ / TIMER_FREQ) - 1;

signal cpu_counter : unsigned (17 downto 0) := to_unsigned(CPU_TOP, 18);
signal vga_counter : unsigned (1 downto 0) := to_unsigned(VGA_TOP, 2);
signal timer_counter : unsigned (20 downto 0) := to_unsigned(TIMER_TOP, 21);

begin

process(clk)
begin
    if rising_edge(clk) then
        --CPU CLK ENABLE--
        if cpu_counter = 0 then
            cpu_counter <= to_unsigned(CPU_TOP, 18);
            tick_cpu <= '1';
        else
            cpu_counter <= cpu_counter - 1;
            tick_cpu <= '0';
        end if;
        --VGA CLK ENABLE--
        if vga_counter = 0 then
            vga_counter <= to_unsigned(VGA_TOP, 2);
            tick_vga <= '1';
        else
            vga_counter <= vga_counter -1;
            tick_vga <= '0';
        end if;
        --TIMER CLK ENABLE--
        if timer_counter = 0 then
            timer_counter <= to_unsigned(TIMER_TOP, 21);
            tick_timer <= '1';
        else
            timer_counter <= timer_counter - 1;
            tick_timer <= '0';
        end if;
    end if;
end process;

end Behavioral;
