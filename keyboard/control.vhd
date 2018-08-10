library ieee;

use ieee.std_logic_1164.all;

entity CONTROL is
  port (scan_readSSy : in std_logic;
        reset : in std_logic;
        clk : in std_logic;
        MC_LE, BC_LE, readSS,make_rst : out std_logic);

  end CONTROL;

  architecture impl of CONTROL is

      constant s0 : std_logic_vector(2 downto 0) := "000";
      constant s1 : std_logic_vector(2 downto 0) := "001";
      constant s2 : std_logic_vector(2 downto 0) := "010";
      constant s3 : std_logic_vector(2 downto 0) := "011";
      constant s4 : std_logic_vector(2 downto 0) := "100";
      constant s5 : std_logic_vector(2 downto 0) := "101";
      constant s6 : std_logic_vector(2 downto 0) := "110";
      constant s7 : std_logic_vector(2 downto 0) := "111";
      
      signal current_state, next_state, nextD : std_logic_vector(2 downto 0);
	
	component DFFF is
        generic (n : integer :=1);
    port(clk : in std_logic;
        D : in std_logic_vector(n-1 downto 0);
        Q, Q_n : out std_logic_vector (n-1 downto 0));
        end component;
      
    begin
		D1 : DFFF generic map (3) port map(D => nextD, clk => clk, Q => current_state, Q_n => open);

      process(all) begin
        case current_state is
          when s0 =>
          if scan_readSSy = '0' then next_state <= s0;
        else
           next_state <= s1;
          end if;
          when s1 => next_state <= s2;
          when s2 =>
          if scan_readSSy = '1' then next_state <= s2;
        else
           next_state <= s3;
          end if;
          when s3 =>
          if scan_readSSy = '0' then next_state <= s3;
        else
           next_state <= s4;
          end if;
          when s4 =>
          if scan_readSSy = '1' then next_state <= s4;
        else
           next_state <= s5;
          end if;
          when s5 =>
          if scan_readSSy = '0' then next_state <= s5;
        else
           next_state <= s6;
          end if ;
          when s6 =>
          next_state <= s7;
          when s7 =>
          if scan_readSSy = '0' then next_state <= s0;
        else
           next_state <= s7;
          end if;
          when others => next_state <= s0;
        end case;
      end process;
      nextD <= s0 when reset = '0' else next_state;

      process(all) begin
        if (current_state = s0 and scan_readSSy = '1') then MC_LE <= '1';
      else
        MC_LE <= '0';
        end if;
		
		--if (current_state = s1) then make_rst <= '0';
      --else
		--make_rst <= '1';
		--end if;
		
        if (current_state = s5 and scan_readSSy = '1') then BC_LE <= '1';
      else
        BC_LE <= '0';
        end if;

        if (current_state = s1 or current_state = s4 or current_state = s6) then readSS <= '1';
      else
        readSS <= '0';
        end if;
      end process;
    end impl;
