
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity NORMALIZE is
	port(
		SIGN : in std_logic;
		EXP  : in std_logic_vector(7 downto 0);
		MAN  : in std_logic_vector(23 downto 0);
		INCR : in std_logic;
		PINF : in std_logic;
		NINF : in std_logic;
		NAN  : in std_logic;
		Z    : out std_logic_vector(31 downto 0)
	);
end NORMALIZE;

architecture Behavioral of NORMALIZE is

	component NORMALIZER is
		port(
			X        : in  std_logic_vector(23 downto 0);
			EXP      : in  std_logic_vector(7 downto 0);
			C        : in  std_logic;
			NORMMANTX : out std_logic_vector(22 downto 0);
			NORMEXP   : out std_logic_vector(7 downto 0)
		);
	end component;
	
	component SNC is
		port(
			PINF : in std_logic;
			NINF : in std_logic;
			NAN  : in std_logic;
			SIGN : in std_logic;
			EXP  : in std_logic_vector(7 downto 0);
			MAN  : in std_logic_vector(22 downto 0);
			Z    : out std_logic_vector(31 downto 0)
		);
	end component;
	
	signal NORMMANTX : std_logic_vector(22 downto 0);
	signal NORMEXP   : std_logic_vector(7 downto 0);

begin

	U1: NORMALIZER
		port map(
			X         => MAN,
			EXP       => EXP,
			C         => INCR,
			NORMMANTX => NORMMANTX,
			NORMEXP   => NORMEXP
		);
		
	U2: SNC
		port map(
			PINF => PINF,
			NINF => NINF,
			NAN  => NAN,
			SIGN => SIGN,
			EXP  => NORMEXP,
			MAN  => NORMMANTX,
			Z    => Z
		);


end Behavioral;

