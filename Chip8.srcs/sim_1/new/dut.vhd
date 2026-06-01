library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_fetch is
end tb_fetch;

architecture Behavioral of tb_fetch is

    signal CLK               : STD_LOGIC := '0';
    signal tick_cpu                : STD_LOGIC := '1';
    signal tick_timer                : STD_LOGIC := '1';
    signal RST               : STD_LOGIC := '0';
    signal ram_read_address  : unsigned (11 downto 0);
    signal ram_RE            : STD_LOGIC;
    signal ram_write_address : unsigned (11 downto 0);
    signal ram_write_data    : unsigned (7 downto 0);
    signal ram_WE            : STD_LOGIC;
    signal ram_read_data     : unsigned (7 downto 0);
    signal ram_read_ack      : STD_LOGIC;

    type rom_type is array (0 to 4095) of unsigned (7 downto 0);
    signal rom : rom_type := (
        16#200# => x"AB",
        16#201# => x"CD",
        16#202# => x"13",
        16#203# => x"00",
        others  => x"00"
    );


begin
    CLK <= not CLK after 5 ns;

    cpu : entity work.cpu port map (
        CLK               => CLK,
        tick_cpu                => tick_cpu,
        tick_timer                => tick_timer,
        RST               => RST,
        ram_read_address  => ram_read_address,
        ram_RE            => ram_RE,
        ram_write_address => ram_write_address,
        ram_write_data    => ram_write_data,
        ram_WE            => ram_WE,
        ram_read_data     => ram_read_data,
        ram_read_ack      => ram_read_ack,
        debug_register_file_read_add => debug_register_file_read_add,
        debug_register_file_read_data => debug_register_file_read_data
    );

    -- synchronous ROM
    process(CLK)
    begin
        if rising_edge(CLK) then
            ram_read_ack <= '0';
            if ram_RE = '1' then
                ram_read_data <= rom(to_integer(ram_read_address));
                ram_read_ack  <= '1';
            end if;
            if ram_WE = '1' then
                rom(to_integer(ram_write_address)) <= ram_write_data;
            end if;
        end if;
    end process;
   

end Behavioral;