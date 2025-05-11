library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DualPortRAM is
    generic (
        DATA_WIDTH : integer := 8;
        ADDR_WIDTH : integer := 4
    );
    port (
        clk     : in  std_logic;

        -- Port A: R/W
        we_a    : in  std_logic;
        addr_a  : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
        din_a   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        dout_a  : out std_logic_vector(DATA_WIDTH-1 downto 0);

        -- Port B: R
        addr_b  : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
        dout_b  : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end entity;

architecture Behavioral of DualPortRAM is
    type ram_type is array (0 to 2**ADDR_WIDTH - 1) of std_logic_vector(DATA_WIDTH-1 downto 0);
    signal ram : ram_type := (others => (others => '0'));
begin
    -- Port A: R/W
    process(clk)
    begin
        if rising_edge(clk) then
            if we_a = '1' then
                ram(to_integer(unsigned(addr_a))) <= din_a;
            end if;
        end if;
    end process;
    dout_a <= ram(to_integer(unsigned(addr_a)));

    -- Port B: Asynchronous Read
    dout_b <= ram(to_integer(unsigned(addr_b)));
end architecture;
