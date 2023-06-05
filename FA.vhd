
library ieee;
use ieee.std_logic_1164.ALL;

entity FA is

	port(
		X	 : in  std_logic;
		Y	 : in  std_logic;
		CIN	 : in  std_logic;
		S	 : out std_logic;
		COUT : out std_logic
	);

end FA;

architecture RTL of FA is
begin

	S 	 <= X xor Y xor CIN;
	COUT <= (X and Y) or (X and CIN) or (Y and CIN);

end RTL;
