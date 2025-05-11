library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Serializer is
    generic (
        DATA_WIDTH    : integer := 8;
        DEFAULT_STATE : std_logic := '0'
    );
    port (
        Clk   : in std_logic;
        Rst   : in std_logic;
        Load  : in std_logic;
        Shift : in std_logic;
        Din   : in std_logic_vector(DATA_WIDTH - 1 downto 0);
        Dout  : out std_logic
    );
end entity;

architecture rtl of Serializer is
    signal ShiftRegister : std_logic_vector(DATA_WIDTH - 1 downto 0);
begin

    Dout <= ShiftRegister(DATA_WIDTH - 1);

    SerializerProcess : process(Clk, Rst)
    begin
        if Rst = '1' then
            ShiftRegister <= (others => DEFAULT_STATE);
        elsif rising_edge(Clk) then
            if Load = '1' then
                ShiftRegister <= Din;
            elsif Shift = '1' then
                ShiftRegister <= ShiftRegister(DATA_WIDTH - 2 downto 0) & DEFAULT_STATE;
            end if;
        end if;
    end process;

end architecture;
