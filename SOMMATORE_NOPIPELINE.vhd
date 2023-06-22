library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SOMMATORE_NOPIPELINE is
	port(
		X   : in  std_logic_vector(31 downto 0);
		Y   : in  std_logic_vector(31 downto 0);
		SUB : in  std_logic;
		Z   : out std_logic_vector(31 downto 0)
	);
end SOMMATORE_NOPIPELINE;

architecture Behavioral of SOMMATORE_NOPIPELINE is
	
	component DENORMALIZE is
		port(
			X      : in  std_logic_vector(31 downto 0);
			Y      : in  std_logic_vector(31 downto 0);
			SUB    : in  std_logic;
			DNORMX : out std_logic_vector(24 downto 0);
			DNORMY : out std_logic_vector(24 downto 0);
			EXP    : out std_logic_vector(7 downto 0)
		);
	end component;
	
	signal DNORMX : std_logic_vector(24 downto 0);
	signal DNORMY : std_logic_vector(24 downto 0);
	signal EXP    : std_logic_vector(7 downto 0);
	
	
	component CLU is
		port(
			X    : in  std_logic_vector(31 downto 0);
			Y    : in  std_logic_vector(31 downto 0);
			SUB  : in  std_logic;
			PINF : out std_logic;
			NINF : out std_logic;
			NAN  : out std_logic
		);
	end component;
		
	signal PINF : std_logic;
	signal NINF : std_logic;
	signal NAN  : std_logic;
	
	
	component DENORMALIZED_SUM is
		port(
			X    : in  std_logic_vector(24 downto 0);
			Y    : in  std_logic_vector(24 downto 0);
			M    : out std_logic_vector(23 downto 0);
			SIGN : out std_logic;
			INCR : out std_logic
		);
	end component;
	
	signal M    : std_logic_vector(23 downto 0);
	signal SIGN : std_logic;
	signal INCR : std_logic;
	
	
	component NORMALIZER is
		port(
			X        : in  std_logic_vector(23 downto 0);
			EXP      : in  std_logic_vector(7 downto 0);
			C        : in  std_logic;
			NEWMANTX : out std_logic_vector(22 downto 0);
			NEWEXP   : out std_logic_vector(7 downto 0)
		);
	end component;
	
	signal NEWEXP    : std_logic_vector(7 downto 0);
	signal NEWMANTIX : std_logic_vector(22 downto 0);

	
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

begin

	U1: DENORMALIZE
		port map(
			X      => X,
			Y      => Y,
			SUB    => SUB,
			DNORMX => DNORMX,
			DNORMY => DNORMY,
			EXP    => EXP
		);
		
	U2: CLU
		port map(
			X    => X,
			Y    => Y,
			SUB  => SUB,
			PINF => PINF,
			NINF => NINF,
			NAN  => NAN
		);
		
	U3: DENORMALIZED_SUM
		port map(
			X    => DNORMX,
			Y    => DNORMY,
			M    => M,
			SIGN => SIGN,
			INCR => INCR
		);
		
	U4: NORMALIZER
		port map(
			X         => M,
			EXP       => EXP,
			C         => INCR,
			NEWMANTX => NEWMANTIX,
			NEWEXP    => NEWEXP
		);
		
	U5: SNC
		port map(
			PINF => PINF,
			NINF => NINF,
			NAN  => NAN,
			SIGN => SIGN,
			EXP  => NEWEXP,
			MAN  => NEWMANTIX,
			Z => Z
		);

end Behavioral;

