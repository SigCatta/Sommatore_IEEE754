LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY PRI_ENC_TB IS
END PRI_ENC_TB;
 
ARCHITECTURE behavior OF PRI_ENC_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT PRI_ENC
    PORT(
      X: in  std_logic_vector(23 downto 0);
      Y: out std_logic_vector(7 downto 0)
      );
    END COMPONENT;

     --Inputs
     signal X   : std_logic_vector(23 downto 0);
     --Outputs
     signal Y   : std_logic_vector(7 downto 0);
    
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: PRI_ENC PORT MAP (
      X => X,
      Y => Y
     );

   process
   begin		
  

   X <= "010101010101010101010101"; 

   -- output should be 00000001
      
   wait for 100 ns;
      
   X <= "000111010110111000010010"; 

   -- output should be 00000011
   wait for 40 ns;

   X <= "000000000000000000101011"; 

   -- output should be 00010010
   wait for 40 ns;
   end process;

END;
