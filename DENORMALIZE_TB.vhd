library ieee;
use ieee.std_logic_1164.ALL;
 

entity DENORMALIZE_TB is
end DENORMALIZE_TB;
 
architecture behavior of DENORMALIZE_TB is 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
	component DENORMALIZE is
	port(
			X:		  in	  std_logic_vector(31 downto 0);
			Y:		  in	  std_logic_vector(31 downto 0);
			SUB:	  in	  std_logic;
			DNORMX: out   std_logic_vector(24 downto 0);
			DNORMY: out	  std_logic_vector(24 downto 0);
			EXP	: out	  std_logic_vector(7 downto 0)
		);
	end component;
    

   --Inputs
	signal X   : std_logic_vector(31 downto 0);
	signal Y   : std_logic_vector(31 downto 0);
	signal SUB : std_logic;


 	--Outputs
	signal DNORMX : std_logic_vector(24 downto 0);
	signal DNORMY : std_logic_vector(24 downto 0);
	signal EXP	  : std_logic_vector(7 downto 0);

begin
 
	-- Instantiate the Unit Under Test (UUT)
	UUT: DENORMALIZE 
	port map (
		X		 => X,
		Y		 => Y,
		SUB	 => SUB,
		DNORMX => DNORMX,
		DNORMY => DNORMY,
		EXP	 => EXP
	);

   -- Stimulus process
   process
   begin		
		X 	 <= "00000000000000000000000000000000";
		Y 	 <= "00000000000000000000000000000000";
		SUB  <= '0';

	wait for 100 ns;	


-- SUB = 0, X positive, Y positive
		
		X 	 <= "01000100110110110100000000000000"; -- S = 0, E = 137
		Y 	 <= "01000100101001111010000000000000"; -- S = 0, E = 137
		SUB  <= '0';
		
		-- C should be 0
		-- DNORMX should be 0101001111010000000000000 ~ 10985472
		-- DNORMY should be 0110110110100000000000000 ~ 14368768
		-- EXP should be 10001001 - 137
	
	wait for 20 ns;
		
		X 	 <= "01000100110110110100000000000000"; -- S = 0, E = 137
		Y 	 <= "00111110100111101011100001010010"; -- S = 0, E = 125
		SUB  <= '0';
		
		-- C should be 0
		-- DNORMX should be 0000000000000100111101011 ~ 2539
		-- DNORMY should be 0110110110100000000000000 ~ 14368768
		-- EXP should be 10001001 - 137
	
	wait for 20 ns;
		
		X 	 <= "01000100110110110100000000000000"; -- S = 0, E = 137
		Y 	 <= "01000000110000000000000000000000"; -- S = 0, E = 129
		SUB  <= '0';
		
		-- C should be 0
		-- DNORMX should be 0000000001100000000000000 ~ 49152
		-- DNORMY should be 0110110110100000000000000 ~ 14368768
		-- EXP should be 10001001 - 137
		
-- SUB = 1, X positive, Y positive
      
	wait for 20 ns;	
		
		X 	 <= "01000100110110110100000000000000"; -- S = 0, E = 137
		Y 	 <= "01000100101001111010000000000000"; -- S = 0, E = 137
		SUB  <= '1';
		
		-- C should be 0
		-- DNORMX should be 1010110000110000000000000 ~ -10985472
		-- DNORMY should be 0110110110100000000000000 ~ 14368768
		-- EXP should be 10001001 - 137
	
	wait for 20 ns;
		
		X 	 <= "01000100110110110100000000000000"; -- S = 0, E = 137
		Y 	 <= "00111110100111101011100001010010"; -- S = 0, E = 125
		SUB  <= '1';
		
		-- C should be 0
		-- DNORMX should be 1111111111111011000010101 ~ -2539
		-- DNORMY should be 0110110110100000000000000 ~ 14368768
		-- EXP should be 10001001 - 137
	
	wait for 20 ns;
		
		X 	 <= "01000100110110110100000000000000"; -- S = 0, E = 137
		Y 	 <= "01000000110000000000000000000000"; -- S = 0, E = 129
		SUB  <= '1';
		
		-- C should be 0
		-- DNORMX should be 1111111110100000000000000 ~ -49152
		-- DNORMY should be 0110110110100000000000000 ~ 14368768
		-- EXP should be 10001001 - 137
		
		
-- SUB = 1, X positive, Y negative ~ should work just like SUB = 0, X positive, Y positive

	wait for 20 ns;
	
		
		X 	 <= "01000100110110110100000000000000"; -- S = 0, E = 137
		Y 	 <= "11000100101001111010000000000000"; -- S = 0, E = 137
		SUB  <= '1';
		
		-- C should be 0
		-- DNORMX should be 0101001111010000000000000 ~ 10985472
		-- DNORMY should be 0110110110100000000000000 ~ 14368768
		-- EXP should be 10001001 - 137
	
	wait for 20 ns;
		
		X 	 <= "01000100110110110100000000000000"; -- S = 0, E = 137
		Y 	 <= "10111110100111101011100001010010"; -- S = 0, E = 125
		SUB  <= '1';
		
		-- C should be 0
		-- DNORMX should be 0000000000000100111101011 ~ 2539
		-- DNORMY should be 0110110110100000000000000 ~ 14368768
		-- EXP should be 10001001 - 137
	
	wait for 20 ns;
		
		X 	 <= "01000100110110110100000000000000"; -- S = 0, E = 137
		Y 	 <= "11000000110000000000000000000000"; -- S = 0, E = 129
		SUB  <= '1';
		
		-- C should be 0
		-- DNORMX should be 0000000001100000000000000 ~ 49152
		-- DNORMY should be 0110110110100000000000000 ~ 14368768
		-- EXP should be 10001001 - 137

-- SUB = 0, X negative, Y positive
      
	wait for 20 ns;
	
		
		X 	 <= "11000100110110110100000000000000"; -- S = 0, E = 137
		Y 	 <= "01000100101001111010000000000000"; -- S = 0, E = 137
		SUB  <= '0';
		
		-- C should be 0
		-- DNORMX should be 0101001111010000000000000 ~ 10985472
		-- DNORMY should be 0110110110100000000000000 ~ -14368768
		-- EXP should be 10001001 - 137
	
	wait for 20 ns;
		
		X 	 <= "11000100110110110100000000000000"; -- S = 0, E = 137
		Y 	 <= "00111110100111101011100001010010"; -- S = 0, E = 125
		SUB  <= '0';
		
		-- C should be 0
		-- DNORMX should be 0000000000000100111101011 ~ 2539
		-- DNORMY should be 0110110110100000000000000 ~ -14368768
		-- EXP should be 10001001 - 137
	
	wait for 20 ns;
		
		X 	 <= "11000100110110110100000000000000"; -- S = 0, E = 137
		Y 	 <= "01000000110000000000000000000000"; -- S = 0, E = 129
		SUB  <= '0';
		
		-- C should be 0
		-- DNORMX should be 0000000001100000000000000 ~ 49152
		-- DNORMY should be 0110110110100000000000000 ~ -14368768
		-- EXP should be 10001001 - 137
	wait;
	end process;

end;