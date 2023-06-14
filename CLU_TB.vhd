library ieee;
use ieee.std_logic_1164.ALL;
 
entity CLU_TB is
end CLU_TB;
 
architecture behavior of CLU_TB is 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
   component CLU
	port(
		X:		in	 std_logic_vector(31 downto 0);
		Y:		in	 std_logic_vector(31 downto 0);
		SUB:	in	 std_logic;
		PINF: out std_logic;		-- 1 if +inf
		NINF: out std_logic;		-- 1 if -inf
		NAN:	out std_logic
	);
	end component;
    

   --Inputs
   signal X   : std_logic_vector(31 downto 0);
   signal Y	  : std_logic_vector(31 downto 0);
   signal SUB : std_logic;

 	--Outputs
   signal PINF : std_logic;
   signal NINF : std_logic;
   signal NAN  : std_logic;

begin
 
	-- Instantiate the Unit Under Test (UUT)
   UUT: CLU port map (
					X	  => X,
					Y	  => Y,
					SUB  => SUB,
					PINF => PINF,
					NINF => NINF,
					NAN  => NAN
				);
 

   -- Stimulus process
   process
   begin
	
		X <= "00000000000000000000000000000000";
		Y <= "00000000000000000000000000000000";
		SUB <= '0';
		wait for 100 ns;
		
		X <= "01111111100000000000000000000000";
		Y <= "00000000000000000000000000000000";
		SUB <= '0';
		-- PINF 1, NINF 0, NAN 0s
		
		wait for 20 ns;
		
		X <= "01111111100000000000000000000000";
		Y <= "11111111100000000000000000000000";
		SUB <= '0';
		-- PINF 0, NINF 0, NAN 1
		
		wait for 20 ns;
		
		X <= "01111111100000000000000000000000";
		Y <= "01111111100000000000000000000000";
		SUB <= '0';
		-- PINF 1, NINF 0, NAN 0
		
		wait for 20 ns;
		
		X <= "00000000011111111100000000000000"; -- positive number
		Y <= "11111111100000000000000000000000";
		SUB <= '0';
		-- PINF 0, NINF 1, NAN 0
		
		wait;

   end process;

end;