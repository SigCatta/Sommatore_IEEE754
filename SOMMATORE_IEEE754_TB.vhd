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
-- testing subtraction and commutative propriety
	
		X   <= "01000100101111100011011110101110"; -- 1521.739990234375
		Y   <= "01000100101001101010010011001101"; -- 1333.1500244140625
		SUB <= '0';
		
		-- output should be 01000101001100100110111000111110 (2854.89013671875) ~ 1160932926

-- special numbers
	-- infinity

		wait for 30 ns;			-- inf + inf
				
			X <= "01111111100000000000000000000000"; -- +inf
			Y <= "01111111100000000000000000000000"; -- +inf
			SUB <= '0';
			-- output should be 01111111100000000000000000000000 (+inf) ~ 2139095040

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
      wait;
   end process;

end;