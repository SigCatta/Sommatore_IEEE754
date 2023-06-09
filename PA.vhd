library ieee;
use ieee.std_logic_1164.ALL;

entity PA is
    generic(width: integer);
    port(
        X    : in  std_logic_vector (width - 1 downto 0);
        CIN  : in  std_logic;
        S    : out std_logic_vector (width - 1 downto 0);
        COUT : out std_logic
    );
end PA;

architecture STRUCT of PA is

    component HA is 
    port(
		X	 : in  std_logic;
		CIN	 : in  std_logic;
		S	 : out std_logic;
		COUT : out std_logic
    );
    end component;

    signal C: std_logic_vector(width downto 0);
begin
    
    GEN: for I in 0 to width - 1 generate
        U: HA port map(
            X    => X(I),
            CIN  => C(I),
            S    => S(I),
            COUT => C(I + 1)
        );
    end generate;

    C(0) <= CIN;
    COUT <= C(width);

end STRUCT;