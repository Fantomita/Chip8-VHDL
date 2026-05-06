----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/06/2026 04:10:53 PM
-- Design Name: 
-- Module Name: stack - Behavioral
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

library WORK;
use WORK.common.All;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity stack is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           EN : in STD_LOGIC;
           op : in stackop;
           data_in : in unsigned (11 downto 0);
           data_out : out unsigned (11 downto 0));
end stack;

architecture Behavioral of stack is

type memory_type is array (0 to 15) of unsigned (11 downto 0);
signal memory : memory_type := (others => (others => '0'));

signal stack_pointer : unsigned (3 downto 0) := "0000";
signal data_out_i : unsigned (11 downto 0);

begin

process (clk)
begin

    if rising_edge(clk) then
        if RST = '1' then
            stack_pointer <= "0000" ;
        else
            if EN = '1' then
                if op = PUSH then
                        memory (to_integer(stack_pointer)) <= data_in;
                        if stack_pointer < 11 then
                            stack_pointer <= stack_pointer + 1;
                    end if;
                elsif op = POP then
                        data_out_i <= memory(to_integer(stack_pointer - 1));
                        stack_pointer <= stack_pointer - 1;
                end if;
            end if;
       end if;
   end if;
end process;

data_out <= data_out_i;


end Behavioral;
