LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 


ENTITY SHIFT_RHIGT_V2_TB IS
END SHIFT_RHIGT_V2_TB;
 
ARCHITECTURE behavior OF SHIFT_RHIGT_V2_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT SHIFT_RHIGT_V2
    PORT(
      X: in  std_logic_vector(23 downto 0);
      S: in  std_logic_vector(7 downto 0);
      Y: out std_logic_vector (23 downto 0)
        );
    END COMPONENT;
   
     --Inputs
     signal X   : std_logic_vector(23 downto 0);
     signal S   : std_logic_vector(7 downto 0);
     --Outputs
     signal Y   : std_logic_vector(23 downto 0);

begin
 
	-- Instantiate the Unit Under Test (UUT)
   uut: SHIFT_RHIGT_V2 PORT MAP (
            X => X,
            S => S,
            Y => Y
        );

   process
   begin		
   X <= "000000000000000000000000";
   S  <= "00000000";

   wait for 100 ns;	

   X <= "010101010101010101010101"; 
   S <= "00011000";

   -- output should be 00000000000000000000000
      
   wait for 20 ns;
      
   X <= "110010011010110111000010"; 
   S <= "00000010";

   -- output should be 001100100110101101110000
   wait;
   end process;

END;