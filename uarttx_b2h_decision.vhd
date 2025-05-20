library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_tx is
    generic (
        CLK_FREQ  : integer := 50000000;
        BAUD_RATE : integer := 115200
    );
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        tx_start  : in  std_logic;          -- pulse to start sending
        tx_data   : in  std_logic_vector(7 downto 0);
        tx_serial : out std_logic;
        tx_busy   : out std_logic           -- high when transmitting
    );
end uart_tx;

architecture Behavioral of uart_tx is
    constant CLKS_PER_BIT : integer := CLK_FREQ / BAUD_RATE;
    signal clk_count      : integer range 0 to CLKS_PER_BIT - 1 := 0;
    signal bit_index      : integer range 0 to 9 := 0;  -- start + 8 data + stop
    signal shift_reg      : std_logic_vector(9 downto 0) := (others => '1');
    signal transmitting   : std_logic := '0';
begin
    process(clk, rst)
    begin
        if rst = '1' then
            clk_count <= 0;
            bit_index <= 0;
            shift_reg <= (others => '1');
            transmitting <= '0';
            tx_serial <= '1';  -- idle state
            tx_busy <= '0';
        elsif rising_edge(clk) then
            if transmitting = '0' then
                tx_serial <= '1';
                tx_busy <= '0';
                clk_count <= 0;
                bit_index <= 0;

                if tx_start = '1' then
                    -- Load shift register: start bit=0, data bits LSB first, stop bit=1
                    shift_reg(0) <= '0';                    -- start bit
                    shift_reg(8 downto 1) <= tx_data;      -- data bits
                    shift_reg(9) <= '1';                    -- stop bit
                    transmitting <= '1';
                    tx_busy <= '1';
                end if;

            else  -- transmitting = '1'
                if clk_count = CLKS_PER_BIT - 1 then
                    clk_count <= 0;
                    tx_serial <= shift_reg(bit_index);
                    if bit_index = 9 then
                        transmitting <= '0'; -- done sending
                    else
                        bit_index <= bit_index + 1;
                    end if;
                else
                    clk_count <= clk_count + 1;
                end if;
            end if;
        end if;
    end process;
end Behavioral;


