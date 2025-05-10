library ieee;
use ieee.std_logic_1164.all;

entity pwm_led is
    port (
        clk      : in  std_logic;
        pwm_out  : out std_logic
    );
end entity pwm_led;

architecture rtl of pwm_led is

signal counter : integer range 0 to 50000001;

begin 
	pwmprocess:process(clk)
	begin 
		if rising_edge(clk) then
			counter <= counter + 1;
			
			if counter > 49999999 then
				counter <= 0;
			else 
				counter <= counter + 1;
			end if;
			if counter > 25000000 then
				pwm_out <= '1';
			else 
				pwm_out <= '0';
			end if;
		end if;
	end process;
end rtl;
