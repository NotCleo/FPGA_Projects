library ieee;
use ieee.STD_LOGIC_1164.ALL;
use ieee.NUMERIC_STD.ALL;

entity spectro_mem is
    generic (
        IMAGE_SIZE : integer := 256*256
    );
    port (
        clk          : in  std_logic;
        rst          : in  std_logic;
        wr_en        : in  std_logic;
        data_in      : in  std_logic_vector(7 downto 0);
        rd_en        : in  std_logic;
        rd_addr      : in  std_logic_vector(15 downto 0);
        data_out     : out std_logic_vector(7 downto 0);
        image_ready  : out std_logic
    );
end spectro_mem;

architecture Behavioral of spectro_mem is
    type mem_type is array (0 to IMAGE_SIZE-1) of std_logic_vector(7 downto 0);
    signal mem        : mem_type := (others => (others => '0'));
    signal wr_addr    : integer range 0 to IMAGE_SIZE-1 := 0;
    signal image_done : std_logic := '0';
begin
    process(clk, rst)
    begin
        if rst = '1' then
            wr_addr <= 0;
            image_done <= '0';
        elsif rising_edge(clk) then
            if wr_en = '1' and wr_addr < IMAGE_SIZE then
                mem(wr_addr) <= data_in;
                wr_addr <= wr_addr + 1;
                if wr_addr = IMAGE_SIZE-1 then
                    image_done <= '1';
                end if;
            end if;
            if rd_en = '1' then
                data_out <= mem(to_integer(unsigned(rd_addr)));
            end if;
            if image_done = '1' and wr_en = '0' then
                image_done <= '0';  --reset for next image
            end if;
            image_ready <= image_done;
        end if;
    end process;
end Behavioral;
