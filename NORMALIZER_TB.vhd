
library ieee;
use ieee.std_logic_1164.ALL;
 
 
entity NORMALIZER_TB is
end NORMALIZER_TB;
 
architecture behavior of NORMALIZER_TB is 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
   component NORMALIZER
   port(
      X         : in  std_logic_vector(23 downto 0);   -- mantissa of the sum already complemented
      EXP       : in  std_logic_vector(7 downto 0);    -- the bigger number's exponent
      C         : in  std_logic;                       -- overflow of the sum that determinate if the mantissa has to be shifted left or right
      NORMMANTX : out std_logic_vector(22 downto 0);   -- new mantissa of the result appropiately shifted and without the first 1 
      NORMEXP   : out std_logic_vector(7 downto 0)     -- new exponent depending on the shift 
   );
   end component;
    
 --Inputs
 signal X   : std_logic_vector(23 downto 0);
 signal EXP : std_logic_vector(7 downto 0);
 signal C   : std_logic;

  --Outputs
 signal NORMMANTX : std_logic_vector(22 downto 0);
 signal NORMEXP   : std_logic_vector(7 downto 0);

begin
 
	-- Instantiate the Unit Under Test (UUT)
   uut: NORMALIZER
   port map (
      X         => X,
      EXP       => EXP,
      C         => C,
      NORMMANTX => NORMMANTX,
      NORMEXP   => NORMEXP
   );

 
process
   begin		
         X   <= "000000000000000000000000";
         EXP <= "00000000";
         C   <= '0';

      -- output should be all0s
      wait for 100 ns;	

         X   <= "010111000000000000000000";
         EXP <= "10000110";
         C   <= '1';
      
      -- output should be NORMMANTX-> 01011100000000000000000  and NORMEXP-> 10000111
      wait for 20 ns;	
      
         X   <= "000000000000000000000011";
         EXP <= "01010100";
         C   <= '0';
      
      -- output should be NORMMANTX-> 10000000000000000000000  and NORMEXP-> 00111110
      wait for 20 ns;
         X   <= "000000000000000000000000";
         EXP <= "01010100";
         C   <= '0';
      
      -- output should be NORMMANTX-> 10000000000000000000000  and NORMEXP-> 00000000
      wait for 20 ns;

         X   <= "000000000000000000000011";
         EXP <= "01010100";
         C   <= '0';
      
      -- output should be NORMMANTX-> 10000000000000000000000  and NORMEXP-> 00111110
      wait;
   end process;	

end;
