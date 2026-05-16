----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/16/2026 06:13:52 PM
-- Design Name: 
-- Module Name: test_ssd - Behavioral
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

entity test_ssd is
Port ( 
    CLK : STD_LOGIC;
    CAT : out STD_LOGIC_VECTOR (6 downto 0);
    AN : out STD_LOGIC_VECTOR (3 downto 0)
);
end test_ssd;

architecture Behavioral of test_ssd is

signal digit0 : unsigned (3 downto 0);
signal digit1 : unsigned (3 downto 0);
signal digit2 : unsigned (3 downto 0);
signal digit3 : unsigned (3 downto 0);

begin
ssd : entity WORK.SSD port map (
    CLK => CLK,
    digit0 => digit0,
    digit1 => digit1,
    digit2 => digit2,
    digit3 => digit3,
    CAT => CAT,
    AN => AN
);

digit0 <= x"A";
digit1 <= x"2";
digit2 <= x"4";
digit3 <= x"0";

end Behavioral;
