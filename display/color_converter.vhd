library ieee;
use ieee.std_logic_1164.all;

entity color_converter is
	port(D : in std_logic;
		r,g,b : out std_logic);
end color_converter;

architecture proj of color_converter is
begin
r <= '0' when D = '0' else '1';
g <= '0' when D = '0' else '1';
b <= '0' when D = '0' else '1';
end proj;