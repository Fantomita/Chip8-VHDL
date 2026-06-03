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

entity vram is
    Port ( read_address_vga : in unsigned (8 downto 0);
           read_address_gpu : in unsigned (8 downto 0);
           write_address : in unsigned (8 downto 0);
           write_data : in unsigned (7 downto 0);
           WE : in STD_LOGIC;
           CLK : in STD_LOGIC;
           data_out_vga : out unsigned(7 downto 0);
           data_out_gpu : out unsigned(7 downto 0)
           );
end vram;

architecture Behavioral of vram is

type vram_type is array(0 to 511) of unsigned(7 downto 0);

signal vram_data : vram_type := (
    others => x"00"
);
begin

process(CLK)
begin
    if rising_edge(CLK) then
        if WE = '1' then
            vram_data(to_integer(write_address)) <= write_data;
        end if;
    end if;
end process;

data_out_vga <= vram_data(to_integer(read_address_vga));
data_out_gpu <= vram_data(to_integer(read_address_gpu));

end Behavioral;
