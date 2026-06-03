----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/21/2026 11:24:56 PM
-- Design Name: 
-- Module Name: common - Behavioral
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

package common is

type ALUOp is (
    PASS_A,
    PASS_B,
    SHIFT_RIGHT_OP,
    SHIFT_LEFT_OP,
    ADD_OP,
    SUB_OP,
    AND_OP,
    OR_OP,
    XOR_OP
);

type Opcode is (
    UNDEFINED,
    SYS,        --0nnn
    CLS,        --00E0    CLS    Clear display
    RET,        --00EE    RET    Return from subroutine
    JP_ADDR,    --1nnn    JP addr    Jump to address
    CALL_ADDR,  --2nnn    CALL addr    Call subroutine
    SE_BYTE,    --3xkk    SE Vx, byte    Skip if Vx == kk
    SNE_BYTE,   --4xkk    SNE Vx, byte    Skip if Vx != kk
    SE_REG,     --5xy0    SE Vx, Vy    Skip if Vx == Vy
    LD_BYTE,    --6xkk    LD Vx, byte    Set Vx = kk
    ADD_BYTE,   --7xkk    ADD Vx, byte    Set Vx = Vx + kk
    LD_REG,     --8xy0    LD Vx, Vy    Set Vx = Vy
    OR_REG,     --8xy1    OR Vx, Vy    Set Vx = Vx OR Vy
    AND_REG,    --8xy2    AND Vx, Vy    Set Vx = Vx AND Vy
    XOR_REG,    --8xy3    XOR Vx, Vy    Set Vx = Vx XOR Vy
    ADD_REG,    --8xy4    ADD Vx, Vy    Set Vx = Vx + Vy, VF = carry
    SUB_REG,    --8xy5    SUB Vx, Vy    Set Vx = Vx - Vy, VF = NOT borrow
    SHR,        --8xy6    SHR Vx    Set Vx = Vx >> 1, VF = LSB
    SUBN_REG,   --8xy7    SUBN Vx, Vy    Set Vx = Vy - Vx, VF = NOT borrow
    SHL,        --8xyE    SHL Vx    Set Vx = Vx << 1, VF = MSB
    SNE_REG,    --9xy0    SNE Vx, Vy    Skip if Vx != Vy
    LD_ADDR,    --Annn    LD I, addr    Set I = nnn
    JP_REG,     --Bnnn    JP V0, addr    Jump to nnn + V0
    RND,        --Cxkk    RND Vx, byte    Set Vx = random AND kk
    DRW,        --Dxyn    DRW Vx, Vy, n    Draw sprite at (Vx, Vy)
    SKP_KEY,    --Ex9E    SKP Vx    Skip if key Vx is pressed
    SKNP_KEY,   --ExA1    SKNP Vx    Skip if key Vx is not pressed
    LD_TIMER,   --Fx07    LD Vx, DT    Set Vx = delay timer
    LD_KEY,     --Fx0A    LD Vx, K    Wait for key press, store in Vx
    LD_DELAY,   --Fx15    LD DT, Vx    Set delay timer = Vx
    LD_SOUND,   --Fx18    LD ST, Vx    Set sound timer = Vx
    ADD_I_REG,  --Fx1E    ADD I, Vx    Set I = I + Vx
    LD_I_REG,   --Fx29    LD F, Vx    Set I = sprite location for digit Vx
    LD_BCD_REG, --Fx33    LD B, Vx    Store BCD of Vx at I, I+1, I+2
    LD_I_REGS,  --Fx55    LD [I], Vx    Store V0-Vx in memory at I
    LD_REGS_I   --Fx65    LD Vx, [I]    Load V0-Vx from memory at I
);

type StackOp is (
    PUSH,
    POP	
);

type GpuCommands is (
    CLEAR_SCREEN,
    DRAW_SCREEN
);

end package common;

package body common is

end package body common;
