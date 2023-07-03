library ieee;
use ieee.std_logic_1164.ALL;
 
entity SOMMATORE_IEEE754_TB is
end SOMMATORE_IEEE754_TB;
 
architecture behavior OF SOMMATORE_IEEE754_TB IS 
 
 
   component SOMMATORE_IEEE754
		port(
			X   : in  std_logic_vector(31 downto 0);
			Y   : in  std_logic_vector(31 downto 0);
			SUB : in  std_logic;
			Z   : out std_logic_vector(31 downto 0);
			
			CLK : in std_logic;
			RST : in std_logic
		);
   end component;
    

   --Inputs
   signal X   : std_logic_vector(31 downto 0);
   signal Y   : std_logic_vector(31 downto 0);	
   signal SUB : std_logic;

 	--Outputs
   signal Z   : std_logic_vector(31 downto 0);	
	
	--Service
	signal CLK : std_logic;
	signal RST : std_logic;
	
  
begin
 
	-- Instantiate the Unit Under Test (UUT)
   UUT: SOMMATORE_IEEE754 
      port map (
		X   => X,
		Y   => Y,
		SUB => SUB,
		Z   => Z,
			
		CLK => CLK,
		RST => RST
      );

	CLK_process :process
		begin
			CLK <= '0';
			wait for 15 ns;
			CLK <= '1';
			wait for 15 ns;
		end process;

	-- Stimulus process
   process
   begin		
		
		RST <= '1';

	wait for 76 ns;
		RST <= '0';
-- ordinary numbers (no special inputs or edge cases)
	
		X   <= "01000100101111100011011110101110"; -- 1521.739990234375
		Y   <= "01000100101001101010010011001101"; -- 1333.1500244140625
		SUB <= '0';
		
		-- output should be 01000101001100100110111000111110 (2854.89013671875) ~ 1160932926
	wait for 30 ns;
		X <= "00010000100000000000000000000001"; -- 5.048 10^(-29)  (parte frazionaria maggiore)
		Y   <= "00010000100000000000000000000000"; -- 5.048 10^(-29)
		SUB <= '0';
		
		-- output should be 00010001000000000000000000000000 1.009 10^(-28)
	wait for 30 ns;
		X   <= "11000001000000010011101101100100"; -- -8.077   
		Y   <= "11000001011001100101101000011101"; -- -14.397
		SUB <= '1';
		
		-- output should be 01000000110010100011110101110001 6.32
	wait for 30 ns;
		X   <= "01000100101001101010010011001101"; -- 1333.1500244140625
    	Y   <= "01000100101111100011011110101110"; -- 1521.739990234375  
		SUB <= '0';
		
		-- output should be 01000101001100100110111000111110 (2854.89013671875) ~ 1160932926  trying commutative propriety
	wait for 30 ns;
		X   <= "00010010100000000000000000000001"; -- 8.077 10^(-38)  
		Y   <= "00010000100000000000000000000000"; -- 5.048 10^(-29)
		SUB <= '1';
		
		-- output should be 00010010011100000000000000000010 7.573 10^(-28)
	wait for 30 ns;
		X   <= "11000001011001100101101000011101"; -- -14.397  
		Y   <= "11000001000000010011101101100100"; -- -8.077
		SUB <= '0';
		
		-- output should be 11000001101100111100101011000001 -22.474
	wait for 30 ns;
		  
		X <= "00010000100000000000000000000001"; -- norm
		Y <= "00000000100000000000000000000001"; -- small numb (rounding to 0)
		SUB <= '0'; 
		-- output should be equal to the bigger number because the difference between the numbers is more then 2^23
		
-- boundaries
	-- inferior
		wait for 30 ns;
			X <= "00000000101101100000001010000001"; -- 1.67149585331 * 10^-38
			Y <= "00000000101101100000001010000000"; -- 1.67149571318 * 10^-38
			SUB <= '1';
			
		wait for 30 ns;
			X <= "01000100101111100011011110101110";	-- 1521.739990234375
			Y <= "01000100101111100011011110101110";	-- 1521.739990234375
			SUB <= '1';

		wait for 30 ns;
		  
			X <= "00000011000000000000000001110000"; -- small numb
			Y <= "00000011000000000000000011110000"; -- small numb
			SUB <= '1';

        wait for 30 ns;
		  
			X <= "00000000100000000000000001110000"; -- small numb
			Y <= "00000000100000000000000011110000"; -- small numb
			SUB <= '1';

		wait for 30 ns;
		  
			X <= "10000000011111111111111111111100"; -- small numb
			Y <= "00000000010000000000011000001101"; -- small numb
			SUB <= '0'; 

	-- superior
		wait for 30 ns;
		  
			X <= "01111111011111111111111111111100"; -- Big numb
			Y <= "01111111000000000000011000001101"; -- Big numb
			SUB <= '0'; 
		
		wait for 30 ns;
		  
			X <= "10000000000000000000000000000011"; -- small numb
			Y <= "11111111011111111111111111111111"; -- Not really infinity
			SUB <= '0'; 

