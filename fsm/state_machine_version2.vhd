--last modify: may 28th 14:36
library ieee;
use ieee.std_logic_1164.all;


--will take a std_logic input for 5s count and a std_logic input for 10s count
--need to work out how to get the counter get these two output
-- output will be the state number in binary code
entity state_machine_version2 is
  port (f_key, key, clk, tenS : in std_logic;
        current_state : buffer std_logic_vector(2 downto 0);
        enable_out: buffer std_logic;
        rst_out : out std_logic);
end state_machine_version2;

architecture impl of state_machine_version2 is
  component vDFF is
    generic(n : integer := 8);
    port (clk : in std_logic;
          d: in std_logic_vector(n-1 downto 0 );
          q: out std_logic_vector(n-1 downto 0));
        end component;

        constant rst : std_logic_vector(2 downto 0) := "000"; --reset state, initial state, press key[0] on DE2 board will go from dead state to rst
        constant f1 : std_logic_vector(2 downto 0) := "001";  --feed one state, when "f" pressed within 10 s after rst state or after 10s in f2 state
        constant f2 : std_logic_vector(2 downto 0) := "010";  --feed two state, when "f" pressed within 5 s after f1, or after 10s in f3 state
        constant f3 : std_logic_vector(2 downto 0) := "011";  --feed three state, when "f" pressed within 5 s after f2
        constant dead : std_logic_vector(2 downto 0) := "100";  --dead state, when "f" pressed within 5s after f3, or 10s after rst state

        signal next_state : std_logic_vector(2 downto 0);
        signal f_key_d, tenS_d : std_logic := '0'; 
		signal f_key_re, tenS_re : std_logic;

        begin
          reg : vDFF generic map (3) port map (d => next_state, clk => clk, q => current_state);

          -- process for next_state and  enable_out
          --
		f_key_d <= f_key when rising_edge(clk); 
		f_key_re <= not f_key_d and f_key;

          process(all)
          begin
          if key = '1' then 
			next_state <= rst;
			enable_out <= '1';
          else
            case current_state is
              when rst =>
              if (tenS = '0') and (f_key_re = '1') then
                next_state <= f1;
                enable_out <= '0';
              elsif tenS = '1' then
                next_state <= dead;
                enable_out <= '0';
              else
                next_state <= rst;
                enable_out <= '1';
              end if;

              when f1 =>
              if (tenS = '0') and (f_key_re = '1') then
                next_state <= f2;
                enable_out <= '0';
              elsif tenS = '1' then
                next_state <= rst;
                enable_out <= '0';
              else
                next_state <= f1;
                enable_out <= '1';
              end if;

              when f2 =>
              if (tenS = '0') and (f_key_re = '1') then
                next_state <= f3;
                enable_out <= '0';
              elsif tenS = '1' then
                next_state <= f1;
                enable_out <= '0';
              else
                next_state <= f2;
                enable_out <= '1';
              end if;

              when f3 =>
              if (tenS = '0') and (f_key_re = '1') then
                next_state <= dead;
                enable_out <= '0';
              elsif tenS = '1' then
                next_state <= f2;
                enable_out <= '0';
              else
                next_state <= f3;
                enable_out <= '1';
              end if;

              when others =>
              if key = '1' then
                next_state <= rst;
                enable_out <= '0';
              else
                next_state <= dead;
                enable_out <= '0';
              end if;
            end case;
            end if;
          end process;
	rst_out <= not enable_out;

          -- process for reset
          -- when < 5s and f => rst
          -- when 10s  => rst


--          process (all)
--          begin
--			if (tenS = '0') and (f_key_re = '1') then
--                     rst_out <= '1';
--                 elsif tenS = '1' then
--                     rst_out <= '1';
--                 else
--                     rst_out <= '0';
--                 end if;
--           end process;
       end impl;
