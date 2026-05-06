----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2026 11:29:48 PM
-- Design Name: 
-- Module Name: ram - Behavioral
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

entity ram is
    Port ( read_address : in unsigned (11 downto 0);
           RE : in STD_LOGIC;
           write_address : in unsigned (11 downto 0);
           write_data : in unsigned (7 downto 0);
           WE : in STD_LOGIC;
           CLK : in STD_LOGIC;
           data_out : out unsigned(7 downto 0);
           read_ack : out STD_LOGIC
           );
end ram;

architecture Behavioral of ram is

type ram_type is array(0 to 4095) of unsigned(7 downto 0);

signal ram_data : ram_type := (others => (others => '0'));
begin

process(CLK)
begin
    if rising_edge(CLK) then
        read_ack <= '1';
        if RE = '1' then
            data_out <= ram_data(to_integer(read_address));
            read_ack <= '1';
        end if;
        if WE = '1' then
            ram_data(to_integer(write_address)) <= write_data;
        end if;
    end if;

end process;

end Behavioral;
