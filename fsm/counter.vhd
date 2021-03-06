--Asynchrony counter
--Last modify: May 28th 14:09

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;



entity counter is
  generic(n : integer := 4);
  port(clk, enable, rst : in std_logic;
	  tenS : out std_logic;
      Q : buffer std_logic_vector(n-1 downto 0));


    end counter;

architecture impl of counter is

	--signal Q_value : std_logic_vector(n-1 downto 0) := (others => '0');
  begin

    process(clk)
    begin
      if rising_edge(clk) then
		if rst = '1' then
        Q <= (n-1 downto 0 => '0');
        elsif enable = '1' then
			Q <= Q + 1;
        else
			Q <= Q;
		end if;
      else
		Q <= Q;
      end if;
    end process;



    process(all)
    begin
      if(Q < "01101010") then
        tenS <= '0';
      else
        tenS <= '1';
      end if;
    end process;
  end impl;
