library ieee;
use ieee.std_logic_1164.all;

entity switchdrivesled is
port
(
	sw1 : in std_logic;
	led1 : out std_logic
);
end entity;

architecture rtl of switchdrivesled is
begin
	led1 <= sw1;
end rtl;
