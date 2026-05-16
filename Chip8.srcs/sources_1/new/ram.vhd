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

signal ram_data : ram_type := (
    16#198# => x"60",
    16#199# => x"FF",
    16#200# => x"C0", --RND_V0_FF
    16#201# => x"FF",
    16#202# => x"63", --LD_V3_14
    16#203# => x"14",
    --16#204# => x"30", --SE_V0_12
    --16#205# => x"13",
    --16#206# => x"70", --ADD_V0_98
    --16#207# => x"98",
    --16#208# => x"11", --JMP_x198
    --16#209# => x"98",
    16#208# => x"70", --ADD_V0_77
    16#209# => x"77",
    16#210# => x"87", --LD_V7_V0
    16#211# => x"00",
    16#212# => x"87", --LD_V7_V0
    16#213# => x"31",
    16#214# => x"87", --ADD_V7_V1
    16#215# => x"14",
    16#216# => x"87", --SUB_V7_V1
    16#217# => x"15",
    16#218# => x"80", --SHR_V0
    16#219# => x"06",
    16#220# => x"87", --SUBN_V7_V0
    16#221# => x"07",
    
    others  => x"00");
begin

process(CLK)
begin
    if rising_edge(CLK) then
        read_ack <= '0';
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
