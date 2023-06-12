library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity SHIFT_RHIGT_V2 is
    port(
        X: in  std_logic_vector(23 downto 0);
        S: in  std_logic_vector(7 downto 0);
        Y: out std_logic_vector(23 downto 0)
    );
end SHIFT_RHIGT_V2;

architecture Behavioral of SHIFT_RHIGT_V2 is

    signal posUNO:   std_logic_vector(23 downto 0) := "000000000000000000000000";
	signal posDUE: std_logic_vector(23 downto 0) := "000000000000000000000000";
	signal posTRE:   std_logic_vector(23 downto 0) := "000000000000000000000000";
	signal posQUATTRO:  std_logic_vector(23 downto 0) := "000000000000000000000000";
	signal posCINQUE:  std_logic_vector(23 downto 0) := "000000000000000000000000";

begin
        posUNO   <= '0' & X(23 downto 1)  when S(0)='1' else X;
		
		posDUE <= "00" & posUNO(23 downto 2) 	when S(1)='1' else posUNO;
		
		posTRE  <= "0000" & posDUE(23 downto 4) 	when S(2)='1' else posDUE;
		
		posQUATTRO  <= "00000000" & posTRE(23 downto 8) 	when S(3)='1' else posTRE;
		
		posCINQUE  <= "0000000000000000" & posQUATTRO(23 downto 16)	when S(4)='1' else posQUATTRO;
		
		Y  <=   "000000000000000000000000000" when S(5) ='1' or S(6)='1'  or  S(7)='1'
				else posCINQUE;

end Behavioral;
