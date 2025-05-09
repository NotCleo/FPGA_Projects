library ieee;
use ieee.std_logic_1164.all;

entity statemachinedriver is
    port (
        clk : in std_logic;
        led : out std_logic_vector(2 downto 0);
        sw  : in std_logic_vector(2 downto 0)
    );
end entity;

architecture rtl of statemachinedriver is

    type datatypesm is (state1, state2, state3);
    signal statevariable : datatypesm := state1;

begin

    process1: process(clk)
    begin
        if rising_edge(clk) then
            case statevariable is
                when state1 =>
                    led <= "110";
                    if sw(0) = '0' then
                        statevariable <= state2;
                    end if;

                when state2 =>
                    led <= "101";
                    if sw(1) = '0' then
                        statevariable <= state3;
                    end if;

                when state3 =>
                    led <= "010";
                    if sw(2) = '0' then
                        statevariable <= state1;
                    end if;

                when others =>
                    statevariable <= state1;
            end case;
        end if;
    end process;

end rtl;
