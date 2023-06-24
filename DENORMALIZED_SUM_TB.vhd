library ieee;
use ieee.std_logic_1164.ALL;
 

entity DENORMALIZED_SUM_TB is
end DENORMALIZED_SUM_TB;
 
architecture behavior of DENORMALIZED_SUM_TB is 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
	component DENORMALIZED_SUM is
   	port(
		X:      in	 std_logic_vector(24 downto 0);
		Y:      in	 std_logic_vector(24 downto 0);
		M:      out  std_logic_vector(23 downto 0);
		SIGN:   out  std_logic;
		INCR:   out  std_logic
	);
	end component;
    

   --Inputs
   signal X   : std_logic_vector(24 downto 0);
   signal Y   : std_logic_vector(24 downto 0);


 	--Outputs
   signal M : std_logic_vector(23 downto 0);
   signal SIGN : std_logic;
   signal INCR : std_logic;

begin
 
	-- Instantiate the Unit Under Test (UUT)
	UUT: DENORMALIZED_SUM
	port map (
		X    => X,
		Y    => Y,
		M    => M,
		SIGN => SIGN,
		INCR => INCR
	);

   -- Stimulus process
   process
   begin		

		X 	 <= "0000000000000000000000000";
		Y 	 <= "0000000000000000000000000";

	wait for 100 ns;
	
		X 	 <= "0000000000000011011010001"; -- 1745
		Y 	 <= "1111111111111110011011111"; -- -801
		
	wait for 20 ns;
	
		X 	 <= "1111111111111100100101110"; -- -1745 (1's complement)
		Y 	 <= "1111111111111110011011111"; -- -801
		
	wait for 20 ns;
	
		X 	 <= "0110110100010000000000000"; -- 1745
		Y 	 <= "0011001000010000000000000"; -- 801
		
		
	wait for 20 ns;
	
		X 	 <= "1111111111111100100101110"; -- -1745 (1's complement)
		Y 	 <= "0000000000000001100100001"; -- 801
		
	wait for 20 ns;
	
		X 	 <= "1001001011110000000000000"; -- 1745
		Y 	 <= "1100110111110000000000000"; -- 801
		
		-- SIGN should be 1
		-- INCR should be 1
		
	wait;
	end process;

end;