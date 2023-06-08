
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity SHIFT_RIGHT is
    port(
        X: in  std_logic_vector(23 downto 0);
        S: in  std_logic_vector(7 downto 0);
        Y: out std_logic_vector(23 downto 0)
    );
end SHIFT_RIGHT;

architecture STRUCT of SHIFT_RIGHT is
begin
    with S(4 downto 0) select
    Y <= X when "00000",
            '0' & X(23 downto 1) when "00001",
            "00" & X(23 downto 2) when "00010",
            "000" & X(23 downto 3) when "00011",
            "0000" & X(23 downto 4) when "00100",
            "00000" & X(23 downto 5) when "00101",
            "000000" & X(23 downto 6) when "00110",
            "0000000" & X(23 downto 7) when "00111",
            "00000000" & X(23 downto 7) when "01000",
            "000000000" & X(23 downto 8) when "01001",
            "0000000000" & X(23 downto 9) when "01010",
            "00000000000" & X(23 downto 10) when "01011",
            "000000000000" & X(23 downto 11) when "01100",
            "0000000000000" & X(23 downto 12) when "01101",
            "00000000000000" & X(23 downto 13) when "01110",
            "000000000000000" & X(23 downto 14) when "01111",
            "0000000000000000" & X(23 downto 15) when "10000",
            "00000000000000000" & X(23 downto 16) when "10001",
            "000000000000000000" & X(23 downto 17) when "10010",
            "0000000000000000000" & X(23 downto 18) when "10011",
            "00000000000000000000" & X(23 downto 19) when "10100",
            "000000000000000000000" & X(23 downto 20) when "10101",
            "0000000000000000000000" & X(23 downto 21) when "10110",
            "00000000000000000000000" when others; 
end STRUCT;

