LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY large_char IS
	PORT
	(
		pix_row, pix_col	: IN	STD_LOGIC_VECTOR(9 DOWNTO 0);
		char_add			: OUT	STD_LOGIC_VECTOR(5 DOWNTO 0);
		fr, fc				: OUT	STD_LOGIC_VECTOR(2 DOWNTO 0)
	);
END large_char;

ARCHITECTURE logic OF large_char IS
BEGIN
	-- Process Statements
gen_logic:
PROCESS(pix_row, pix_col)
	VARIABLE pc : STD_LOGIC_VECTOR(9 DOWNTO 0);
	VARIABLE pr : STD_LOGIC_VECTOR(9 DOWNTO 0);
BEGIN

-- Generate the address of the character in the RAM
IF (pix_col < 240) THEN
	char_add <= "010011"; -- S
ELSIF (pix_col > 399) THEN
	char_add <= "000011"; -- C
ELSE
	char_add <= "100000"; -- Space
END IF;

-- Want the font column to change every 30 in the range 0-240 and 480-640
IF (pix_col > 399) THEN
	pc := pix_col - 400;
ELSE
	pc := pix_col;
END IF;
	 
-- Change the font column every 30
IF (pc < 30) THEN
	fc <= "000";
ELSIF (pc >= 30) AND (pc < 60) THEN
	fc <= "001";
ELSIF (pc >= 60) AND (pc < 90) THEN
	fc <= "010";
ELSIF (pc >= 90) AND (pc < 120) THEN
	fc <= "011";
ELSIF (pc >= 120) AND (pc < 150) THEN
	fc <= "100";
ELSIF (pc >= 150) AND (pc < 180) THEN
	fc <= "101";
ELSIF (pc >= 180) AND (pc < 210) THEN
	fc <= "110";
ELSIF (pc >= 210) AND (pc < 240) THEN
	fc <= "111";
ELSE 
	fc <= "000";		
END IF;

pr := pix_row;  -- for convenience

-- Change the font row every 60
IF (pr < 60) THEN
	fr <= "000";
ELSIF (pr >= 60) AND (pr < 120) THEN
	fr <= "001";
ELSIF (pr >= 120) AND (pr < 180) THEN
	fr <= "010";
ELSIF (pr >= 180) AND (pr < 240) THEN
	fr <= "011";
ELSIF (pr >= 240) AND (pr < 300) THEN
	fr <= "100";
ELSIF (pr >= 300) AND (pr < 360) THEN
	fr <= "101";
ELSIF (pr >= 360) AND (pr < 420) THEN
	fr <= "110";
ELSIF (pr >= 420) AND (pr < 480) THEN
	fr <= "111";
ELSE 
	fr <= "000";		
END IF;


END PROCESS gen_logic;

END logic;
