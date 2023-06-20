
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity NORMALIZER is
    port(
		X:	  in  std_logic_vector(23 downto 0);   -- mantissa of the sum already complemented
    EXP:  in  std_logic_vector(7 downto 0);
    C:	  in  std_logic; -- overflow of the sum that determinate if the mantissa has to be shifted left or right
    NEWMANTX: out  std_logic_vector(22 downto 0); -- new mantissa of the result shifted and without the first 1 
    NEWEXP: out  std_logic_vector(7 downto 0) -- new exponent depending on the shift
	);
end NORMALIZER;

architecture Behavioral of NORMALIZER is
  component MUX is -- check if the 25th bit is 1 or 0 to shift right or left
     generic( width : integer:= 5);
     port( 
          X    : in  std_logic_vector (width - 1 downto 0);
          Y    : in  std_logic_vector (width - 1 downto 0);
          S    : in  std_logic;
          Z    : out std_logic_vector (width - 1 downto 0)
      );
   end component;
   
    component PRI_ENC is   -- to determinate how much the mantissa has to be shifted left when the 25th bit is 0
        port(
            X: in  std_logic_vector(23 downto 0);
            Y: out std_logic_vector(4 downto 0)
        );
    end component;

    component SHIFTER_LEFT is	-- when 25th bit is 0 and has to be shifted left			
    port(
      X: in  std_logic_vector(23 downto 0);
      S: in  std_logic_vector(7 downto 0);
      Y: out std_logic_vector(22 downto 0)
    );
end component;
    
    component PA is  -- to add 1 at the exponent when the 25th bit is 1
    generic(width : integer := 8);
      port(
        X    : in  std_logic_vector (width - 1 downto 0);
        CIN  : in  std_logic;
        S    : out std_logic_vector (width - 1 downto 0);
        COUT : out std_logic
    );
end component;  

    component RCA is  -- to subtract a number to the exponent when 25th bit is 0
      generic(width: integer := 9);
      port(
          X    : in  std_logic_vector (width - 1 downto 0);
          Y    : in  std_logic_vector (width - 1 downto 0);
          CIN  : in  std_logic;
          S    : out std_logic_vector (width - 1 downto 0);
          COUT : out std_logic
      );
end component;  

signal  NUMB_SHIFT: std_logic_vector(7 downto 0);  -- out of the priority encoder
signal  MANTLEFT :  std_logic_vector(22 downto 0);  -- mantix output of the left shift
signal  MANTLEFTINT :  std_logic_vector(22 downto 0);  -- mantix output of the left shift intermedie
signal  MANTRIGHT :  std_logic_vector(22 downto 0);  -- manitx output of the right shift
signal  EXPLEFT:  std_logic_vector(7 downto 0);  -- exp output of the left shift
signal  EXPRIGHT:  std_logic_vector(7 downto 0);  -- exp output of the right shift  (exp+1)
signal  ZERO: std_logic -- to know if the results is approx to zero

begin
    U1: PRI_ENC  -- determinate how much i have to shift left
      port map(
        X => X(23 downto 0),
        Y => NUMB_SHIFT(7 downto 0)
      );

    U2: SHIFTER_LEFT  -- shift the mantissa left of n bit  
      port map(
        X => X(23 downto 0),
        S => NUMB_SHIFT(7 downto 0),
        Y => MANTLEFTINT(22 downto 0)
      );  
    
    U3: RCA   --subtract to the exponent n when i have shifted left, if the result of the subtraction is negative the mantix is all0
      port map(
        X => '0'& EXP(7 downto 0),
        Y => '1' & not( NUMB_SHIFT(7 downto 0)),
        CIN => '1',
        S => EXPLEFT(7 downto 0),
        COUT => ZERO
      );
    
    MANTRIGHT <= X(23 downto 1);
    
    U4: PA  -- to add 1 at the exponent when the shift has to be right
      port map(
        X => EXP(7 downto 0),
        CIN => '1',
        S => EXPRIGHT(7 downto 0)
      );
    
    U5: MUX   -- choose the mantissa depending on 25th bit
      generic map(width => 23)
      port map(
        X => MANTLEFT(22 downto 0),
        Y => MANTRIGHT(22 downto 0),
        S => C,
        Z => NEWMANTX(22 downto 0)
      );
      
    U6: MUX   -- choose the exponent depending on 25th bit
      generic map(width => 8)
      port map(
        X => EXPLEFT(7 downto 0),
        Y => EXPRIGHT(7 downto 0),
        S => C,
        Z => NEWEXP(7 downto 0)
      );  
      
    U7: MUX  -- to know if the mantleft is all0s or not
      generic map(width => 23)
      port map(
        X => MANTLEFTINT(22 downto 0),
        Y => "00000000000000000000000",
        S => ZERO,
        Z => MANTLEFT(22 downto 0)   
      );  
     

end Behavioral;

