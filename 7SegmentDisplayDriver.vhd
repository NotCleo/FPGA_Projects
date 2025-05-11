library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;  

entity sevensegmentdisplay is
    port (
        rst  : in std_logic;
        clk  : in std_logic;
        sw1  : in std_logic;
        k    : out std_logic_vector(6 downto 0);
        Dp   : out std_logic;
        A    : out std_logic_vector(3 downto 0)
    );
end entity;

architecture rtl of sevensegmentdisplay is
    signal Sync              : std_logic_vector(1 downto 0);
    signal SW1_Synced        : std_logic;
    signal SW1_Debounced     : std_logic;
    signal SW1_Debounced_delay : std_logic;
    signal FallingEdgeOnSW1  : std_logic;

    signal DeBounceCount     : integer := 0;
    constant DeBouncePeriod  : integer := 2500000;

    type StateMachineType is (DIGIT_1, DIGIT_2, DIGIT_3, DIGIT_4);
    signal SMState           : StateMachineType;

    signal Digit1, Digit2, Digit3, Digit4 : integer range 0 to 9 := 0;

    signal NumberToDisplay   : integer range 0 to 9 := 0;
    signal k_Int             : std_logic_vector(6 downto 0);

begin
    SW1_Synced <= Sync(1);

    SynchroniseSW1: process(rst, clk)
    begin
        if rst = '0' then
            Sync <= "11";
        elsif rising_edge(clk) then
            Sync(0) <= sw1;
            Sync(1) <= Sync(0);
        end if;
    end process;

    DeBounceProcess: process(rst, clk)
    begin
        if rst = '0' then
            DeBounceCount <= 0;
            SW1_Debounced <= '1';
        elsif rising_edge(clk) then
            if SW1_Synced = '0' then
                if DeBounceCount < DeBouncePeriod then
                    DeBounceCount <= DeBounceCount + 1;
                end if;
            else
                if DeBounceCount > 0 then
                    DeBounceCount <= DeBounceCount - 1;
                end if;
            end if;

            if DeBounceCount = DeBouncePeriod then
                SW1_Debounced <= '0';
            elsif DeBounceCount = 0 then
                SW1_Debounced <= '1';
            end if;
        end if;
    end process;

    Count: process(rst, clk)
    begin
        if rst = '0' then
            SW1_Debounced_delay <= '1';
            FallingEdgeOnSW1 <= '0';
        elsif rising_edge(clk) then
            SW1_Debounced_delay <= SW1_Debounced;
            if SW1_Debounced = '0' and SW1_Debounced_delay = '1' then
                FallingEdgeOnSW1 <= '1';
            else
                FallingEdgeOnSW1 <= '0';
            end if;
        end if;
    end process;

    CountButtonPresses: process(rst, clk)
    begin
        if rst = '0' then
            Digit1 <= 0;
            Digit2 <= 0;
            Digit3 <= 0;
            Digit4 <= 0;
        elsif rising_edge(clk) then
            if FallingEdgeOnSW1 = '1' then
                if Digit1 < 9 then
                    Digit1 <= Digit1 + 1;
                else
                    Digit1 <= 0;
                    if Digit2 < 9 then
                        Digit2 <= Digit2 + 1;
                    else
                        Digit2 <= 0;
                        if Digit3 < 9 then
                            Digit3 <= Digit3 + 1;
                        else
                            Digit3 <= 0;
                            if Digit4 < 9 then
                                Digit4 <= Digit4 + 1;
                            else
                                Digit4 <= 0;  
                            end if;
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;

    Decoder: process(rst, clk)
    begin
        if rst = '0' then
            k_Int <= "0000000";
        elsif rising_edge(clk) then
            case NumberToDisplay is
                when 0 => k_Int <= "0111111"; -- a b c d e f
                when 1 => k_Int <= "0000110"; -- b c
                when 2 => k_Int <= "1011011"; -- a b d e g
                when 3 => k_Int <= "1001111"; -- a b c d g
                when 4 => k_Int <= "1100110"; -- b c f g
                when 5 => k_Int <= "1101101"; -- a c d f g
                when 6 => k_Int <= "1111101"; -- a c d e f g
                when 7 => k_Int <= "0000111"; -- a b c
                when 8 => k_Int <= "1111111"; -- all
                when 9 => k_Int <= "1101111"; -- a b c d f g
                when others => k_Int <= "0000000";
            end case;
        end if;
    end process;

    StateMachineProcess: process(rst, clk)
    begin
        if rst = '0' then
            SMState <= DIGIT_1;
            A <= "1111";
            NumberToDisplay <= 0;
        elsif rising_edge(clk) then
            case SMState is
                when DIGIT_1 =>
                    A <= "1110";
                    NumberToDisplay <= Digit1;
                    SMState <= DIGIT_2;
                when DIGIT_2 =>
                    A <= "1101";
                    NumberToDisplay <= Digit2;
                    SMState <= DIGIT_3;
                when DIGIT_3 =>
                    A <= "1011";
                    NumberToDisplay <= Digit3;
                    SMState <= DIGIT_4;
                when DIGIT_4 =>
                    A <= "0111";
                    NumberToDisplay <= Digit4;
                    SMState <= DIGIT_1;
            end case;
        end if;
    end process;

    k <= k_Int;
    Dp <= '1';  

end rtl;
