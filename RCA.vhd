library ieee;
use ieee.std_logic_1164.ALL;

entity RCA is
    generic(width: integer := 8);
    port(
        X    : in  std_logic_vector (width - 1 downto 0);
        Y    : in  std_logic_vector (width - 1 downto 0);
        CIN  : in  std_logic;
        S    : out std_logic_vector (width - 1 downto 0);
        COUT : out std_logic
    );
end RCA;

architecture STRUCT of RCA is

    component FA is 
    port(
		X	 : in  std_logic;
		Y	 : in  std_logic;
		CIN	 : in  std_logic;
		S	 : out std_logic;
		COUT : out std_logic
    );
    end component;

    signal C: std_logic_vector(width downto 0);
begin
    
    GEN: for I in 0 to width - 1 generate
        U: FA port map(
            X    => X(I),
            Y    => Y(I),
            CIN  => C(I),
            S    => S(I),
            COUT => C(I + 1)
        );
    end generate;

    C(0) <= CIN;
    COUT <= C(width);

end STRUCT;