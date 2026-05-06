----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/04/2026 02:46:27 PM
-- Design Name: 
-- Module Name: program_counter - Behavioral
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

entity program_counter is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           inc_pc : in STD_LOGIC;
           load_pc : in STD_LOGIC;
           load_data : in unsigned (11 downto 0);
           pc_out : out unsigned (11 downto 0));
end program_counter;

architecture Behavioral of program_counter is

signal pc_i : unsigned (11 downto 0) := x"200";

begin

process(clk)
begin
    if rising_edge(clk) then
        if (RST = '1') then
            pc_i <= x"200";
        elsif (load_pc = '1') then
            pc_i <= load_data;
        elsif (inc_pc = '1') then
            pc_i <= pc_i + 2;
        end if;
    end if;
end process;

pc_out <= pc_i;

end Behavioral;
