library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UART_tx is
    generic (
        rs232databits : integer := 8
    );
    port (
        clk         : in std_logic;
        rst         : in std_logic;
        txstart     : in std_logic;
        txdata      : in std_logic_vector(rs232databits-1 downto 0);
        uarttxpin   : out std_logic
    );
end entity;

architecture rtl of UART_tx is
    signal shift_reg  : std_logic_vector(rs232databits downto 0);  -- Start + Data
    signal bit_cnt    : integer range 0 to rs232databits := 0;
    signal tx_active  : std_logic := '0';
    signal baud_clk   : std_logic;
begin

    -- Baud Clock Generator
    baud_gen: process(clk)
        variable counter : integer := 0;
    begin
        if rising_edge(clk) then
            if counter = 434 then  -- for 9600 baud with 50MHz clock
                counter := 0;
                baud_clk <= '1';
            else
                counter := counter + 1;
                baud_clk <= '0';
            end if;
        end if;
    end process;

    -- Shift Register and Transmit Process
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                tx_active <= '0';
                bit_cnt <= 0;
                uarttxpin <= '1';
            elsif txstart = '1' and tx_active = '0' then
                shift_reg <= '0' & txdata; -- Start bit + data bits
                tx_active <= '1';
                bit_cnt <= 0;
            elsif baud_clk = '1' and tx_active = '1' then
                uarttxpin <= shift_reg(0);
                shift_reg <= '1' & shift_reg(shift_reg'high downto 1);  -- Shift right with stop bit
                bit_cnt <= bit_cnt + 1;
                if bit_cnt = rs232databits then
                    tx_active <= '0';
                end if;
            end if;
        end if;
    end process;

end rtl;
