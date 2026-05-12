----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/02/2026 08:44:08 PM
-- Design Name: 
-- Module Name: cpu - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created1
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

entity cpu is
    Port ( CLK : in STD_LOGIC;
           RST: in STD_LOGIC;
           tick_cpu : in STD_LOGIC;
           tick_timer : in STD_LOGIC;
           ram_read_address : out unsigned (11 downto 0);
           ram_RE : out STD_LOGIC;
           ram_write_address : out unsigned (11 downto 0);
           ram_write_data : out unsigned (7 downto 0);
           ram_WE : out STD_LOGIC;
           ram_read_data : in unsigned (7 downto 0);
           ram_read_ack : in STD_LOGIC);
end cpu;

architecture Behavioral of cpu is

type CPU_STATE is (
    WAIT_CLK,
    WAIT_CYCLE,
    FETCH_HI,
    FETCH_LO,
    INCREMENT_PC,
    DECODE,
    JUMP_ADDRESS,
    JUMP_RELATIVE,
    SKIP_INSTRUCTION,
    WRITE_STACK,
    CHECK_ZERO,
    STORE_VX_REG,
    STORE_CARRY_REG,
    STORE_I_REG
);

signal state_i : CPU_STATE := WAIT_CLK;
signal wait_state_i : CPU_STATE := WAIT_CLK;

-- I REGISTER SIGNALS
signal i_register_enable_i : STD_LOGIC;
signal i_register_data_in_i : unsigned (11 downto 0);
signal i_register_data_out_i : unsigned (11 downto 0);

-- REGISTER FILE SIGNALS

signal register_file_read_add1_i : unsigned (3 downto 0);
signal register_file_read_add2_i : unsigned (3 downto 0);
signal register_file_write_add_i : unsigned (3 downto 0);
signal register_file_write_data_i : unsigned (7 downto 0);
signal register_file_WE_i : STD_LOGIC;
signal register_file_data1_i : unsigned (7 downto 0);
signal register_file_data2_i : unsigned (7 downto 0);
signal register_file_data1_sync_i : unsigned (7 downto 0);
signal register_file_data2_sync_i : unsigned (7 downto 0);

-- INSTRUCTION DECODER SIGNALS
signal instruction_i : unsigned (15 downto 0);
signal instruction_lo_i : unsigned (7 downto 0);
signal instruction_hi_i : unsigned (7 downto 0);
signal x_i : unsigned (3 downto 0);
signal y_i : unsigned (3 downto 0);
signal nnn_i : unsigned (11 downto 0);
signal kk_i : unsigned (7 downto 0);
signal n_i : unsigned (3 downto 0);
signal opc_i : Opcode;

-- PROGRAM COUNTER SIGNALS 
signal inc_pc_i : STD_LOGIC;
signal load_pc_i : STD_LOGIC;
signal load_pc_data_i : unsigned (11 downto 0);
signal pc_out_i : unsigned (11 downto 0);

-- RAM SIGNALS
signal read_instruction_low : STD_LOGIC;
signal read_instruction_high : STD_LOGIC;

-- STACK SIGNALS
signal stack_data_in_i : unsigned (11 downto 0);
signal stack_data_out_i : unsigned (11 downto 0);
signal stack_EN_i : std_logic;
signal stack_op_i : StackOp;

-- ALU SIGNALS
signal alu_data_a_i : unsigned (7 downto 0);
signal alu_data_b_i : unsigned (7 downto 0);
signal alu_carry_i : STD_LOGIC;
signal alu_data_out_i : unsigned (7 downto 0);
signal alu_zf_i : STD_LOGIC;
signal alu_op_i : ALUOp;

-- RNG SIGNALS
signal rng_data_i : unsigned (7 downto 0);

-- DELAY TIMER SIGNALS
signal dt_load_enable_i : STD_LOGIC;
signal dt_load_data_i : unsigned (7 downto 0);
signal dt_data_out_i : unsigned (7 downto 0);
signal dt_nonzero_i : STD_LOGIC;

-- SOUND TIMER SIGNALS
signal st_load_enable_i : STD_LOGIC;
signal st_load_data_i : unsigned (7 downto 0);
signal st_data_out_i : unsigned (7 downto 0);
signal st_nonzero_i : STD_LOGIC;

begin

-- I REGISTER STUFF
i_register : entity WORK.register_generic generic map (SIZE => 12) port map (
    CLK => CLK,
    RST => RST,
    EN => i_register_enable_i,
    data_in => i_register_data_in_i,
    data_out => i_register_data_out_i
);

