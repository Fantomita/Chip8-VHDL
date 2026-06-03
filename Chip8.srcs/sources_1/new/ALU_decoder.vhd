----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/24/2026 06:54:15 PM
-- Design Name: 
-- Module Name: ALU_decoder - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU_decoder is
Port ( 
    opcode_in : in Opcode;
    alu_op : out ALUOp
);
end ALU_decoder;

architecture Behavioral of ALU_decoder is

begin

process (opcode_in)
begin
    case opcode_in is
        -- Basic Arithmetic & Logic
        when LD_BYTE | LD_REG   => alu_op <= PASS_B;
        when ADD_BYTE | ADD_REG => alu_op <= ADD_OP;
        when OR_REG             => alu_op <= OR_OP;
        when AND_REG            => alu_op <= AND_OP;
        when XOR_REG            => alu_op <= XOR_OP;
        when SUB_REG            => alu_op <= SUB_OP;
        when SUBN_REG           => alu_op <= SUB_OP; -- Note: Operands swapped in ALU
        when SHR                => alu_op <= SHIFT_RIGHT_OP;
        when SHL                => alu_op <= SHIFT_LEFT_OP;

        -- Comparison Operations 
        when SE_BYTE | SE_REG   => alu_op <= SUB_OP;
        when SNE_BYTE | SNE_REG => alu_op <= SUB_OP;
        
        -- Special Operations
        when RND                => alu_op <= AND_OP; -- Random byte AND kk
        
        -- Address Math
        --when JP_REG             => alu_op <= PASS_B;
       -- when ADD_I_REG          => alu_op <= PASS_A; -- I + Vx
        
        
        -- Others (Pass through)
       -- when LD_I_REG           => alu_op <= PASS_A;
        when others             => alu_op <= PASS_B;
    end case;
end process;
end Behavioral;
