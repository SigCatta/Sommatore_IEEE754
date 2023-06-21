
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SNC is
	port(
		PINF: in std_logic;
		NINF: in std_logic;
		NAN:  in std_logic;
		SIGN: in std_logic;
		EXP:  in std_logic_vector(7 downto 0);
		MAN:  in std_logic_vector(22 downto 0);
		Z:    out std_logic_vector(31 downto 0)
	);
end SNC;

architecture Behavioral of SNC is

	component MUX is
		generic(width: integer);
      port( 
          X    : in  std_logic_vector (width - 1 downto 0);
          Y    : in  std_logic_vector (width - 1 downto 0);
          S    : in  std_logic;
          Z    : out std_logic_vector (width - 1 downto 0)
      );
   end component;
	
	signal EXPALL1: std_logic;
	signal SPECIAL: std_logic;
	signal MANTISSA: std_logic_vector(22 downto 0);

begin

	EXPALL1 <= ((EXP(0) and EXP(1)) and (EXP(2) and EXP(3))) and ((EXP(4) and EXP(5)) and (EXP(6) and EXP(7)));
	SPECIAL <= PINF or NINF or NAN;
	
	U1: MUX								-- calculates the exponent relative to special numbers
		generic map(width => 8)
		port map(
			X => EXP,
			Y => "11111111",
			S => SPECIAL,
			Z => Z(30 downto 23)
		);
	

	GEN: for I in 0 to 22 generate
		MANTISSA(I) <= MAN(I) and (not EXPALL1);
	end generate;
	
	U2: MUX								-- calculates the mantissa relative to special numbers
		generic map(width => 23)
		port map(
			X => MANTISSA,
			Y => NAN & "0000000000000000000000",
			S => SPECIAL,
			Z => Z(22 downto 0)
		);
	
	Z(31) <= (SIGN and (not SPECIAL)) or (NINF and SPECIAL);
end Behavioral;