i_register_enable_i <= '1' when (state_i = STORE_I_REG) else '0';
i_register_data_in_i <= nnn_i when (opc_i = LD_ADDR and state_i = STORE_I_REG) else x"000";


-- REGISTER FILE STUFF
register_file : entity WORK.register_file port map (
    read_add1 => register_file_read_add1_i,
    read_add2 => register_file_read_add2_i,
    write_add => register_file_write_add_i,
    write_data => register_file_write_data_i,
    CLK => CLK,
    RST => RST,
    WE => register_file_WE_i,
    read_data1 => register_file_data1_i,
    read_data2 => register_file_data2_i
);

register_file_register_data1 : entity WORK.register_generic generic map (SIZE => 8) port map (
   CLK => CLK,
   RST => RST,
   EN => '1',
   data_in => register_file_data1_i,
   data_out => register_file_data1_sync_i
);

register_file_register_data2 : entity WORK.register_generic generic map (SIZE => 8) port map (
   CLK => CLK,
   RST => RST,
   EN => '1',
   data_in => register_file_data2_i,
   data_out => register_file_data2_sync_i
);

register_file_write_add_i <= x_i when (opc_i = LD_BYTE and state_i = STORE_VX_REG) else
                             x_i when (opc_i = ADD_BYTE and state_i = STORE_VX_REG) else
                             x_i when (opc_i = LD_REG and state_i = STORE_VX_REG) else
                             x_i when (opc_i = OR_REG and state_i = STORE_VX_REG) else
                             x_i when (opc_i = AND_REG and state_i = STORE_VX_REG) else
                             x_i when (opc_i = XOR_REG and state_i = STORE_VX_REG) else
                             x_i when (opc_i = ADD_REG and state_i = STORE_VX_REG) else
                             x"F" when (opc_i = ADD_REG and state_i = STORE_CARRY_REG) else
                             x_i when (opc_i = SUB_REG and state_i = STORE_VX_REG) else
                             x"F" when (opc_i = SUB_REG and state_i = STORE_CARRY_REG) else
                             x_i when (opc_i = SHR and state_i = STORE_VX_REG) else
                             x"F" when (opc_i = SHR and state_i = STORE_CARRY_REG) else
                             x_i when (opc_i = SUBN_REG and state_i = STORE_VX_REG) else
                             x"F" when (opc_i = SUBN_REG and state_i = STORE_CARRY_REG) else
                             x_i when (opc_i = SHL and state_i = STORE_VX_REG) else
                             x"F" when (opc_i = SHL and state_i = STORE_CARRY_REG) else
                             x_i when (opc_i = RND and state_i = STORE_VX_REG) else
                             x_i when (opc_i = LD_TIMER and state_i = STORE_VX_REG) else
                             x"0";
                             
register_file_write_data_i <= alu_data_out_i when (opc_i = LD_BYTE and state_i = STORE_VX_REG) else
                              alu_data_out_i when (opc_i = ADD_BYTE and state_i = STORE_VX_REG) else
                              alu_data_out_i when (opc_i = LD_REG and state_i = STORE_VX_REG) else
                              alu_data_out_i when (opc_i = OR_REG and state_i = STORE_VX_REG) else
                              alu_data_out_i when (opc_i = AND_REG and state_i = STORE_VX_REG) else
                              alu_data_out_i when (opc_i = XOR_REG and state_i = STORE_VX_REG) else
                              "0000000" & alu_carry_i when (opc_i = ADD_REG and state_i = STORE_CARRY_REG) else
                              alu_data_out_i when (opc_i = ADD_REG and state_i = STORE_VX_REG) else
                              "0000000" & alu_carry_i when (opc_i = SUB_REG and state_i = STORE_CARRY_REG) else 
                              alu_data_out_i when (opc_i = SUB_REG and state_i = STORE_VX_REG) else
                              "0000000" & alu_carry_i when (opc_i = SHR and state_i = STORE_CARRY_REG) else
                              alu_data_out_i when (opc_i = SHR and state_i = STORE_VX_REG) else
                              "0000000" & alu_carry_i when (opc_i = SUBN_REG and state_i = STORE_CARRY_REG) else
                              alu_data_out_i when (opc_i = SUBN_REG and state_i = STORE_VX_REG) else
                              "0000000" & alu_carry_i when (opc_i = SHL and state_i = STORE_CARRY_REG) else
                              alu_data_out_i when (opc_i = SHL and state_i = STORE_VX_REG) else
                              alu_data_out_i when (opc_i = RND and state_i = STORE_VX_REG) else
                              dt_data_out_i when (opc_i = LD_TIMER and state_i = STORE_VX_REG) else
                              x"00";
register_file_WE_i <= '1' when (state_i = STORE_VX_REG or state_i = STORE_CARRY_REG) else '0';


