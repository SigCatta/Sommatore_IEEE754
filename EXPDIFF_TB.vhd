library ieee;
use ieee.std_logic_1164.ALL;
 

entity EXPDIFF_TB is
end EXPDIFF_TB;
 
architecture behavior of EXPDIFF_TB is 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    component EXPDIFF
      generic(width: integer := 8);      -- using 8 bits
      port(
         X : in  std_logic_vector(7 downto 0);
         Y : in  std_logic_vector(7 downto 0);
         Z : out  std_logic_vector(7 downto 0);
         C : inout  std_logic
        );
    end component;
    

   --Inputs
   signal X : std_logic_vector(7 downto 0);
   signal Y : std_logic_vector(7 downto 0);

 	--Outputs
   signal Z : std_logic_vector(7 downto 0);
   signal C : std_logic;
  
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   UUT: EXPDIFF 
	port map (
          X => X,
          Y => Y,
          Z => Z,
          C => C
        );

   -- Stimulus process
   process
   begin		

      X <= "00000000";
      Y <= "00000000";
      wait for 100 ns;	

      X <= "01010101"; -- 85
      Y <= "10101010"; -- 170
      -- expected output 85

      wait for 20 ns;	

      X <= "01011010"; -- 90
      Y <= "01000110"; -- 70
      -- expected output 20

      wait for 20 ns;	

      X <= "10010110"; -- 150
      Y <= "00010111"; -- 23
      -- expected output 127
      
      wait;
   end process;

end;
