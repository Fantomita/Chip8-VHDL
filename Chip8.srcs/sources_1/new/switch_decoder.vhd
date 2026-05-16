----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/16/2026 04:21:58 PM
-- Design Name: 
-- Module Name: switch_decoder - Behavioral
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

entity switch_decoder is
    Port ( sw : in STD_LOGIC_VECTOR (15 downto 0);
           address : out unsigned (3 downto 0));
end switch_decoder;

architecture Behavioral of switch_decoder is

begin
process (sw)
begin
    if sw(1) = '1' then
        address <= x"1";
    elsif sw(2) = '1' then
        address <= x"2";
    elsif sw(3) = '1' then
        address <= x"3";
    elsif sw(4) = '1' then
        address <= x"4";
    elsif sw(5) = '1' then
        address <= x"5";
    elsif sw(6) = '1' then
        address <= x"6";
    elsif sw(7) = '1' then
        address <= x"7";
    elsif sw(8) = '1' then
        address <= x"8";
    elsif sw(9) = '1' then
        address <= x"9";
    elsif sw(10) = '1' then
        address <= x"A";
    elsif sw(11) = '1' then
        address <= x"B";
    elsif sw(12) = '1' then
        address <= x"C";
    elsif sw(13) = '1' then
        address <= x"D";
    elsif sw(14) = '1' then
        address <= x"E";
    elsif sw(15) = '1' then
        address <= x"F";
    else 
        address <= x"0";
    end if;
end process;

end Behavioral;
