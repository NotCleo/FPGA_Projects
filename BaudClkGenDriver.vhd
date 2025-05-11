library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BaudClkGenerator is
    generic (
        BIT_PERIOD        : integer := 434;     
        NUMBER_OF_CLOCKS  : integer := 10       
    );
    port (
        Clk      : in std_logic;
        Rst      : in std_logic;
        Start    : in std_logic;
        BaudClk  : out std_logic;
        Ready    : out std_logic
    );
end entity;

architecture rtl of BaudClkGenerator is
    signal ClocksLeft        : integer := 0;
    signal BitPeriodCounter  : integer := 0;
    signal BaudClk_int       : std_logic := '0';
    signal Start_latched     : std_logic := '0';
begin

    BaudClk <= BaudClk_int;


    StartProcess : process(Clk, Rst)
    begin
        if Rst = '1' then
            ClocksLeft <= 0;
            Start_latched <= '0';
        elsif rising_edge(Clk) then
            if Start = '1' then
                ClocksLeft <= NUMBER_OF_CLOCKS;
                Start_latched <= '1';
            elsif BaudClk_int = '1' and ClocksLeft > 0 then
                ClocksLeft <= ClocksLeft - 1;
            end if;
        end if;
    end process;


    BaudClockProcess : process(Clk, Rst)
    begin
        if Rst = '1' then
            BitPeriodCounter <= 0;
            BaudClk_int <= '0';
        elsif rising_edge(Clk) then
            if ClocksLeft > 0 then
                if BitPeriodCounter = BIT_PERIOD then
                    BaudClk_int <= '1';
                    BitPeriodCounter <= 0;
                else
                    BaudClk_int <= '0';
                    BitPeriodCounter <= BitPeriodCounter + 1;
                end if;
            else
                BaudClk_int <= '0';
                BitPeriodCounter <= 0;
            end if;
        end if;
    end process;

    ReadyProcess : process(Clk, Rst)
    begin
        if Rst = '1' then
            Ready <= '1';
        elsif rising_edge(Clk) then
            if Start = '1' then
                Ready <= '0';
            elsif ClocksLeft = 0 and Start_latched = '1' then
                Ready <= '1';
                Start_latched <= '0';
            end if;
        end if;
    end process;

end rtl;
