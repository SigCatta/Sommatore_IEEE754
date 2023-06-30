
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity NORMALIZER is
    port(
    X        :	in  std_logic_vector(23 downto 0);		-- mantissa of the sum already complemented
    EXP      : in  std_logic_vector(7 downto 0);
    C        :	in  std_logic;								-- overflow of the sum that determinate if the mantissa has to be shifted left or right
    NEWMANTX : out std_logic_vector(22 downto 0);		-- new mantissa of the result shifted and without the first 1 
    NEWEXP   : out std_logic_vector(7 downto 0)		-- new exponent depending on the shift
	);
end NORMALIZER;

architecture Behavioral of NORMALIZER is
  component MUX is -- check if the 25th bit is 1 or 0 to shift right or left
     generic(width : integer);
     port( 
          X : in  std_logic_vector (width - 1 downto 0);
          Y : in  std_logic_vector (width - 1 downto 0);
          S : in  std_logic;
          Z : out std_logic_vector (width - 1 downto 0)
      );
   end component;
    
    component PA is  -- to add 1 at the exponent when the 25th bit is 1
    generic(width : integer);
      port(
        X    : in  std_logic_vector (width - 1 downto 0);
        CIN  : in  std_logic;
        S    : out std_logic_vector (width - 1 downto 0);
        COUT : out std_logic
    );
end component;  

    component NORMALIZED_LEFT is
      port(
        X          : in  std_logic_vector(23 downto 0);	-- mantissa of the sum already complemented
        EXP        : in  std_logic_vector(7 downto 0);
        MANTX_LEFT : out std_logic_vector(22 downto 0);	-- new mantissa of the result shifted and without the first 1 
        EXP_LEFT   : out std_logic_vector(7 downto 0) 	-- new exponent depending on the shift
      );
end component;        
 

signal MANTLEFT    : std_logic_vector(22 downto 0);  -- mantix output of the left shift
signal MANTRIGHT   : std_logic_vector(22 downto 0);  -- manitx output of the right shift
signal EXPLEFT     : std_logic_vector(7 downto 0);   -- exp output of the left shift
signal EXPRIGHT    : std_logic_vector(7 downto 0);   -- exp output of the right shift  (exp+1)


begin
   
    MANTRIGHT <= X(23 downto 1);
    
    U1: NORMALIZED_LEFT  -- elaborate mantissa and exponent in case of a left shift
      port map(
        X          => X,
        EXP        => EXP,
        MANTX_LEFT => MANTLEFT,
        EXP_LEFT   => EXPLEFT
      );
    
    U2: PA  -- add 1 at the exponent in case the shift has to be right
		generic map(width => 8)
      port map(
        X   => EXP,
        CIN => '1',
        S   => EXPRIGHT
      );
    
    U3: MUX   -- choose the mantissa depending on the sum's 25th bit
      generic map(width => 23)
      port map(
        X => MANTLEFT,
        Y => MANTRIGHT,
        S => C,
        Z => NEWMANTX
      );
      
    U4: MUX   -- choose the exponent depending on the sum's 25th bit
      generic map(width => 8)
      port map(
        X => EXPLEFT,
        Y => EXPRIGHT,
        S => C,
        Z => NEWEXP
      );   
			
      
     
end Behavioral;

