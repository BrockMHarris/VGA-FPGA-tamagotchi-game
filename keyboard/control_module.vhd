library ieee;
use ieee.std_logic_1164.all;

entity control_module is
	port(clk, reset, scan_ready: in std_logic;
		MC_LE, BC_LE, read1: out std_logic);
end control_module;

architecture impl of control_module is

component dflop is
        generic (k : integer := 8);
        port( clk : in std_logic;
              D   : in std_logic_vector(k-1 downto 0);
              reset : in std_logic;
              Q, Q_n  : out std_logic_vector(k-1 downto 0));
end component;

	constant s0: std_logic_vector(2 downto 0) := "000";
	constant s1: std_logic_vector(2 downto 0) := "001";
	constant s2: std_logic_vector(2 downto 0) := "010";
	constant s3: std_logic_vector(2 downto 0) := "011";
	constant s4: std_logic_vector(2 downto 0) := "100";
	constant s5: std_logic_vector(2 downto 0) := "101";
	constant s6: std_logic_vector(2 downto 0) := "110";
	constant s7: std_logic_vector(2 downto 0) := "111";
	signal state, nextS, nextD: std_logic_vector(2 downto 0);
begin
	sreg: dflop generic map(3) port map(clk, nextD, reset, state, open);
	process(state, scan_ready) begin
	case state is
		when s0 => if scan_ready = '0' then nextS <= s0; else nextS <= s1; end if;
		when s1 => nextS <= s2;
		when s2 => if scan_ready = '0' then nextS <= s3; else nextS <= s2; end if;
		when s3 => if scan_ready = '0' then nextS <= s3; else nextS <= s4; end if;
		when s4 => if scan_ready = '0' then nextS <= s5; else nextS <= s4; end if;
		when s5 => if scan_ready = '0' then nextS <= s5; else nextS <= s6; end if;
		when s6 => nextS <= s7;
		when s7 => if scan_ready = '0' then nextS <= s0; else nextS <= s7; end if;
	end case;
	end process;
	
	process(state, scan_ready) begin
	case state is
		when s0 => if scan_ready = '1' then MC_LE <= '1'; else MC_LE <= '0'; end if;
		when s5 => if scan_ready = '1' then BC_LE <= '1'; else BC_LE <= '0'; end if;
		when others => MC_LE <= '0'; BC_LE <= '0';
	end case;
	end process;
	
	process(state, scan_ready) begin
	case state is
		when s1 => read1 <= '1';
		when s4 => read1 <= '1';
		when s6 => read1 <= '1';
		when others => read1 <= '0';
	end case;
	end process;
	
	nextD <= s0 when reset = '0' else
			 nextS when reset = '1';
end impl;



	 


