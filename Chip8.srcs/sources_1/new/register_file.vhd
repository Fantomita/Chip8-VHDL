----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/21/2026 12:50:52 PM
-- Design Name: 
-- Module Name: register_file - Behavioral
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
use IEEE.std_logic_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity register_file is
    Port ( read_add1, read_add2 : in unsigned (3 downto 0);
           write_add : in unsigned (3 downto 0);
           write_data : in unsigned (7 downto 0);
           CLK, RST, WE : in STD_LOGIC;
           read_data1, read_data2 : out unsigned (7 downto 0));
end register_file;

architecture Behavioral of register_file is

type registers is array (0 to 15) of unsigned (7 downto 0);
signal V : registers := (others => x"00");

begin

process(CLK)
begin
    if rising_edge(CLK) then
        if RST = '1' then
            V <= (others => x"00");
        elsif WE = '1' then
            V(to_integer(unsigned(write_add))) <= write_data; 
        end if;
    end if;
end process;

read_data1 <= V(to_integer(unsigned(read_add1)));
read_data2 <= V(to_integer(unsigned(read_add2)));

end Behavioral;
