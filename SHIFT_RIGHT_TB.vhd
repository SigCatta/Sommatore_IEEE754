
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

 
entity SHIFT_RIGHT_TB is
end SHIFT_RIGHT_TB;
 
architecture behavior of SHIFT_RIGHT_TB is 
 
    component SHIFT_RIGHT
    port(
      X: in  std_logic_vector (7 downto 0);
      S: in  std_logic_vector(2 downto 0);
      COUT: out std_logic_vector (7 downto 0);
       );
    end component;
    
    --Inputs
    signal X 	: std_logic_vector(7 downto 0);
    signal S   : std_logic_vector(2 downto 0);
    --Outputs
    signal COUT : std_logic_vector(7 downto 0);
begin
 
   UUT: SHIFT_RIGHT 
         generic map (width => 8)
         port map (
               X => X,
               S => S,
               COUT => COUT
             );

 process
 begin		
          
       X	 <= "00000000";
       S  <= "00000000";

       wait for 100 ns;	

       X	 <= "11100101"; 
       S	 <= "110";

       -- output should be 00000011
          
       wait for 20 ns;
          
       X	 <= "01011101"; 
       S <= "010";

       -- output should be 00010111
       wait;
       end process;

end;
