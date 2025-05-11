library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity led_shift_register_debounced is
    Port (
        clk       : in  STD_LOGIC;                       
        reset     : in  STD_LOGIC;                    
        shift_sw  : in  STD_LOGIC;                       
        led_out   : out STD_LOGIC_VECTOR(3 downto 0)     
    );
end led_shift_register_debounced;

architecture Behavioral of led_shift_register_debounced is

    constant DEBOUNCE_TIME : integer := 250000;   --cause 50ms is enough time for the mechswitch

    signal shift_reg       : STD_LOGIC_VECTOR(3 downto 0) := "0001";
    signal shift_sw_sync   : STD_LOGIC := '0';
    signal shift_sw_prev   : STD_LOGIC := '0';
    signal counter         : integer range 0 to DEBOUNCE_TIME := 0;
    signal debounced_sw    : STD_LOGIC := '0';

begin

    process(clk, reset)
    begin
        if reset = '1' then
            counter       <= 0;
            shift_sw_sync <= '0';
            debounced_sw  <= '0';
        elsif rising_edge(clk) then
            if shift_sw = shift_sw_sync then
                if counter < DEBOUNCE_TIME then
                    counter <= counter + 1;
                else
                    debounced_sw <= shift_sw_sync;
                end if;
            else
                counter <= 0;
                shift_sw_sync <= shift_sw;
            end if;
        end if;
    end process;

    process(clk, reset)
    begin
        if reset = '1' then
            shift_reg     <= "0001";
            shift_sw_prev <= '0';
        elsif rising_edge(clk) then
            if debounced_sw = '1' and shift_sw_prev = '0' then
                shift_reg <= shift_reg(2 downto 0) & shift_reg(3); 
            end if;
            shift_sw_prev <= debounced_sw;
        end if;
    end process;

    led_out <= shift_reg;

end Behavioral;
