----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/03/2026 10:01:22 PM
-- Design Name: 
-- Module Name: key_encoder - Behavioral
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

entity key_encoder is
    Port (
        clk      : in  STD_LOGIC;
        row      : in  STD_LOGIC_VECTOR (0 to 3);
        col      : out STD_LOGIC_VECTOR (0 to 3);
        hex_data : out unsigned (3 downto 0);
        valid    : out STD_LOGIC
    );
end key_encoder;

architecture Behavioral of key_encoder is

component pmod_keypad is
    Port ( 
        clk : in STD_LOGIC;
        row : in STD_LOGIC_VECTOR (0 to 3);
        col : out STD_LOGIC_VECTOR (0 to 3);
        x0, x1, x2, x3 : out STD_LOGIC_VECTOR (0 to 3)
    );
end component;

signal x0_i, x1_i, x2_i, x3_i : STD_LOGIC_VECTOR(0 to 3);

begin

keypad_scanner_inst: pmod_keypad
port map(
    clk => clk,
    row => row,
    col => col,
    x0  => x0_i,
    x1  => x1_i,
    x2  => x2_i,
    x3  => x3_i
);

process(clk)
begin
    if rising_edge(clk) then
        valid <= '1';
        
        if    x0_i = "0111" then hex_data <= x"1";
        elsif x0_i = "1011" then hex_data <= x"4";
        elsif x0_i = "1101" then hex_data <= x"7";
        elsif x0_i = "1110" then hex_data <= x"0";
        
        elsif x1_i = "0111" then hex_data <= x"2";
        elsif x1_i = "1011" then hex_data <= x"5";
        elsif x1_i = "1101" then hex_data <= x"8";
        elsif x1_i = "1110" then hex_data <= x"F";
        
        elsif x2_i = "0111" then hex_data <= x"3";
        elsif x2_i = "1011" then hex_data <= x"6";
        elsif x2_i = "1101" then hex_data <= x"9";
        elsif x2_i = "1110" then hex_data <= x"E";
        
        elsif x3_i = "0111" then hex_data <= x"A";
        elsif x3_i = "1011" then hex_data <= x"B";
        elsif x3_i = "1101" then hex_data <= x"C";
        elsif x3_i = "1110" then hex_data <= x"D";
        
        else
            valid <= '0';
            hex_data <= x"0";
        end if;
    end if;
end process;

end Behavioral;