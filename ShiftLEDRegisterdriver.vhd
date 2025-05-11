library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity led_shift_register_switch is
    Port (
        clk     : in  STD_LOGIC;                     
        reset   : in  STD_LOGIC;                     
        shift_sw: in  STD_LOGIC;                      
        led_out : out STD_LOGIC_VECTOR(3 downto 0)    
    );
end led_shift_register_switch;

architecture Behavioral of led_shift_register_switch is
    signal shift_reg : STD_LOGIC_VECTOR(3 downto 0) := "0001";
    signal shift_sw_prev : STD_LOGIC := '0';
begin

    process(clk, reset)
    begin
        if reset = '1' then
            shift_reg <= "0001";
            shift_sw_prev <= '0';
        elsif rising_edge(clk) then
            if shift_sw = '1' and shift_sw_prev = '0' then
                shift_reg <= shift_reg(2 downto 0) & shift_reg(3);  
            end if;
            shift_sw_prev <= shift_sw;
        end if;
    end process;

    led_out <= shift_reg;

end Behavioral;
