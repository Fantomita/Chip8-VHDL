----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/08/2026 06:35:04 PM
-- Design Name: 
-- Module Name: tb_opcodes - Behavioral
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

entity tb_opcodes is
--  Port ( );
end tb_opcodes;

architecture Behavioral of tb_opcodes is

signal CLK               : STD_LOGIC := '0';
signal CE                : STD_LOGIC := '1';
signal RST               : STD_LOGIC := '0';
signal ram_read_address  : unsigned (11 downto 0);
signal ram_RE            : STD_LOGIC;
signal ram_write_address : unsigned (11 downto 0);
signal ram_write_data    : unsigned (7 downto 0);
signal ram_WE            : STD_LOGIC;
signal ram_read_data     : unsigned (7 downto 0);
signal ram_read_ack      : STD_LOGIC;

type rom_type is array (0 to 4095) of unsigned (7 downto 0);
signal rom : rom_type := (
    16#198# => x"60",
    16#199# => x"FF",
    16#200# => x"60", --LD_V0_12
    16#201# => x"12",
    16#202# => x"63", --LD_V3_14
    16#203# => x"14",
    16#204# => x"30", --SE_V0_12
    16#205# => x"13",
    16#206# => x"61", --LD_V6_98
    16#207# => x"98",
    --16#208# => x"11", --JMP_x198
    --16#209# => x"98",
    16#208# => x"70", --ADD_V0_77
    16#209# => x"77",
    16#210# => x"87", --LD_V7_V0
    16#211# => x"00",
    16#212# => x"87", --LD_V7_V0
    16#213# => x"31",
    others  => x"00"
);


begin
    CLK <= not CLK after 5 ns;

    cpu : entity work.cpu port map (
        CLK               => CLK,
        CE                => CE,
        RST               => RST,
        ram_read_address  => ram_read_address,
        ram_RE            => ram_RE,
        ram_write_address => ram_write_address,
        ram_write_data    => ram_write_data,
        ram_WE            => ram_WE,
        ram_read_data     => ram_read_data,
        ram_read_ack      => ram_read_ack
    );

    -- synchronous ROM
    process(CLK)
    begin
        if rising_edge(CLK) then
            ram_read_ack <= '0';
            if ram_RE = '1' then
                ram_read_data <= rom(to_integer(ram_read_address));
                ram_read_ack  <= '1';
            end if;
            if ram_WE = '1' then
                rom(to_integer(ram_write_address)) <= ram_write_data;
            end if;
        end if;
    end process;

end Behavioral;
