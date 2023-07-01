
library ieee;
use ieee.std_logic_1164.ALL;

entity C2C is
    generic(width: integer);
    port(
        N    : in  std_logic_vector(width - 1 downto 0);
        S    : in  std_logic;
        Z    : out std_logic_vector(width - 1 downto 0);
        COUT : out std_logic
    );
end C2C;

architecture STRUCT of C2C is

    component PA is
		generic(width : integer := width);
		port(
			X    : in  std_logic_vector(width - 1 downto 0);
			CIN  : in  std_logic;
			S    : out std_logic_vector(width - 1 downto 0);
			COUT : out std_logic
		);
    end component;

    signal PAIN : std_logic_vector(width - 1 downto 0);
	signal vS   : std_logic_vector(width - 1 downto 0);
begin
	
	vS <= (others => S);
	PAIN <= N xor vS;
	
	U1: PA
	port map(
		X    => PAIN,
		CIN  => S,
		S    => Z,
		COUT => COUT
	);
    

end STRUCT;
