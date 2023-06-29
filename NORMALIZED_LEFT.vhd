library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity NORMALIZED_LEFT is
    port(
    X:	  in  std_logic_vector(23 downto 0);   -- mantissa of the sum already complemented
    EXP:  in  std_logic_vector(7 downto 0);
    SHIFTALL1:	  out  std_logic; -- overflow of the sum that determinate if the mantissa has to be shifted left or right
    MANTX_LEFT: out  std_logic_vector(22 downto 0); -- new mantissa of the result shifted and without the first 1 
    EXP_LEFT: out  std_logic_vector(7 downto 0) -- new exponent depending on the shift
	);
end NORMALIZED_LEFT;

architecture Behavioral of NORMALIZED_LEFT is

    component PRI_ENC is   -- to determinate how much the mantissa has to be shifted left when the 25th bit is 0
    port(
        X: in  std_logic_vector(23 downto 0);
        Y: out std_logic_vector(7 downto 0)
    );
end component;

    component SHIFTER_LEFT is	-- when 25th bit is 0 and has to be shifted left			
    port(
      X: in  std_logic_vector(23 downto 0);
      S: in  std_logic_vector(7 downto 0);
      Y: out std_logic_vector(22 downto 0)
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
 
component MUX is -- check if the 25th bit is 1 or 0 to shift right or left
generic(width : integer);
port( 
     X    : in  std_logic_vector (width - 1 downto 0);
     Y    : in  std_logic_vector (width - 1 downto 0);
     S    : in  std_logic;
     Z    : out std_logic_vector (width - 1 downto 0)
 );
end component;

signal NUMB_SHIFT  : std_logic_vector(7 downto 0);   -- out of the priority encoder
signal MANTLEFTINT : std_logic_vector(22 downto 0);  -- mantix output of the left shift intermedie
signal EXPLEFTINT     : std_logic_vector(7 downto 0);   -- exp output of the left shift before checking all0s
signal ZERO        : std_logic; -- to know if the results is approx to zero

begin
 
    U1: PRI_ENC  -- determinate how much i have to shift left
    port map(
      X => X,
      Y => NUMB_SHIFT
    );   
    
    U2: SHIFTER_LEFT  -- shift the mantissa left of n bit  
    port map(
      X => X,
      S => NUMB_SHIFT,
      Y => MANTLEFTINT
    ); 

    U3: RCA   --subtract to the exponent n when i have shifted left, if the result of the subtraction is negative the mantix is all0
    port map(
      X => '0' & EXP,
      Y => '1' & not(NUMB_SHIFT),
      CIN => '1',
      S(7 downto 0) => EXPLEFTINT,
      S(8) => ZERO
    );

    U4: MUX    -- check if the exp has to be all0s
    generic map(width => 8)
    port map(
     X => EXPLEFTINT,
     Y => "00000000",
     S => ZERO,
     Z => EXP_LEFT 
    ); 

    U5: MUX  -- to know if the mantleft is all0s or not
      generic map(width => 23)
      port map(
        X => MANTLEFTINT,
        Y => "00000000000000000000000",
        S => ZERO,
        Z => MANTX_LEFT   
      );  

    SHIFTALL1 <= '1' when NUMB_SHIFT="11111111";  

end Behavioral;

