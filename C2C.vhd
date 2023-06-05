
library ieee;
use ieee.std_logic_1164.ALL;

entity C2C is
    generic(width: integer);
    port(
        N    : in  std_logic_vector (width - 1 downto 0);
        S    : in  std_logic;
        Z    : out std_logic_vector (width - 1 downto 0);
        COUT : out std_logic
    );
end C2C;

architecture STRUCT of C2C is

    component HA is
        port(
            X	 : in  std_logic;
            CIN	 : in  std_logic;
            S	 : out std_logic;
            COUT : out std_logic     --CHECK might be useless
        );
    end component;

    signal C: std_logic_vector(width downto 0);
begin

    GEN: for I in 0 to width - 1 generate
        U: HA port map(
            X    => N(I) xor S,     -- not bit if the number is negative 
            CIN  => C(I),           -- carry in  
            S    => Z(I),           -- output bit
            COUT => C(I + 1)        -- carry out
        );
    end generate;

    C(0) <= S;      -- the first carry is 1 if the number is negative, 0 otherwise
    COUT <= C(width);

end STRUCT;

