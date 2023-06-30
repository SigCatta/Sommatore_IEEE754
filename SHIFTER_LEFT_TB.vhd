library ieee;
use ieee.std_logic_1164.ALL;

entity SHIFTER_LEFT_TB is
end SHIFTER_LEFT_TB;

architecture behavior of SHIFTER_LEFT_TB is

	component SHIFTER_LEFT
		port(
			X : in  std_logic_vector(23 downto 0);
			S : in  std_logic_vector(7 downto 0);
			Y : out std_logic_vector(22 downto 0)
		);
	end component;

	--Inputs
	signal X : std_logic_vector(23 downto 0);
	signal S : std_logic_vector(7 downto 0);

	--Outputs
	signal Y : std_logic_vector(22 downto 0);

	begin
	
	uut: SHIFTER_LEFT
	port map(
		X => X,
		S => S,
		Y => Y
	);

process
	begin
		X <= "000000000000000000000000";
		S  <= "00000000";

	wait for 100 ns;
		
		X <= "010101010101010101010101"; 
		S <= "00011000";
		-- output should be 00000000000000000000000

	wait for 20 ns;

		X <= "110010011010110111000010"; 
		S <= "00000010";
		-- output should be 01001101011011100001000
	wait;
	end process;
	
end;
