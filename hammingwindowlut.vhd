library ieee;
use ieee.STD_LOGIC_1164.ALL;
use ieee.NUMERIC_STD.ALL;

entity window_unit is
    generic (
        FRAME_SIZE : integer := 512;
        DATA_WIDTH : integer := 16
    );
    port (
        clk        : in  std_logic;
        rst        : in  std_logic;
        start      : in  std_logic;
        data_in    : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        addr       : out integer range 0 to FRAME_SIZE-1;
        data_out   : out std_logic_vector(DATA_WIDTH-1 downto 0);
        done       : out std_logic
    );
end window_unit;

architecture Behavioral of window_unit is
    type lut_type is array (0 to FRAME_SIZE-1) of integer range 0 to 65535;
    constant HAMMING_LUT : lut_type := (
        --Precomputed 512-point Hamming window coefficients
        5243, 5250, 5264, 5286, ..., 5250  -- this is random, but has to be replaced by the python script called precomputedcoeff.py
    );
    signal index : integer range 0 to FRAME_SIZE-1 := 0;
    signal product : unsigned(31 downto 0);
begin
    process(clk, rst)
    begin
        if rst = '1' then
            index <= 0;
            done <= '0';
        elsif rising_edge(clk) then
            if start = '1' then
                product <= unsigned(data_in) * to_unsigned(HAMMING_LUT(index), 16);
                data_out <= std_logic_vector(product(31 downto 16));  --scale back to 16-bit
                addr <= index;
                index <= index + 1;
                if index = FRAME_SIZE-1 then
                    done <= '1';
                    index <= 0;
                else
                    done <= '0';
                end if;
            else
                done <= '0';
            end if;
        end if;
    end process;
end Behavioral;