with opc_i select register_file_read_add1_i <=
    y_i when SUBN_REG,
    x_i when others; -- TO BE MODIFIED
    
with opc_i select register_file_read_add2_i <=
    x_i when SUBN_REG,
    x"0" when JP_REG,
    y_i when others; -- TO BE MODIFIED

-- INSTRUCTION DECODER STUFF
instruction_decoder : entity WORK.instruction_decoder port map (
   instruction => instruction_i,
   x => x_i,
   y => y_i,
   nnn => nnn_i,
   kk => kk_i,
   n => n_i,
   opc => opc_i
);

-- PROGRAM COUNTER STUFF
pc_reg : entity WORK.program_counter port map (
   CLK => CLK,
   RST => RST,
   inc_pc => inc_pc_i,
   load_pc => load_pc_i,
   load_data => load_pc_data_i,
   pc_out => pc_out_i
);     

inc_pc_i <= '1' when (state_i = INCREMENT_PC) else '0';
load_pc_i <= '1' when (state_i = JUMP_ADDRESS or state_i = JUMP_RELATIVE or state_i = SKIP_INSTRUCTION) else '0';
load_pc_data_i <= nnn_i when (state_i = JUMP_ADDRESS) else (nnn_i + ("0000" & alu_data_out_i)) when (state_i = JUMP_RELATIVE) else x"200";
        
-- RAM STUFF
instruction_register_high : entity WORK.register_generic generic map (SIZE => 8) port map (
   CLK => CLK,
   RST => RST,
   EN => read_instruction_high,
   data_in => ram_read_data,
   data_out => instruction_hi_i
);

instruction_register_low  : entity WORK.register_generic generic map (SIZE => 8) port map (
   CLK => CLK,
   RST => RST,
   EN => read_instruction_low,
   data_in => ram_read_data,
   data_out => instruction_lo_i
);

instruction_i <= instruction_hi_i & instruction_lo_i;

ram_RE <= '1' when (state_i = FETCH_HI or state_i = FETCH_LO) else '0';
ram_read_address <= pc_out_i when (state_i = FETCH_HI) else pc_out_i + 1 when (state_i = FETCH_LO) else x"000";  
read_instruction_high <= '1' when (state_i = FETCH_HI and ram_read_ack = '1') else '0';
read_instruction_low <= '1' when (state_i = FETCH_LO and ram_read_ack = '1') else '0';
        
-- STACK STUFF
stack : entity WORK.stack port map (
    CLK => CLK,
    RST => RST,
    EN => stack_EN_i,
    op => stack_op_i,
    data_in => stack_data_in_i,
    data_out => stack_data_out_i
);

stack_EN_i <= '1' when (state_i = WRITE_STACK) else '0';
stack_op_i <= PUSH when (state_i = WRITE_STACK) else POP;
stack_data_in_i <= pc_out_i + 2 when (state_i = WRITE_STACK ) else x"000";

-- ALU STUFF
alu : entity WORK.ALU port map (
    data_a => alu_data_a_i,
    data_b => alu_data_b_i,
    carry => alu_carry_i,
    op => alu_op_i,
    data_out => alu_data_out_i,
    ZF => alu_ZF_i
);

alu_decoder : entity WORK.ALU_decoder port map (
    opcode_in => opc_i,
    alu_op => alu_op_i
); 

with opc_i select alu_data_a_i <=
    rng_data_i when RND,
    register_file_data1_sync_i when others;
    
with opc_i select alu_data_b_i <=
    kk_i when SE_BYTE,
    kk_i when SNE_BYTE,
    kk_i when LD_BYTE,
    kk_i when ADD_BYTE,
    kk_i when RND,
    register_file_data2_sync_i when others;

-- RNG STUFF
rng : entity WORK.rng port map (
    CLK => CLK,
    data_out => rng_data_i
);

-- DELAY TIMER STUFF
dt : entity WORK.timer port map (
    CLK => CLK,
    CE => tick_timer,
    RST => RST,
    load_enable => dt_load_enable_i,
    load_data => dt_load_data_i,
    data_out => dt_data_out_i,
    nonzero => dt_nonzero_i
);

dt_load_enable_i <= '1' when (opc_i = LD_DELAY) else '0';
dt_load_data_i <= register_file_data1_sync_i;


-- SOUND TIMER STUFF
st : entity WORK.timer port map (
    CLK => CLK,
    CE => tick_timer,
    RST => RST,
    load_enable => st_load_enable_i,
    load_data => st_load_data_i,
    data_out => st_data_out_i,
    nonzero => st_nonzero_i
);

