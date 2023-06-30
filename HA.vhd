
library ieee;
use ieee.std_logic_1164.ALL;

entity HA is

	port(
		X	  : in  std_logic;
		CIN  : in  std_logic;
		S    : out std_logic;
		COUT : out std_logic
	);

end HA;

architecture RTL of HA is
begin

	S 	  <= X xor CIN;
	COUT <= X and CIN;

end RTL;