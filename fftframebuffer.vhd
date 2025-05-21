library ieee;
use ieee.STD_LOGIC_1164.ALL;
use ieee.NUMERIC_STD.ALL;

entity frame_buffer is
    generic (
        FRAME_SIZE : integer := 512  --samples per FFT frame
    );
    port (
        clk          : in  std_logic;
        rst          : in  std_logic;
        wr_en        : in  std_logic;
        data_in      : in  std_logic_vector(15 downto 0);
        rd_addr      : in  integer range 0 to FRAME_SIZE-1;
        data_out     : out std_logic_vector(15 downto 0);
        full         : out std_logic
    );
end frame_buffer;

architecture Behavioral of frame_buffer is
    type mem_type is array (0 to FRAME_SIZE-1) of std_logic_vector(15 downto 0);
    signal mem    : mem_type := (others => (others => '0'));
    signal wr_ptr : integer range 0 to FRAME_SIZE-1 := 0;
begin
    process(clk, rst)
    begin
        if rst = '1' then
            wr_ptr <= 0;
            full <= '0';
        elsif rising_edge(clk) then
            if wr_en = '1' then
                mem(wr_ptr) <= data_in;
                wr_ptr <= wr_ptr + 1;
                if wr_ptr = FRAME_SIZE-1 then
                    full <= '1';
                end if;
            end if;
            if full = '1' and wr_en = '0' then
                full <= '0';  --reset when read starts
            end if;
            data_out <= mem(rd_addr);
        end if;
    end process;
end Behavioral;
