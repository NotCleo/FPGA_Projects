library ieee;
use ieee.std_logic_1164.all;

entity TopLevelModule is
    port (
        clk         : in std_logic;
        rst         : in std_logic;
        rs232_rx    : in std_logic;
        rs232_tx    : out std_logic
    );
end entity;

architecture rtl of TopLevelModule is
    signal rxdata    : std_logic_vector(7 downto 0);
    signal rxready   : std_logic;
    signal txstart   : std_logic;
    signal txdata    : std_logic_vector(7 downto 0);

    component UART_tx is
        generic (rs232databits : integer := 8);
        port (
            clk, rst    : in std_logic;
            txstart     : in std_logic;
            txdata      : in std_logic_vector(7 downto 0);
            uarttxpin   : out std_logic
        );
    end component;

    component UART_rx is
        generic (rs232databits : integer := 8);
        port (
            clk, rst    : in std_logic;
            uartrxpin   : in std_logic;
            rxdata      : out std_logic_vector(7 downto 0);
            rxready     : out std_logic
        );
    end component;

    type state_type is (idle, wait_tx);
    signal state : state_type := idle;

begin

    u_tx: UART_tx
        port map (
            clk => clk,
            rst => rst,
            txstart => txstart,
            txdata => txdata,
            uarttxpin => rs232_tx
        );

    u_rx: UART_rx
        port map (
            clk => clk,
            rst => rst,
            uartrxpin => rs232_rx,
            rxdata => rxdata,
            rxready => rxready
        );

    -- FSM for echo
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state <= idle;
                txstart <= '0';
            else
                case state is
                    when idle =>
                        if rxready = '1' then
                            txdata <= rxdata;
                            txstart <= '1';
                            state <= wait_tx;
                        end if;
                    when wait_tx =>
                        txstart <= '0';
                        if rxready = '0' then
                            state <= idle;
                        end if;
                end case;
            end if;
        end if;
    end process;

end rtl;
