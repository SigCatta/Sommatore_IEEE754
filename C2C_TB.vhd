library ieee;
use ieee.std_logic_1164.ALL;
 
entity C2C_TB is
end C2C_TB;
 
architecture behavior OF C2C_TB IS 
 
 
   component C2C
      generic(width: integer);      -- using a 8 bit C2C
         port(
            N    : in  std_logic_vector(7 downto 0);
            S    : in  std_logic;
            Z    : out std_logic_vector(7 downto 0);
            COUT : out std_logic
         );
   end component;
    

   --Inputs
   signal N : std_logic_vector(7 downto 0);
   signal S : std_logic;

 	--Outputs
   signal Z    : std_logic_vector(7 downto 0);
   signal COUT : std_logic;
  
begin
 
	-- Instantiate the Unit Under Test (UUT)
	UUT: C2C
	generic map(width => 8)	
   port map(
      N    => N,
      S    => S,
      Z    => Z,
      COUT => COUT 
   );

   process
   begin		
   
      N <= "00000000";
      S <= '0';

      wait for 100 ns;

      N <= "01010101"; -- should not change
      S <=  '0';

      wait for 20 ns;

      N <= "01010101"; -- should return 2's complement: 10101011
      S <=  '1';
		
      wait for 20 ns;

      N <= "00000000"; -- should return 0
      S <=  '1';
		
      wait for 20 ns;

      N <= "00000000"; -- should return 0
      S <=  '0';

      wait;
   end process;

end;