
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY NORMALIZER_TB IS
END NORMALIZER_TB;
 
ARCHITECTURE behavior OF NORMALIZER_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT NORMALIZER
    PORT(
      X:	  in  std_logic_vector(23 downto 0);   -- mantissa of the sum already complemented
      EXP:  in  std_logic_vector(7 downto 0);
      C:	  in  std_logic; -- overflow of the sum that determinate if the mantissa has to be shifted left or right
      NEWMANTX: out  std_logic_vector(22 downto 0); -- new mantissa of the result shifted and without the first 1 
      NEWEXP: out  std_logic_vector(7 downto 0) -- new exponent depending on the shift 
        );
    END COMPONENT;
    
 --Inputs
 signal X   : std_logic_vector(23 downto 0);
 signal EXP   : std_logic_vector(7 downto 0);
 signal C : std_logic;

  --Outputs
 signal NEWMANTX : std_logic_vector(22 downto 0);
 signal NEWEXP : std_logic_vector(7 downto 0);

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: NORMALIZER PORT MAP (
       X => X,
       EXP => EXP,
       C => C,
       NEWMANTX => NEWMANTX,
       NEWEXP => NEWEXP
        );

 
process
   begin		
      X <= "000000000000000000000000";
      EXP <= "00000000";
      C <= '0';

       -- output should be all0s
      wait for 100 ns;	

      X <= "010111000000000000000000";
      EXP <= "10000110";
      C <= '1';
      
       -- output should be NEWMANT-> 01011100000000000000000  and NEWEXP-> 10000111
      wait for 20 ns;	
      
		X <= "000000000000000000000011";
      EXP <= "01010100";
      C <= '0';
      
       -- output should be NEWMANT-> 10000000000000000000000  and NEWEXP-> 00111110
      wait for 20 ns;
      X <= "000000000000000000000000";
      EXP <= "01010100";
      C <= '0';
      
       -- output should be NEWMANT-> 10000000000000000000000  and NEWEXP-> 00000000
      wait for 20 ns;

      X <= "000000000000000000000011";
      EXP <= "01010100";
      C <= '0';
      
       -- output should be NEWMANT-> 10000000000000000000000  and NEWEXP-> 00111110
      wait;
   end process;	

END;
