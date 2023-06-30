library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity SHIFT_RIGHT is
    port(
        X : in  std_logic_vector(23 downto 0);
        S : in  std_logic_vector(7 downto 0);
        Y : out std_logic_vector(23 downto 0)
    );
end SHIFT_RIGHT;

architecture Behavioral of SHIFT_RIGHT is

	signal pos1 : std_logic_vector(23 downto 0) := (others => '0');
	signal pos2 : std_logic_vector(23 downto 0) := (others => '0');
	signal pos3 : std_logic_vector(23 downto 0) := (others => '0');
	signal pos4 : std_logic_vector(23 downto 0) := (others => '0');
	signal pos5 : std_logic_vector(23 downto 0) := (others => '0');

begin
		pos1 <= '0' & X(23 downto 1) when S(0)='1' else X;
		pos2 <= "00" & pos1(23 downto 2) when S(1)='1' else pos1;
		pos3 <= "0000" & pos2(23 downto 4) when S(2)='1' else pos2;
		pos4 <= "00000000" & pos3(23 downto 8) when S(3)='1' else pos3;
		pos5 <= "0000000000000000" & pos4(23 downto 16) when s(4)='1' else pos4;
		Y    <= "000000000000000000000000" when S(5) ='1' or S(6)='1' or S(7)='1' else pos5;

end Behavioral;
