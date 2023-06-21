library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DENORMALIZED_SUM is
	port(
		X:		  in	 std_logic_vector(24 downto 0);
		Y:		  in	 std_logic_vector(24 downto 0);
		M:		  out  std_logic_vector(23 downto 0);
		SIGN:   out  std_logic
	);
end DENORMALIZED_SUM;

architecture Behavioral of DENORMALIZED_SUM is

	component RCA is
		generic(width: integer := 25);
		port(
			X    : in  std_logic_vector (width - 1 downto 0);
			Y    : in  std_logic_vector (width - 1 downto 0);
			CIN  : in  std_logic;
			S    : out std_logic_vector (width - 1 downto 0);
			COUT : out std_logic
		);
	end component;
	 
	component C2C is								-- calculates the result's 2's complement if necessary
		generic(width: integer := 24);
		port(
			N    : in  std_logic_vector (width - 1 downto 0);
			S    : in  std_logic;
			Z    : out std_logic_vector (width - 1 downto 0);
			COUT : out std_logic
		);
	end component;
	
	signal S: std_logic_vector(24 downto 0);

begin

	U1: RCA
		port map(
			X => X,
			Y => Y,
			CIN => '0',
			S => S
		);
	
	SIGN <= S(24);
	
	U2: C2C
		port map(
			N => S(23 downto 0),
			S => S(24),
			Z => M
		);
	
end Behavioral;