-- special numbers
	-- infinity
      wait for 30 ns;			-- inf - inf
				
			X <= "01111111100000000000000000000000"; -- +inf
			Y <= "01111111100000000000000000000000"; -- +inf
			SUB <= '1';
			-- output should be x11111111aaaaaaaaaaaaaaaaaaaaaaa (NAN) at least one bit in the mantissa has to be 1

		wait for 30 ns;			-- -inf + inf
				
			X <= "11111111100000000000000000000000"; -- -inf
			Y <= "01111111100000000000000000000000"; -- +inf
			SUB <= '0';
			-- output should be x11111111aaaaaaaaaaaaaaaaaaaaaaa (NAN) at least one bit in the mantissa has to be 1

		wait for 30 ns;			-- -inf - inf 
				
			X <= "11111111100000000000000000000000"; -- -inf
			Y <= "11111111100000000000000000000000"; -- -inf
			SUB <= '0';
			-- output should be 11111111100000000000000000000000 (-inf) ~ 4286578688

		wait for 30 ns;			-- -inf - num
				
			X <= "11111111100000000000000000000000"; -- -inf
			Y <= "11001001100101101011010000111000"; -- -1234567 ~ random negative number
			SUB <= '0';
			-- output should be 11111111100000000000000000000000 (-inf) ~ 4286578688

		wait for 30 ns;			-- -inf + num
				
			X <= "11111111100000000000000000000000"; -- -inf
			Y <= "11001001100101101011010000111000"; -- -1234567 ~ random negative number
			SUB <= '1';
			-- output should be 11111111100000000000000000000000 (-inf) ~ 4286578688
			
		wait for 30 ns;			-- +inf - num
				
			X <= "01111111100000000000000000000000"; -- +inf
			Y <= "11001001100101101011010000111000"; -- -1234567 ~ random negative number
			SUB <= '0';
			-- output should be 01111111100000000000000000000000 (+inf) ~ 2139095040

		wait for 30 ns;			-- +inf + num
			
			X <= "01111111100000000000000000000000"; -- +inf
			Y <= "11001001100101101011010000111000"; -- -1234567 ~ random negative number
			SUB <= '1';
			-- output should be 01111111100000000000000000000000 (+inf) ~ 2139095040
		
		wait for 30 ns;			-- inf + 0
			
			X <= "01111111100000000000000000000000"; -- +inf
			Y <= "00000000000000000000000000000000"; -- 0
			SUB <= '0';
			-- output should be 01111111100000000000000000000000 (+inf) ~ 2139095040
		wait for 30 ns;			-- inf - 0
			
			X <= "01111111100000000000000000000000"; -- +inf
			Y <= "00000000000000000000000000000000"; -- 0
			SUB <= '1';
			-- output should be 01111111100000000000000000000000 (+inf) ~ 2139095040

	-- Not a Number
		wait for 30 ns;
			
			X <= "11111111100000000000000110000000"; -- NAN
			Y <= "11001001100101101011010000111000"; -- -1234567
			SUB <= '1';
			-- output should be x11111111aaaaaaaaaaaaaaaaaaaaaaa (NAN) at least one bit in the mantissa has to be 1
		
		wait for 30 ns;
			X <= "01111111100101101011010000111000"; -- NaN
			Y <= "00000000000000000000000000000000"; -- 0
			SUB <= '0';
			-- output should be NaN

	   wait for 30 ns;
		  
			X <= "01111111100101101011000111101000"; -- NaN
			Y <= "01111111100101101011111111101000"; -- NaN
			SUB <= '1'; 
		  -- output should be NaN				

		wait for 30 ns;
		  
			X <= "01111111100101101011000111101000"; -- NaN
			Y <= "01111111100000000000000000000000"; -- inf
			SUB <= '0'; 
			-- output should be NaN
		
		  
	  wait;
   end process;

end;