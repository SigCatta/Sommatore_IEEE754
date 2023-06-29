
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity NORMALIZER is
    port(
    X       :	 in  std_logic_vector(23 downto 0);   -- mantissa of the sum already complemented
    EXP     :  in  std_logic_vector(7 downto 0);
    C       :	 in  std_logic; -- overflow of the sum that determinate if the mantissa has to be shifted left or right
    NEWMANTX:  out  std_logic_vector(22 downto 0); -- new mantissa of the result shifted and without the first 1 
    NEWEXP  :  out  std_logic_vector(7 downto 0) -- new exponent depending on the shift
	);
end NORMALIZER;

architecture Behavioral of NORMALIZER is
  component MUX is -- check if the 25th bit is 1 or 0 to shift right or left
     generic(width : integer:= 5);
     port( 
          X    : in  std_logic_vector (width - 1 downto 0);
          Y    : in  std_logic_vector (width - 1 downto 0);
          S    : in  std_logic;
          Z    : out std_logic_vector (width - 1 downto 0)
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

    component NORMALIZED_LEFT is
      port(
        X         :  in  std_logic_vector(23 downto 0);   -- mantissa of the sum already complemented
        EXP       :  in  std_logic_vector(7 downto 0);
        SHIFTALL1 :	 out  std_logic; -- overflow of the sum that determinate if the mantissa has to be shifted left or right
        MANTX_LEFT:  out  std_logic_vector(22 downto 0); -- new mantissa of the result shifted and without the first 1 
        EXP_LEFT  :  out  std_logic_vector(7 downto 0) -- new exponent depending on the shift
      );
end component;        
 

signal MANTLEFT    : std_logic_vector(22 downto 0);  -- mantix output of the left shift
signal MANTRIGHT   : std_logic_vector(22 downto 0);  -- manitx output of the right shift
signal EXPLEFT     : std_logic_vector(7 downto 0);   -- exp output of the left shift
signal EXPRIGHT    : std_logic_vector(7 downto 0);   -- exp output of the right shift  (exp+1)
signal EXPRES      : std_logic_vector(7 downto 0);   -- the correct exponent between EXPRIGHT and EXPLEFT
signal SHIFTALL1   : std_logic; -- indicates if the result of the sum was 0


begin
   
    MANTRIGHT <= X(23 downto 1);
    
    U1: NORMALIZED_LEFT  -- elaborate mantissa and exponent when has to be shifted left 
      port map(
        X => X,
        EXP => EXP,
        SHIFTALL1 => SHIFTALL1,
        MANTX_LEFT => MANTLEFT,
        EXP_LEFT => EXPLEFT
      );
    
    U2: PA  -- to add 1 at the exponent when the shift has to be right
      port map(
        X   => EXP(7 downto 0),
        CIN => '1',
        S   => EXPRIGHT(7 downto 0)
      );
    
    U3: MUX   -- choose the mantissa depending on 25th bit
      generic map(width => 23)
      port map(
        X => MANTLEFT(22 downto 0),
        Y => MANTRIGHT(22 downto 0),
        S => C,
        Z => NEWMANTX(22 downto 0)
      );
      
    U4: MUX   -- choose the exponent depending on 25th bit
      generic map(width => 8)
      port map(
        X => EXPLEFT(7 downto 0),
        Y => EXPRIGHT(7 downto 0),
        S => C,
        Z => EXPRES(7 downto 0)
      );   
		
    U5: MUX   -- the exponent has to be zero if the result of the sum between the mantissas was zero
      generic map(width => 8)
      port map(
        X => EXPRES,
        Y => "00000000",
        S => SHIFTALL1,
        Z => NEWEXP
      ); 
      
     
end Behavioral;

