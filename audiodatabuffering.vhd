library ieee;
use ieee.STD_LOGIC_1164.ALL;
use ieee.NUMERIC_STD.ALL;

entity audio_buffer is
    generic (
        BUFFER_DEPTH : integer := 1024  
    );
    port (
        clk          : in  std_logic;
        rst          : in  std_logic;
        wr_en        : in  std_logic;
        rd_en        : in  std_logic;
        data_in      : in  std_logic_vector(15 downto 0);  -- 16-bit sample
        data_out     : out std_logic_vector(15 downto 0);
        full         : out std_logic;
        empty        : out std_logic
    );
end audio_buffer;

architecture Behavioral of audio_buffer is
    type mem_type is array (0 to BUFFER_DEPTH-1) of std_logic_vector(15 downto 0);
    signal mem        : mem_type := (others => (others => '0'));
    signal wr_ptr     : integer range 0 to BUFFER_DEPTH-1 := 0;
    signal rd_ptr     : integer range 0 to BUFFER_DEPTH-1 := 0;
    signal count      : integer range 0 to BUFFER_DEPTH := 0;
begin
    process(clk, rst)
    begin
        if rst = '1' then
            wr_ptr <= 0;
            rd_ptr <= 0;
            count <= 0;
            full <= '0';
            empty <= '1';
        elsif rising_edge(clk) then
            if wr_en = '1' and count < BUFFER_DEPTH then
                mem(wr_ptr) <= data_in;
                wr_ptr <= (wr_ptr + 1) mod BUFFER_DEPTH;
                count <= count + 1;
            end if;
            if rd_en = '1' and count > 0 then
                data_out <= mem(rd_ptr);
                rd_ptr <= (rd_ptr + 1) mod BUFFER_DEPTH;
                count <= count - 1;
            end if;
            full <= '1' when count = BUFFER_DEPTH else '0';
            empty <= '1' when count = 0 else '0';
        end if;
    end process;
end Behavioral;
