library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DENORMALIZED_SUM is
	port(
		X    : in  std_logic_vector(24 downto 0);
		Y    : in  std_logic_vector(24 downto 0);
		M    : out std_logic_vector(23 downto 0);
		SIGN : out std_logic;
		INCR : out std_logic -- indicats if the the exponent will have to be incremented by one 
	);
end DENORMALIZED_SUM;

architecture Behavioral of DENORMALIZED_SUM is

	component RCA is
		generic(width: integer := 26);
		port(
			X    : in  std_logic_vector (width - 1 downto 0);
			Y    : in  std_logic_vector (width - 1 downto 0);
			CIN  : in  std_logic;
			S    : out std_logic_vector (width - 1 downto 0);
			COUT : out std_logic
		);
	end component;
	
	component PA is														-- calculates the result's 2's complement if necessary
		generic(width: integer := 24);
		port(
			X    : in  std_logic_vector (width - 1 downto 0);
			CIN  : in  std_logic;
			S    : out std_logic_vector (width - 1 downto 0);
			COUT : out std_logic
		);
	end component;
	
	
	component MUX is														-- selects between the result and it's 2's complement
		generic(width : integer := 24);
		port(
			X : in  std_logic_vector (width - 1 downto 0);
			Y : in  std_logic_vector (width - 1 downto 0);
			S : in  std_logic;
			Z : out std_logic_vector (width - 1 downto 0)
		);
	end component;
	
	signal S    : std_logic_vector(25 downto 0);
	signal NEGS : std_logic_vector(23 downto 0);
	signal COUT : std_logic;

begin

	U1: RCA							-- each number has 1 sign bit, 1 extra bit for overflows, 1 extra 1 (not shown in mantissa), 23 mantissa bits
		port map(
			X    => X(24) & X,	-- adding the extra overflow bit (1 if the number is negative, 0 if positive)
			Y    => Y(24) & Y,	-- adding the extra overflow bit (1 if the number is negative, 0 if positive)
			CIN  => X(24),			-- if X is negative, it need to be converted to the 2's complement
			S    => S,
			COUT => COUT
		);
		
	INCR <= S(24) xor S(25);
	SIGN <= S(25);
		
	U2: PA
		port map(
			X   => not S(23 downto 0),
			CIN => '1',
			S   => NEGS
		);
		
	U3: MUX
		port map(
			X => S(23 downto 0),
			Y => NEGS,
			S => S(25),
			Z => M
		);
	
end Behavioral;

