----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/02/2026 09:13:39 PM
-- Design Name: 
-- Module Name: instruction_decoder - Behavioral
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
use WORK.common.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity instruction_decoder is
    Port ( instruction : in unsigned (15 downto 0);
           x : out unsigned (3 downto 0);
           y : out unsigned (3 downto 0);
           nnn : out unsigned (11 downto 0);
           kk : out unsigned (7 downto 0);
           n : out unsigned (3 downto 0);
           opc: out Opcode
           );
           
end instruction_decoder;

architecture Behavioral of instruction_decoder is

signal op_i : unsigned (3 downto 0);
signal opc_i : Opcode;
signal x_i : unsigned (3 downto 0);
signal y_i : unsigned (3 downto 0);
signal nnn_i : unsigned (11 downto 0);
signal n_i: unsigned(3 downto 0);
signal kk_i : unsigned(7 downto 0);
begin

op_i <= instruction (15 downto 12);
x_i <= instruction (11 downto 8);
y_i <= instruction (7 downto 4);
nnn_i <= instruction (11 downto 0);
kk_i <= instruction (7 downto 0);
n_i <= instruction (3 downto 0);


process (instruction, op_i, kk_i, n_i)
begin
    case op_i is
        when x"0" =>
            if (instruction = x"00E0") then
                opc_i <= CLS;
            elsif (instruction = x"00EE") then
                opc_i <= RET;
            else
                opc_i <= SYS;
            end if;
        when x"1" =>
            opc_i <= JP_ADDR;
        when x"2" =>
            opc_i <= CALL_ADDR;
        when x"3" =>
            opc_i <= SE_BYTE;
        when x"4" =>
            opc_i <= SNE_BYTE;
        when x"5" =>
            opc_i <= SE_REG;
        when x"6" =>
            opc_i <= LD_BYTE;
        when x"7" =>
            opc_i <= ADD_BYTE;
        when x"8" => 
            case n_i is
                when x"0" => 
                    opc_i <= LD_REG;
                when x"1" => 
                    opc_i <= OR_REG;
                when x"2" => 
                    opc_i <= AND_REG;
                when x"3" => 
                    opc_i <= XOR_REG;
                when x"4" => 
                    opc_i <= ADD_REG;
                when x"5" => 
                    opc_i <= SUB_REG;
                when x"6" => 
                    opc_i <= SHR;
                when x"7" => 
                    opc_i <= SUBN_REG;
                when x"E" => 
                    opc_i <= SHL;
                when others =>
                    opc_i <= UNDEFINED;
            end case;
        when x"9" =>
            opc_i <= SNE_REG;
        when x"A" =>
            opc_i <= LD_ADDR;
        when x"B" =>
            opc_i <= JP_REG;
        when x"C" =>
            opc_i <= RND;
        when x"D" =>
            opc_i <= DRW;
        when x"E" =>
            case kk_i is
                when x"9E" =>
                    opc_i <= SKP_KEY;
                when x"A1" =>
                    opc_i <= SKNP_KEY;
                when others =>
                    opc_i <= UNDEFINED;
            end case;
        when x"F" =>
            case kk_i is
                when x"07" =>
                    opc_i <= LD_TIMER;
                when x"0A" =>
                    opc_i <= LD_KEY;
                when x"15" =>
                    opc_i <= LD_DELAY;
                when x"18" =>
                    opc_i <= LD_SOUND;
                when x"1E" =>
                    opc_i <= ADD_I_REG;
                when x"29" =>
                    opc_i <= LD_I_REG;
                when x"33" =>
                     opc_i <= LD_BCD_REG;
                when x"55" =>
                    opc_i <= LD_I_REGS;
                when x"65" =>
                    opc_i <= LD_REGS_I;
                when others =>
                    opc_i <= UNDEFINED;
            end case;
        when others =>
            opc_i <= UNDEFINED;
      end case;
        
end process;

opc <= opc_i;
x <= x_i;
y <= y_i;
nnn <= nnn_i;
kk <= kk_i;
n <= n_i;

end Behavioral;
