library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UART_rx is
    generic (
        rs232databits : integer := 8
    );
    port (
        clk         : in std_logic;
        rst         : in std_logic;
        uartrxpin   : in std_logic;
        rxdata      : out std_logic_vector(rs232databits-1 downto 0);
        rxready     : out std_logic
    );
end entity;

architecture rtl of UART_rx is
    signal shift_reg : std_logic_vector(rs232databits-1 downto 0);
    signal bit_cnt   : integer range 0 to rs232databits;
    signal rx_active : std_logic := '0';
    signal baud_clk  : std_logic;
    signal sample    : std_logic;
begin

    -- Baud Clock Generator (same as tx)
    baud_gen: process(clk)
        variable counter : integer := 0;
    begin
        if rising_edge(clk) then
            if counter = 434 then
                counter := 0;
                baud_clk <= '1';
            else
                counter := counter + 1;
                baud_clk <= '0';
            end if;
        end if;
    end process;

    -- Receiver Process
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                rx_active <= '0';
                bit_cnt <= 0;
                rxready <= '0';
            elsif rx_active = '0' and uartrxpin = '0' then  -- Start bit
                rx_active <= '1';
                bit_cnt <= 0;
                rxready <= '0';
            elsif rx_active = '1' and baud_clk = '1' then
                shift_reg(bit_cnt) <= uartrxpin;
                if bit_cnt = rs232databits - 1 then
                    rx_active <= '0';
                    rxdata <= shift_reg;
                    rxready <= '1';
                else
                    bit_cnt <= bit_cnt + 1;
                end if;
            end if;
        end if;
    end process;

end rtl;
