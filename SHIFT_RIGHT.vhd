
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity SHIFT_RIGHT is
    port(
        X: in  std_logic_vector (7 downto 0);
        S: in  std_logic_vector(2 downto 0);
        Y: out std_logic_vector (7 downto 0);
    );
end SHIFT_RIGHT;

architecture STRUCT of SHIFT_RIGHT is
begin
    with S select
    Y <= X when "000",
            '0' & X(7 to 1) when "001",
            "00" & X(7 to 2) when "010",
            "000" & X(7 to 3) when "011",
            "0000" & X(7 to 4) when "100",
            "00000" & X(7 to 5) when "101",
            "000000" & X(7 to 6) when "110",
            "0000000" & X(7) when "111",
            "00000000" when others; 
end STRUCT;

