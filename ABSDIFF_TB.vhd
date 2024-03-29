library ieee;
use ieee.std_logic_1164.ALL;
 

entity ABSDIFF_TB is
end ABSDIFF_TB;
 
architecture behavior of ABSDIFF_TB is 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
	component ABSDIFF is
		generic (width: integer);
		port(
         X : in  std_logic_vector(7 downto 0);
			Y : in  std_logic_vector(7 downto 0);
			Z : out std_logic_vector(7 downto 0)
		);
	end component;
    

   --Inputs
	signal X : std_logic_vector(7 downto 0);
	signal Y : std_logic_vector(7 downto 0);

 	--Outputs
	signal Z : std_logic_vector(7 downto 0);
  
begin
 
	-- Instantiate the Unit Under Test (UUT)
   UUT: ABSDIFF
	generic map(width => 8)
	port map(
      X => X,
      Y => Y,
      Z => Z
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