library ieee;
use ieee.std_logic_1164.all;

entity REG8 is
	port(clk, LE, MR : in std_logic;
		D : in std_logic_vector(7 downto 0);
		Q, Q_n : out std_logic_vector(7 downto 0));
end REG8;

architecture lab4 of REG8 is
begin
process(clk) begin
	if MR = '0' then
		Q <= "00000000";
		Q_n <= "11111111";
	elsif rising_edge(clk) then
		if LE = '1' then
			Q <= D;
			Q_n <= not D;
		end if;
	end if;
end process;
end lab4;
	