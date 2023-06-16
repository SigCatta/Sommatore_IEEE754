
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

   signal posUNO:   std_logic_vector(22 downto 0) := "00000000000000000000000";
	signal posDUE: std_logic_vector(22 downto 0) := "00000000000000000000000";
	signal posTRE:   std_logic_vector(22 downto 0) := "00000000000000000000000";
	signal posQUATTRO:  std_logic_vector(22 downto 0) := "00000000000000000000000";
	signal posCINQUE:  std_logic_vector(22 downto 0) := "00000000000000000000000";

begin
    posUNO   <=  X(21 downto 0) & '0'  when S(0)='1' else X(22 downto 0);
		
    posDUE <= posUNO(20 downto 0) & "00" 	when S(1)='1' else posUNO;
    
    posTRE  <= posDUE(18 downto 0) & "0000" 	when S(2)='1' else posDUE;
    
    posQUATTRO  <= posTRE(14 downto 0) & "00000000"	when S(3)='1' else posTRE;
    
    posCINQUE  <= posQUATTRO(6 downto 0) & "0000000000000000"	when S(4)='1' else posQUATTRO;
    
    Y  <=   "00000000000000000000000" when S(5) ='1' or S(6)='1'  or  S(7)='1'
            else posCINQUE;


end Behavioral;

