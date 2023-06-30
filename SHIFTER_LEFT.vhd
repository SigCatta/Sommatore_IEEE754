
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity SHIFTER_LEFT is
    port(
        X: in  std_logic_vector(23 downto 0);
        S: in  std_logic_vector(7 downto 0);
        Y: out std_logic_vector(22 downto 0)
    );
end SHIFTER_LEFT;

architecture Behavioral of SHIFTER_LEFT is

	signal pos1: std_logic_vector(22 downto 0) := (others => '0');
	signal pos2: std_logic_vector(22 downto 0) := (others => '0');
	signal pos3: std_logic_vector(22 downto 0) := (others => '0');
	signal pos4: std_logic_vector(22 downto 0) := (others => '0');
	signal pos5: std_logic_vector(22 downto 0) := (others => '0');

begin
    pos1 <= X(21 downto 0) & '0' when S(0)='1' else X(22 downto 0);
    pos2 <= pos1(20 downto 0) & "00" when S(1)='1' else pos1;
    pos3 <= pos2(18 downto 0) & "0000" when S(2)='1' else pos2;
    pos4 <= pos3(14 downto 0) & "00000000" when S(3)='1' else pos3;
    pos5 <= pos4(6 downto 0) & "0000000000000000" when S(4)='1' else pos4;
    Y    <= (others => '0') when S(5) ='1' or S(6)='1' or S(7)='1' else pos5;

end Behavioral;

