
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity SHIFT_RIGHT is
    port(
        X : in  std_logic_vector(23 downto 0);
        S : in  std_logic_vector(7 downto 0);
        Y : out std_logic_vector(23 downto 0)
    );
end SHIFT_RIGHT;

architecture STRUCT of SHIFT_RIGHT is
begin
    with S select
    Y <= X when "00000000",
            "0" & X(23 downto 1) when "00000001",
            "00" & X(23 downto 2) when "00000010",
            "000" & X(23 downto 3) when "00000011",
            "0000" & X(23 downto 4) when "00000100",
            "00000" & X(23 downto 5) when "00000101",
            "000000" & X(23 downto 6) when "00000110",
            "0000000" & X(23 downto 7) when "00000111",
            "00000000" & X(23 downto 8) when "00001000",
            "000000000" & X(23 downto 9) when "00001001",
            "0000000000" & X(23 downto 10) when "00001010",
            "00000000000" & X(23 downto 11) when "00001011",
            "000000000000" & X(23 downto 12) when "00001100",
            "0000000000000" & X(23 downto 13) when "00001101",
            "00000000000000" & X(23 downto 14) when "00001110",
            "000000000000000" & X(23 downto 15) when "00001111",
            "0000000000000000" & X(23 downto 16) when "00010000",
            "00000000000000000" & X(23 downto 17) when "00010001",
            "000000000000000000" & X(23 downto 18) when "00010010",
            "0000000000000000000" & X(23 downto 19) when "00010011",
            "00000000000000000000" & X(23 downto 20) when "00010100",
            "000000000000000000000" & X(23 downto 21) when "00010101",
            "0000000000000000000000" & X(23 downto 22) when "00010110",
            (others => '0') when others; 
end STRUCT;