
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
          
       X <= "000000000000000000000000";
       S  <= "00000";

       wait for 100 ns;	

       X <= "1110101011111001001011100101"; 
       S <= "11000";

       -- output should be 000000000000000000000000
          
       wait for 20 ns;
          
       X <= "010111010101010111101001"; 
       S <= "00010";

       -- output should be 000101110101010101111010
       wait;
       end process;

end;
