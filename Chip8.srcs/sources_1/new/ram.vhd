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
    -- sprite 0
    0  => x"F0",
    1  => x"90",
    2  => x"90",
    3  => x"90",
    4  => x"F0",
    -- sprite 1
    5  => x"20",
    6  => x"60",
    7  => x"20",
    8  => x"20",
    9  => x"70",
    -- sprite 2
    10 => x"F0",
    11 => x"10",
    12 => x"F0",
    13 => x"80",
    14 => x"F0",
    -- sprite 3
    15 => x"F0",
    16 => x"10",
    17 => x"F0",
    18 => x"10",
    19 => x"F0",
    -- sprite 4
    20 => x"90",
    21 => x"90",
    22 => x"F0",
    23 => x"10",
    24 => x"10",
    -- sprite 5
    25 => x"F0",
    26 => x"80",
    27 => x"F0",
    28 => x"10",
    29 => x"F0",
    -- sprite 6
    30 => x"F0",
    31 => x"80",
    32 => x"F0",
    33 => x"90",
    34 => x"F0",
    -- sprite 7
    35 => x"F0",
    36 => x"10",
    37 => x"20",
    38 => x"40",
    39 => x"40",
    -- sprite 8
    40 => x"F0",
    41 => x"90",
    42 => x"F0",
    43 => x"90",
    44 => x"F0",
    -- sprite 9
    45 => x"F0",
    46 => x"90",
    47 => x"F0",
    48 => x"10",
    49 => x"F0",
    -- sprite A
    50 => x"F0",
    51 => x"90",
    52 => x"F0",
    53 => x"90",
    54 => x"90",
    -- sprite B
    55 => x"E0",
    56 => x"90",
    57 => x"E0",
    58 => x"90",
    59 => x"E0",
    -- sprite C
    60 => x"F0",
    61 => x"80",
    62 => x"80",
    63 => x"80",
    64 => x"F0",
    -- sprite D
    65 => x"E0",
    66 => x"90",
    67 => x"90",
    68 => x"90",
    69 => x"E0",
    -- sprite E
    70 => x"F0",
    71 => x"80",
    72 => x"F0",
    73 => x"80",
    74 => x"F0",
    -- sprite F
    75 => x"F0",
    76 => x"80",
    77 => x"F0",
    78 => x"80",
    79 => x"80",

    16#198# => x"60",
    16#199# => x"FF",
    16#200# => x"C0",
    16#201# => x"FF",
    16#202# => x"63",
    16#203# => x"14",
    16#208# => x"70",
    16#209# => x"77",
    16#210# => x"87",
    16#211# => x"00",
    16#212# => x"87",
    16#213# => x"31",
    16#214# => x"87",
    16#215# => x"14",
    16#216# => x"87",
    16#217# => x"15",
    16#218# => x"80",
    16#219# => x"06",
    16#220# => x"87",
    16#221# => x"07",

    others => x"00"
);
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
