library ieee;
use ieee.std_logic_1164.ALL;
 

entity DENORMALIZED_SUM_TB is
end DENORMALIZED_SUM_TB;
 
architecture behavior of DENORMALIZED_SUM_TB is 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
	component DENORMALIZED_SUM is
   	port(
		X:		  in	 std_logic_vector(24 downto 0);
		Y:		  in	 std_logic_vector(24 downto 0);
		SUB:	  in	 std_logic;
		M:		  out  std_logic_vector(23 downto 0);
		C: 	  out  std_logic								-- the last of the sum between X and Y
	);
	end component;
    

   --Inputs
   signal X   : std_logic_vector(24 downto 0);
   signal Y   : std_logic_vector(24 downto 0);
   signal SUB : std_logic;


 	--Outputs
   signal M : std_logic_vector(23 downto 0);
   signal C : std_logic;


begin
 
	-- Instantiate the Unit Under Test (UUT)
	UUT: DENORMALIZED_SUM
	port map (
		X		 => X,
		Y		 => Y,
		SUB	 => SUB,
		M		 => M,
		C		 => C
	);

   -- Stimulus process
   process
   begin		

		X 	 <= "0000000000000000000000000";
		Y 	 <= "0000000000000000000000000";
		SUB  <= '0';

	wait for 100 ns;
	
		X 	 <= "0000000000000011011010001"; -- 1745
		Y 	 <= "1111111111111110011011111"; -- -801
		SUB  <= '0';
		
		-- output should be 944
		
	wait for 20 ns;
	
		X 	 <= "1111111111111100100101111"; -- -1745
		Y 	 <= "1111111111111110011011111"; -- -801
		SUB  <= '0';
		
		-- output should be 2546
		
	wait for 20 ns;
	
		X 	 <= "0000000000000011011010001"; -- 1745
		Y 	 <= "0000000000000001100100001"; -- 801
		SUB  <= '0';
		
		-- output should be 944
		
	wait for 20 ns;
	
		X 	 <= "1111111111111100100101111"; -- -1745
		Y 	 <= "0000000000000001100100001"; -- 801
		SUB  <= '0';
		
		-- output should be 944
		
	wait;
	end process;

end;