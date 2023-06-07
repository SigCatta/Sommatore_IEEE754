
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity EXPDIFF is
    generic(width: integer);
    port(
        X    : in  std_logic_vector (width - 1 downto 0);
        Y    : in  std_logic_vector (width - 1 downto 0);
        Z    : out std_logic_vector (width - 1 downto 0)
    );
end EXPDIFF;

architecture STRUCT of EXPDIFF is
    component RCA is  
    generic(width: integer := 23);
    port(
        X    : in  std_logic_vector (width - 1 downto 0);
        Y    : in  std_logic_vector (width - 1 downto 0);
        CIN  : in  std_logic;
        S    : out std_logic_vector (width - 1 downto 0);
        COUT : out std_logic
    );
    end component;
begin


end STRUCT;

