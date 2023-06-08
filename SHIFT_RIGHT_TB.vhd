
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

 
entity SHIFT_RIGHT_TB is
end SHIFT_RIGHT_TB;
 
architecture behavior of SHIFT_RIGHT_TB is 
 
    component SHIFT_RIGHT
    port(
      X: in  std_logic_vector(23 downto 0);
      S: in  std_logic_vector(7 downto 0);
      Y: out std_logic_vector (23 downto 0)
       );
    end component;
    
    --Inputs
    signal X   : std_logic_vector(23 downto 0);
    signal S   : std_logic_vector(7 downto 0);
    --Outputs
    signal Y : std_logic_vector(23 downto 0);
begin
 
   UUT: SHIFT_RIGHT 
         port map (
               X => X,
               S => S,
               Y => Y
             );

 process
 begin		
          
       X <= "00000000000000000000000";
       S  <= "00000";

       wait for 100 ns;	

       X <= "111010101111100100101110010"; 
       S <= "11000";

       -- output should be 00000000000000000000000
          
       wait for 20 ns;
          
       X <= "01011101010101011110101"; 
       S <= "00010";

       -- output should be 00010111010101010111101
       wait;
       end process;

end;
