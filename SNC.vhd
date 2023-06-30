
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SNC is
	port(
		PINF : in std_logic;
		NINF : in std_logic;
		NAN  : in std_logic;
		SIGN : in std_logic;
		EXP  : in std_logic_vector(7 downto 0);
		MAN  : in std_logic_vector(22 downto 0);
		Z    : out std_logic_vector(31 downto 0)
	);
end SNC;

architecture Behavioral of SNC is

	signal SPECIAL  : std_logic;
	signal MANTISSA : std_logic_vector(22 downto 0);

begin

	SPECIAL <= PINF or NINF or NAN;
	-- if calculated exponent is 255, the number should be an infinity, therefore the mantissa should be 0
	MANTISSA <= MAN when EXP /= "11111111" else (others => '0');
	
	Z(31) <= (SIGN and (not SPECIAL)) or (NINF and SPECIAL);
	
	-- if the result is a special number, the exponent must be 255
	Z(30 downto 23) <= EXP when SPECIAL = '0' else (others => '1');

	-- if the result is a special number the mantissa is all 0s if infinity or a number other then 0 if NaN
	Z(22 downto 0) <= MANTISSA when SPECIAL = '0' else "0000000000000000000000" & NAN;
	
end Behavioral;