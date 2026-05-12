----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/11/2026 03:14:34 PM
-- Design Name: 
-- Module Name: timer - Behavioral
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

entity timer is
    Port ( CLK : in STD_LOGIC;
           CE : in STD_LOGIC;
           RST : in STD_LOGIC;
           load_enable : in STD_LOGIC;
           load_data : in unsigned (7 downto 0);
           data_out : out unsigned (7 downto 0);
           nonzero : out STD_LOGIC);
end timer;

architecture Behavioral of timer is

signal count_i : unsigned (7 downto 0) := (others => '0');

begin

nonzero <= '0' when (count_i = 0) else '1'; 

process (CLK)
begin
    if rising_edge (CLK) then
        if RST = '1' then
            count_i <= (others => '0');
        elsif load_enable = '1' then
            count_i <= load_data;        
        elsif CE = '1' and count_i > 0 then
            count_i <= count_i - 1;
        end if;
    end if;
end process;

data_out <= count_i;

end Behavioral;
