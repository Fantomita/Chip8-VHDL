----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/22/2026 09:45:46 AM
-- Design Name: 
-- Module Name: ALU - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

library WORK;
use WORK.common.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port ( data_a, data_b : in unsigned (7 downto 0);
           carry : out STD_LOGIC;
           op : in ALUOp;
           data_out : out unsigned (7 downto 0);
           ZF : out STD_LOGIC);
end ALU;

architecture Behavioral of ALU is

signal result_i : unsigned (8 downto 0);

begin

process(data_a, data_b, op)
begin
    case op is
        when PASS_A => 
            result_i <= '0' & data_a;
            carry <= '0';
        when PASS_B => 
            result_i <= '0' & data_b;
            carry <= '0';
        when SHIFT_RIGHT_OP => 
            result_i <= "00" & data_a (7 downto 1);
            carry <= data_a (0);
        when SHIFT_LEFT_OP => 
            result_i <= '0' & data_a (6 downto 0) & '0';
            carry <= data_a (7);
        when ADD_OP => 
            result_i <= ('0' & data_a) + ('0' & data_b);
            if (data_a + data_b > 255) then 
                carry <= '1';
            else
                carry <= '0';
            end if;
        when SUB_OP => 
            result_i <= ('0' & data_a) - ('0' & data_b);
            if (data_a > data_b) then
                carry <= '1';
            else 
                carry <= '0';
             end if;
        when AND_OP => 
            result_i <= '0' & (data_a and data_b);
            carry <= '0';
        when OR_OP => 
            result_i <= '0' & (data_a or data_b);
            carry <= '0';
        when XOR_OP => 
            result_i <= '0' & (data_a xor data_b);
            carry <= '0';
        when others => 
            result_i <= (others => '0');
            carry <= '0';
    end case;        
end process;

data_out <= result_i (7 downto 0);
ZF <= '1' when result_i (7 downto 0) = 0 else '0';

end Behavioral;
