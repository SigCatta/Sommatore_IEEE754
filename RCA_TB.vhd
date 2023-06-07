

library ieee;
use ieee.std_logic_1164.ALL;

entity RCA_TB is
end RCA_TB;
 
architecture behavior of RCA_TB is 
   component RCA
	 generic(width: integer := 8);      -- using a 8 bit RCA
    port(
         X 	  : in   std_logic_vector(7 downto 0);
         Y 	  : in   std_logic_vector(7 downto 0);
         CIN  : in   std_logic;
         S 	  : out  std_logic_vector(7 downto 0);
         COUT : out  std_logic
      );
   end component;
    

   --Inputs
   signal X 	: std_logic_vector(7 downto 0);
   signal Y 	: std_logic_vector(7 downto 0);
   signal CIN  : std_logic;

 	--Outputs
   signal S 	: std_logic_vector(7 downto 0);
   signal COUT : std_logic;
 
begin
 
	-- Instantiate the Unit Under Test (UUT)
   UUT: RCA
			generic map (width => 8)
			port map (
          X		=> X,
          Y 	=> Y,
          CIN  => CIN,
          S 	=> S,
          COUT => COUT
        );
        
   process
   begin		

      X	 <= "00000000";
      Y 	 <= "00000000";
      CIN <= '0';

      wait for 100 ns;	

      X	 <= "00000001"; 
      Y	 <= "00000001";
      CIN <= '1';

      -- output should be 00000011

      wait for 20 ns;

      X	 <= "01010101"; 
      Y	 <= "10101010";
      CIN <= '0';
		
		-- output should be 11111111
      wait;
   end process;

end;
