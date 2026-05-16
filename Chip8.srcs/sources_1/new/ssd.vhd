library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SSD is
    Port ( digit0 : in unsigned (3 downto 0);
           digit1 : in unsigned (3 downto 0);
           digit2 : in unsigned (3 downto 0);
           digit3 : in unsigned (3 downto 0);
           CLK : in STD_LOGIC;
           CAT : out STD_LOGIC_VECTOR (6 downto 0);
           AN : out STD_LOGIC_VECTOR (3 downto 0));
end SSD;

architecture Behavioral of SSD is


signal clock_divider : unsigned (13 downto 0) := (others => '1');
signal CE : STD_LOGIC := '0';
signal counter_i : unsigned (1 downto 0) := (others => '0');
signal out_mux_i : unsigned (3 downto 0);
begin

process(CLK)
begin
  if rising_edge(CLK) then 
    clock_divider <= clock_divider - 1;
  end if;

end process;

process(CLK)
begin
    if rising_edge(CLK) then
        if CE = '1' then
            counter_i <= counter_i + 1;
        end if;
    end if;
end process;

CE <= '1' when clock_divider = 0 else '0'; 

-- MUX ANOZI
process(counter_i)
begin
    case counter_i is 
        when "00" => AN <= "1110";
        when "01" => AN <= "1101";
        when "10" => AN <= "1011";
        when "11" => AN <= "0111";
        when others => null;
    end case;
end process;

process(counter_i, digit0, digit1, digit2, digit3)
begin
   case counter_i is 
        when "00" => out_mux_i <= digit0;
        when "01" => out_mux_i <= digit1;
        when "10" => out_mux_i <= digit2;
        when "11" => out_mux_i <= digit3;
        when others => null;
    end case;

end process;

--decoderul
process(out_mux_i)
begin
    case out_mux_i is
           when "0000" => cat<="0000001"; ---abcdefg
           when "0001" => cat<="1001111";
           when "0010" => cat<="0010010";
           when "0011" => cat<="0000110";
   
           when "0100" => cat<="1001100";
           when "0101" => cat<="0100100";
           when "0110" => cat<="0100000";
           when "0111" => cat<="0001111";
   
           when "1000" => cat<="0000000";
           when "1001" => cat<="0000100";
           when "1010" => cat<="0001000";
           when "1011" => cat<="1100000";
   
           when "1100" => cat<="0110001";
           when "1101" => cat<="1000010";
           when "1110" => cat<="0110000";
           when others => cat<="0111000";
      
    end case;

end process;


end Behavioral;
