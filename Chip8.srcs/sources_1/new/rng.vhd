----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/10/2026 05:19:33 PM
-- Design Name: 
-- Module Name: rng - Behavioral
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

entity rng is
    Port ( CLK : in STD_LOGIC;
           data_out : out unsigned (7 downto 0));
end rng;

architecture Behavioral of rng is

signal number_i : unsigned (7 downto 0) := "10110010";

begin

process (CLK)
begin
    if rising_edge(CLK) then
        number_i <= number_i(6 downto 0) & (number_i(7) xor number_i(5) xor number_i(4) xor number_i(3));
    end if;
end process;

data_out <= number_i;

end Behavioral;