dt_load_enable_i <= '1' when (opc_i = LD_SOUND) else '0';
dt_load_data_i <= register_file_data1_sync_i;

process(CLK)
begin
    if rising_edge(CLK) then
        if  RST = '1' then
            null;
        else
            if  tick_cpu = '1' then
                case state_i is
                    when FETCH_HI =>
                        if  ram_read_ack = '1' then
                            state_i <= WAIT_CYCLE;
                            wait_state_i <= FETCH_LO;
                        end if;
                    when FETCH_LO =>
                        if  ram_read_ack = '1' then
                            state_i <= WAIT_CYCLE;
                            wait_state_i <= INCREMENT_PC;
                        end if;
                    when INCREMENT_PC =>
                        state_i <= WAIT_CYCLE;
                        wait_state_i <= DECODE;
                    when DECODE =>
                        state_i <= WAIT_CLK;
                        wait_state_i <= WAIT_CLK;
                        case opc_i is
--                            when CLS => ;
--                            when RET => ;
                            when JP_ADDR => 
                                state_i <= JUMP_ADDRESS; -- ????
                            when CALL_ADDR => 
                                state_i <= WRITE_STACK;
                            when SE_BYTE =>
                                state_i <= CHECK_ZERO;
                            when SNE_BYTE => 
                                state_i <= CHECK_ZERO;
                            when SE_REG => 
                                state_i <= CHECK_ZERO;
                            when LD_BYTE => 
                                state_i <= STORE_VX_REG;
                            when ADD_BYTE => 
                                state_i <= STORE_VX_REG;
                            when LD_REG => 
                                state_i <= STORE_VX_REG;
                            when OR_REG => 
                                state_i <= STORE_VX_REG;
                            when AND_REG => 
                                state_i <= STORE_VX_REG;
                            when XOR_REG =>
                                state_i <= STORE_VX_REG;
                            when ADD_REG => 
                                state_i <= STORE_CARRY_REG;
                            when SUB_REG => 
                                state_i <= STORE_CARRY_REG;
                            when SHR => 
                                state_i <= STORE_CARRY_REG;
                            when SUBN_REG => 
                                state_i <= STORE_CARRY_REG;
                            when SHL => 
                                state_i <= STORE_CARRY_REG;
                            when SNE_REG => 
                                state_i <= CHECK_ZERO;
                            when LD_ADDR =>    
                                state_i <= STORE_I_REG;
                            when JP_REG => 
                                state_i <= JUMP_RELATIVE;
                            when RND => 
                                state_i <= STORE_VX_REG;
--                            when DRW => ;
--                            when SKP_KEY => ;
--                            when SKNP_KEY => ;
                            when LD_TIMER => 
                                state_i <= STORE_VX_REG;
--                            when LD_KEY => ;
                            when LD_DELAY => 
                                null;
                            when LD_SOUND => 
                                null;
--                            when ADD_I_REG => ;
--                            when LD_I_REG => ;
--                            when LD_BCD_REG => ;
--                            when LD_I_REGS => ;
--                            when LD_REGS_I => ;
                            when others => null;
                        end case;
                    when JUMP_ADDRESS =>
                        state_i <= WAIT_CLK;
                    when JUMP_RELATIVE =>
                        state_i <= WAIT_CLK;
                    when WRITE_STACK =>
                        state_i <= JUMP_ADDRESS;
                    when CHECK_ZERO =>
                        state_i <= WAIT_CLK;
                        if (alu_ZF_i = '1' and (opc_i = SE_BYTE or opc_i = SE_REG)) then
                            state_i <= INCREMENT_PC;
                        end if;
                        if (alu_ZF_i = '0' and (opc_i = SNE_BYTE or opc_i = SNE_REG)) then
                            state_i <= INCREMENT_PC;
                        end if;
                    when STORE_VX_REG =>
                        state_i <= WAIT_CLK;
                        wait_state_i <= WAIT_CLK;
                    when STORE_CARRY_REG =>
                        state_i <= STORE_VX_REG;
                        wait_state_i <= WAIT_CLK;
                    when STORE_I_REG =>
                        state_i <= WAIT_CLK;
                        wait_state_i <= WAIT_CLK;
                        
                    when WAIT_CYCLE =>
                        state_i <= wait_state_i;
                        wait_state_i <= WAIT_CLK;
                    when WAIT_CLK =>
                        if tick_cpu = '1' then
                            state_i <= FETCH_HI; -- update memory counter when that exists
                        end if;
                        wait_state_i <= WAIT_CLK;
                        
                    when others => null;
                end case;
            
            end if;
        end if;
    
    end if;

end process;




end Behavioral;
