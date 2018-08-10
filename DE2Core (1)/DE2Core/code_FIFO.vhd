LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;

-- Hexadecimal to 7 Segment Decoder for LED Display

ENTITY code_FIFO IS
	
	PORT(scan_code				: IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
		 Hex_display_data		: OUT	STD_LOGIC_VECTOR(39 DOWNTO 0);
		 scan_ready, clock_48Mhz, reset	: IN std_logic; 
		 read 					: OUT std_logic);

END code_FIFO;

ARCHITECTURE a OF code_FIFO IS
TYPE STATE_TYPE IS (wait_ready, read_data, read_low);
SIGNAL state: STATE_TYPE;
SIGNAL  Hex_display_data_int		:STD_LOGIC_VECTOR(39 DOWNTO 0);
SIGNAL clock_enable :Std_logic;
BEGIN
Hex_Display_Data <= Hex_Display_Data_int;
  PROCESS (scan_ready, reset, clock_48Mhz, clock_enable)
	BEGIN
	IF reset <= '0' THEN state <= read_low;
	Hex_Display_Data_int <= X"0000000000";
	ELSIF (clock_48Mhz'EVENT) AND clock_48Mhz='1' THEN
	CASE state IS 
	WHEN read_low =>
		read <= '0';
		state <= wait_ready;
	WHEN wait_ready =>
		IF scan_ready = '1' THEN
			read <= '1';
			state <= read_data;
		ELSE
		    state <= wait_ready;
		END IF;
	WHEN read_data =>
			Hex_display_data_int <= Hex_display_data_int(31 DOWNTO 0) & Scan_Code;
			state <= read_low;
	END CASE;
   END IF;
  END PROCESS;  
END a;
