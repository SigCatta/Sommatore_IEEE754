
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 

ENTITY SNC_TB IS
END SNC_TB;
 
ARCHITECTURE behavior OF SNC_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT SNC
    PORT(
         PINF : IN  std_logic;
         NINF : IN  std_logic;
         NAN : IN  std_logic;
         SIGN : IN  std_logic;
         EXP : IN  std_logic_vector(7 downto 0);
         MAN : IN  std_logic_vector(22 downto 0);
         Z : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal PINF : std_logic := '0';
   signal NINF : std_logic := '0';
   signal NAN : std_logic := '0';
   signal SIGN : std_logic := '0';
   signal EXP : std_logic_vector(7 downto 0) := (others => '0');
   signal MAN : std_logic_vector(22 downto 0) := (others => '0');

 	--Outputs
   signal Z : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 

 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: SNC PORT MAP (
          PINF => PINF,
          NINF => NINF,
          NAN => NAN,
          SIGN => SIGN,
          EXP => EXP,
          MAN => MAN,
          Z => Z
        );
process
   begin		
      wait for 100 ns;
      PINF <= '1';   -- there's an infinity 
      NINF <= '0';
      NAN <= '0';
      SIGN <= '1';
      EXP <= "10101111";
      MAN <= "00000101011111001010010";	
      
      -- output should be
      wait for 30 ns;

      PINF <= '1';
      NINF <= '0';
      NAN <= '1';
      SIGN <= '1';
      EXP <= "10111111";
      MAN <= "00000101011111001010010";	

      -- output should be NaN
      wait for 30 ns;

      PINF <= '0';
      NINF <= '0';
      NAN <= '0';
      SIGN <= '0';
      EXP <= "11111111";
      MAN <= "00000101011111001010010";

      -- output should be inf

      wait;
   end process;

END;

