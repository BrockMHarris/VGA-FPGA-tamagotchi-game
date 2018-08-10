library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
	generic (N : integer := 14);
	port(D, in_clk : in std_logic;
		address : buffer std_logic_vector(10 downto 0);
		out_clk, Q: out std_logic);
end counter;

architecture proj of counter is
	signal temp_address: integer := 0;
	signal counter : integer := 0;
	signal hold_value : std_logic;
begin
	process(in_clk, D, address) begin
		if(rising_edge(in_clk)) then
			if(counter mod N = 0) then
				out_clk <= '1';
				hold_value <= D;
				Q <= hold_value;
			else
				out_clk <= '0';
				Q <= hold_value;
			end if;
			counter <= counter+1;
			address <= std_logic_vector(to_unsigned(temp_address + 1, 11));
			temp_address <= temp_address+1;
		end if;
	end process;
end proj;