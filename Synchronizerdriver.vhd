library ieee;
use ieee.std_logic_1164.all;

entity synchronizer is
    port (
        async_signal   : in  std_logic;    -- input from another clock domain
        clk            : in  std_logic;    -- destination clock domain
        sync_signal    : out std_logic     -- synchronised output
    );
end entity;

architecture rtl of synchronizer is
    signal sync_ff1, sync_ff2 : std_logic := '0';
begin

    process(clk)
    begin
        if rising_edge(clk) then
            sync_ff1 <= async_signal;
            sync_ff2 <= sync_ff1;
        end if;
    end process;

    sync_signal <= sync_ff2;

end rtl;
