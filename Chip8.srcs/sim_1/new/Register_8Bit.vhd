-- Testbench for Register_Generic (SIZE = 8)
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Register_Generic is
end tb_Register_Generic;

architecture sim of tb_Register_Generic is
  constant SIZE : integer := 8;

  signal CLK       : std_logic := '0';
  signal CE        : std_logic := '0';
  signal RST       : std_logic := '0';
  signal Serial_In : std_logic := '0';
  signal MODE      : std_logic_vector(1 downto 0) := "00";
  signal Data_In   : std_logic_vector(SIZE-1 downto 0) := (others => '0');
  signal Data_Out  : std_logic_vector(SIZE-1 downto 0);

  constant CLK_PERIOD : time := 10 ns;
begin
  -- Instantiate DUT
  UUT: entity work.Register_Generic
    generic map ( SIZE => SIZE )
    port map (
      CLK       => CLK,
      CE        => CE,
      RST       => RST,
      Serial_In => Serial_In,
      MODE      => MODE,
      Data_In   => Data_In,
      Data_Out  => Data_Out
    );

  -- Clock generation
  clk_proc: process
  begin
    loop
      CLK <= '0';
      wait for CLK_PERIOD/2;
      CLK <= '1';
      wait for CLK_PERIOD/2;
    end loop;
  end process;

  -- Stimulus
  stim_proc: process
  begin
    -- initial reset (synchronous reset asserted before clocks to show effect on first edge)
    CE  <= '0';
    RST <= '1';
    wait for 2 * CLK_PERIOD;
    RST <= '0';
    wait for CLK_PERIOD;

    CE <= '1';

    -- Parallel load 0xA5
    MODE <= "11";
    Data_In <= x"A5";
    wait for CLK_PERIOD;

    -- Hold for one cycle
    MODE <= "00";
    wait for CLK_PERIOD;

    -- Serial right shifts: MODE="01"
    MODE <= "01";
    Serial_In <= '1';
    wait for CLK_PERIOD; -- shift 1
    Serial_In <= '0';
    wait for CLK_PERIOD; -- shift 0
    Serial_In <= '1';
    wait for CLK_PERIOD; -- shift 1

    -- Hold
    MODE <= "00";
    wait for CLK_PERIOD;

    -- Serial left shifts: MODE="10"
    MODE <= "10";
    Serial_In <= '0';
    wait for CLK_PERIOD;
    Serial_In <= '1';
    wait for CLK_PERIOD;

    -- Parallel load 0xFF
    MODE <= "11";
    Data_In <= x"FF";
    wait for CLK_PERIOD;

    -- Disable CE: changes should not occur
    CE <= '0';
    MODE <= "01";
    Serial_In <= '0';
    Data_In <= x"00";
    wait for 3 * CLK_PERIOD;

    -- Re-enable and apply synchronous reset (takes effect on rising edge)
    CE <= '1';
    RST <= '1';
    wait for CLK_PERIOD;
    RST <= '0';
    wait for CLK_PERIOD;

    wait for 10 * CLK_PERIOD;
    wait;
  end process;

end sim;
