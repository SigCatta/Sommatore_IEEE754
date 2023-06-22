library ieee;
use ieee.std_logic_1164.ALL;
 
entity SOMMATORE_NOPIPELINE_TB is
end SOMMATORE_NOPIPELINE_TB;
 
architecture behavior OF SOMMATORE_NOPIPELINE_TB IS 
 
 
   component SOMMATORE_NOPIPELINE
		port(
			X   : in  std_logic_vector(31 downto 0);
			Y   : in  std_logic_vector(31 downto 0);
			SUB : in  std_logic;
			Z   : out std_logic_vector(31 downto 0)
		);
   end component;
    

   --Inputs
   signal X   : std_logic_vector(31 downto 0);
   signal Y   : std_logic_vector(31 downto 0);	
   signal SUB : std_logic;

 	--Outputs
   signal Z   : std_logic_vector(31 downto 0);	
  
begin
 
	-- Instantiate the Unit Under Test (UUT)
   UUT: SOMMATORE_NOPIPELINE 
      port map (
         X   => X,
         Y   => Y,
         SUB => SUB,
         Z   => Z 
      );

   process
   begin		
   
      X <= "00000000000000000000000000000000";
		Y <= "00000000000000000000000000000000";
      SUB <= '0';

      wait for 100 ns;
		
      X <= "01001001100101101011010000111000"; -- 1234567
		Y <= "01001010000011110010101100111000"; -- 2345678
      SUB <= '0';
		
		-- output should be 0 10000010 01001010010110101000010101010100 (1247446356)
		
		wait for 100 ns;
		

      wait;
   end process;

end;