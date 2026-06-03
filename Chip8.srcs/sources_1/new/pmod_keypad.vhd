library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity pmod_keypad is
    Port ( row : in STD_LOGIC_VECTOR (0 to 3);
           col : out STD_LOGIC_VECTOR (0 to 3);
           clk : in STD_LOGIC;
           x0, x1, x2, x3 : out STD_LOGIC_VECTOR (0 to 3));
end pmod_keypad;

architecture Behavioral of pmod_keypad is
    signal clock_divider : std_logic_vector (18 downto 0) := (others => '1');
    signal ce : std_logic := '0';
    signal x0_i : std_logic_vector(0 to 3);
    signal x1_i : std_logic_vector(0 to 3);
    signal x2_i : std_logic_vector(0 to 3);
    signal x3_i : std_logic_vector(0 to 3);
    signal counter_i : std_logic_vector(0 to 1) := "00";
    signal col_i : std_logic_vector (0 to 3);
begin

    process (clk)
    begin
        if (rising_edge(clk)) then
                clock_divider <= clock_divider - 1;
        end if;
    end process;
    
    ce <= '1' when (clock_divider = 0) else '0'; 

    process (clk)
    begin
        if(rising_edge(clk)) then
            if ce = '1' then
                counter_i <= counter_i + 1;
            end if;
        end if;
    end process;    

    process (clk)
    begin
        if (rising_edge(clk)) then
            if ce = '1' then
                case counter_i is
                    when "00" => 
                        col_i <= "0111";
                        x3_i <= row;
                    when "01" => 
                        col_i <= "1011";
                        x0_i <= row;
                    when "10" => 
                        col_i <= "1101";
                        x1_i <= row;
                    when "11" => 
                        col_i <= "1110";
                        x2_i <= row;
                    when others => 
                        col_i <= "1111";
                        x0_i <= x"F"; 
                        x1_i <= x"F"; 
                        x2_i <= x"F"; 
                        x3_i <= x"F";
                end case;
            end if;
        end if;
            
    end process;
  
    col <= col_i;
    x0 <= x0_i;
    x1 <= x1_i;
    x2 <= x2_i;
    x3 <= x3_i;
  
end Behavioral;
