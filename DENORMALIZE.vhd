library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DENORMALIZE is
	port(
		X      : in  std_logic_vector(31 downto 0);
		Y      : in  std_logic_vector(31 downto 0);
		SUB    : in  std_logic;
		DNORMX : out std_logic_vector(24 downto 0); -- sign + 24 bit mantissa (must add 1 to the mantissa as per standard)
		DNORMY : out std_logic_vector(24 downto 0); -- sign + 24 bit mantissa (must add 1 to the mantissa as per standard)
		EXP    : out std_logic_vector(7 downto 0)   -- the bigger expontnt
	);
end DENORMALIZE;

architecture Behavioral of DENORMALIZE is
	component MUX is
		generic(width : integer := 24);
		port( 
			X : in  std_logic_vector (width - 1 downto 0);
			Y : in  std_logic_vector (width - 1 downto 0);
			S : in  std_logic;
			Z : out std_logic_vector (width - 1 downto 0)
		);
   end component;
	 
	component SHIFT_RIGHT_V2 is				-- shifts the smallest number's mantissa
		port(
		  X : in  std_logic_vector(23 downto 0);
		  S : in  std_logic_vector(7 downto 0);
		  Y : out std_logic_vector(23 downto 0)
		);
	end component;
	 
	component C2C is								-- calculate the mantissa's 2's complement if necessary
		generic(width: integer := 25);				-- needs to have an extra sign bit
		port(
			N    : in  std_logic_vector (width - 1 downto 0);
			S    : in  std_logic;
			Z    : out std_logic_vector (width - 1 downto 0);
			COUT : out std_logic
		);
	end component;
	
	component ABSDIFF is							-- calculates the absolute difference of the exponents
		generic(width: integer := 8);
		port(
			X : in  std_logic_vector (width - 1 downto 0);
			Y : in  std_logic_vector (width - 1 downto 0);
			Z : out std_logic_vector (width - 1 downto 0);
			C : out std_logic
		);
	end component;
	
	component MUX2 is								-- selects the correct sign for the mantissas
		port(
			A : in  std_logic;
			B : in  std_logic;
			S : in  std_logic;
			Z : out std_logic
		);
	end component;


	signal EXPDIFF : std_logic_vector(7 downto 0);  -- absolute difference of the exponents
	signal M1      : std_logic_vector(23 downto 0); -- shorter number's mantissa
	signal SM1     : std_logic_vector(23 downto 0); -- shifted M1
	signal M2      : std_logic_vector(23 downto 0); -- larger number's mantissa
	signal S1      : std_logic;                     -- sign of SM1
	signal S2      : std_logic;                     -- sign of M2
	signal C       : std_logic;                     -- 1 if y > x, 0 otherwise



begin
	U1: ABSDIFF						-- calculates the absolute difference between the exponents
		port map(
			X => X(30 downto 23),		-- X's exponent
			Y => Y(30 downto 23),		-- Y's exponent
			Z => EXPDIFF,
			C => C
		);
	
	U2: SHIFT_RIGHT_V2				-- shifts the number with the smallest exponent by the difference to the absolute difference between the exponents
		port map(
			X => M1,
			S => EXPDIFF,
			Y => SM1
		);
		
	U3: MUX							-- gives the smaller number's mantissa to the shifter
		port map(
			X => '1' & Y(22 downto 0),			-- x > y (s = 0) ~ give x to the shifter
			Y => '1' & X(22 downto 0),			-- y > x (s = 1) ~ give y to the shifter
			S => C,
			Z => M1
		);
		
	U4: MUX							-- gives the larger number's mantissa to a conditonal 2's complement (C2C) module
		port map(
			X => '1' & X(22 downto 0),			-- y > x (s = 1)
			Y => '1' & Y(22 downto 0),			-- x > y (s = 0)
			S => C,
			Z => M2
		);
		
	U5: MUX						-- converts X to it's 1's complement if necessary
		generic map(width => 25)
		port map(
			X => '0' & SM1,
			Y => '1' & (not SM1),
			S => S1,
			Z => DNORMX
		);		

	U6: C2C							-- converts the larger number to its 2's complement if necessary 
		port map(
			N => '0' & M2,
			S => S2,
			Z => DNORMY
		);
		
	U7: MUX2						-- selects the correct sign for U5, the smaller number
		port map(
			A => Y(31) xor SUB,							-- C = 0, get sign for Y
			B => X(31),									-- C = 1, get sign for X
			S => C,
			Z => S1
		);
	
	U8: MUX2						-- selects the correct sign for U6, the bigger number
		port map(
			A => X(31),									-- C = 0, get sign for X
			B => Y(31) xor SUB,							-- C = 1, get sign for Y
			S => C,
			Z => S2
		);

	U9: MUX							-- selects the bigger exponent
		generic map(width => 8)
		port map(
			X => X(30 downto 23),
			Y => Y(30 downto 23),
			S => C,
			Z => EXP
		);

end Behavioral;

