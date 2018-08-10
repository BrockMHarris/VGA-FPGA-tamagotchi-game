library ieee;
use ieee.std_logic_1164.all;

entity compare is
	port(make_code, break_code: in std_logic_vector(7 downto 0);
		error : out std_logic);
end compare;

architecture lab of compare is
begin
process(make_code, break_code) begin
	if make_code /= break_code then
		error <= '1';
	else error <= '0';
	end if;
end process;
end lab;