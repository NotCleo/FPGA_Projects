library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_rx_image_buffer is
    generic (
        CLK_FREQ   : integer := 50000000;
        BAUD_RATE  : integer := 115200;
        IMAGE_SIZE : integer := 256*256
    );
    port (
        clk          : in  std_logic;
        rst          : in  std_logic;
        rx_serial    : in  std_logic;
        image_buffer_addr : out std_logic_vector(15 downto 0); -- 64k address space
        image_buffer_data : out std_logic_vector(7 downto 0);
        image_buffer_we   : out std_logic; -- write enable
        image_ready       : out std_logic
    );
end uart_rx_image_buffer;

architecture Behavioral of uart_rx_image_buffer is

    -- UART RX parameters
    constant CLKS_PER_BIT : integer := CLK_FREQ / BAUD_RATE;

    -- UART RX signals
    signal clk_count     : integer range 0 to CLKS_PER_BIT := 0;
    signal bit_index     : integer range 0 to 9 := 0;  -- start+8data+stop
    signal rx_shift_reg  : std_logic_vector(7 downto 0) := (others => '0');
    signal receiving     : std_logic := '0';
    signal rx_ready_int  : std_logic := '0';

    -- Image buffer address counter
    signal write_addr    : integer range 0 to IMAGE_SIZE-1 := 0;

    -- Output signals registers
    signal image_ready_reg : std_logic := '0';

begin

    process(clk, rst)
    begin
        if rst = '1' then
            clk_count <= 0;
            bit_index <= 0;
            receiving <= '0';
            rx_ready_int <= '0';
            write_addr <= 0;
            image_ready_reg <= '0';
        elsif rising_edge(clk) then
            rx_ready_int <= '0';

            if receiving = '0' then
                -- Wait for start bit (falling edge)
                if rx_serial = '0' then
                    receiving <= '1';
                    clk_count <= CLKS_PER_BIT / 2; -- sample middle of start bit
                    bit_index <= 0;
                end if;

            else -- receiving = '1'
                if clk_count = CLKS_PER_BIT - 1 then
                    clk_count <= 0;
                    bit_index <= bit_index + 1;

                    case bit_index is
                        when 0 =>  -- start bit
                            if rx_serial = '1' then
                                receiving <= '0'; -- false start
                            end if;

                        when 1 to 8 =>  -- data bits
                            rx_shift_reg(bit_index - 1) <= rx_serial;

                        when 9 =>  -- stop bit
                            if rx_serial = '1' then
                                rx_ready_int <= '1';
                                -- Store the received byte into the buffer address
                                if write_addr < IMAGE_SIZE then
                                    write_addr <= write_addr + 1;
                                end if;
                            end if;
                            receiving <= '0';

                        when others =>
                            receiving <= '0';
                    end case;
                else
                    clk_count <= clk_count + 1;
                end if;
            end if;

            -- Signal image ready when full image received
            if write_addr = IMAGE_SIZE then
                image_ready_reg <= '1';
            end if;
        end if;
    end process;

    -- Output assignments
    image_buffer_addr <= std_logic_vector(to_unsigned(write_addr - (rx_ready_int and (write_addr > 0) ? 1 : 0), 16));
    image_buffer_data <= rx_shift_reg;
    image_buffer_we   <= rx_ready_int;
    image_ready       <= image_ready_reg;

end Behavioral;


