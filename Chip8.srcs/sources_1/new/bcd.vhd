----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/10/2026 11:49:40 PM
-- Design Name: 
-- Module Name: bcd - Behavioral
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

entity bcd is
    Port ( bcd_input : in unsigned (7 downto 0);
           digit2 : out unsigned (3 downto 0);
           digit1 : out unsigned (3 downto 0);
           digit0 : out unsigned (3 downto 0));
end bcd;

architecture Behavioral of bcd is

begin
process(bcd_input)
    variable temp : unsigned (19 downto 0) := (others => '0');
begin 
    temp := (others => '0');
    temp (7 downto 0) := bcd_input;
    for i in 0 to 7 loop
        if temp (19 downto 16) >= 5 then
            temp (19 downto 16) := temp (19 downto 16) + 3;
        end if;
        if temp (15 downto 12) >= 5 then
            temp (15 downto 12) := temp (15 downto 12) + 3;
        end if;
        if temp (11 downto 8) >= 5 then
            temp (11 downto 8) := temp (11 downto 8) + 3;
        end if;
        
        temp := temp (18 downto 0) & '0';
    end loop;
    
    digit2 <= temp (19 downto 16);
    digit1 <= temp (15 downto 12);
    digit0 <= temp (11 downto 8);
end process;

end Behavioral;
