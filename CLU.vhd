library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CLU is
	port(
		X:      in	 std_logic_vector(31 downto 0);
		Y:      in	 std_logic_vector(31 downto 0);
		SUB:    in	 std_logic;
		PINF:   out std_logic;		-- 1 if the result is positive infinity
		NINF:   out std_logic;		-- 1 if the result is negative infinity
		NAN:    out std_logic
	);
end CLU;

architecture Behavioral of CLU is

	signal XEXP255: std_logic;
	signal XMANN0:  std_logic;		-- 1 if the x's mantissa is not 0
	signal XNAN:    std_logic;
	signal XINF:    std_logic_vector(1 downto 0);		-- 01 if +inf, 11 if -inf ~ if the second bit is 0, X is not inf
	
	signal YEXP255: std_logic;
	signal YMANN0:  std_logic;		-- 1 if the y's mantissa is not 0
	signal YNAN:    std_logic;
	signal YINF:    std_logic_vector(1 downto 0);		-- 01 if +inf, 11 if -inf ~ if the second bit is 0, Y is not inf
begin

	XEXP255 <= ((X(30) and X(29)) and (X(28) and X(27))) and ((X(26) and X(25)) and (X(24) and X(23)));
	XMANN0  <= (((X(22) or X(21)) or (X(20) or X(19))) or ((X(18) or X(17)) or (X(16) or X(15)))) or (((X(14) or X(13)) or (X(12) or X(11))) or ((X(10) or X(9)) or (X(8) or X(7)))) or (((X(6) or X(5)) or (X(4) or X(3))) or ((X(2) or X(1)) or (X(0))));
	YEXP255 <= ((Y(30) and Y(29)) and (Y(28) and Y(27))) and ((Y(26) and Y(25)) and (Y(24) and Y(23)));
	YMANN0  <= (((Y(22) or Y(21)) or (Y(20) or Y(19))) or ((Y(18) or Y(17)) or (Y(16) or Y(15)))) or (((Y(14) or Y(13)) or (Y(12) or Y(11))) or ((Y(10) or Y(9)) or (Y(8) or Y(7)))) or (((Y(6) or Y(5)) or (Y(4) or Y(3))) or ((Y(2) or Y(1)) or (Y(0))));
	
	-- set INF
	XINF <= X(31) & (XEXP255 and (not XMANN0));
	YINF <= (Y(31) xor SUB) & (YEXP255 and (not YMANN0));
	
	-- result is +inf if the operands are: inf + inf, inf + n or n + inf 		~ result optimized with karnaugh map
	PINF <= (( (not XINF(1)) and XINF(0) ) and ( (not YINF(1)) or (not YINF(0)) )) or (( (not YINF(1)) and YINF(0) ) and ( (not XINF(1)) or (not XINF(0)) ));
	
	-- result is -inf if the operands are: -inf -inf, -inf +n or n -inf			~ result optimized with karnaugh map
	NINF <= (( XINF(1) and XINF(0) ) and ( YINF(1) or (not YINF(0)) )) or ((  YINF(1) and YINF(0) ) and ( XINF(1) or (not XINF(0)) ));
		
	-- set NAN
	XNAN <= XEXP255 and XMANN0;
	YNAN <= YEXP255 and YMANN0;
	NAN  <= (XNAN or YNAN) or ((XINF(1) xor YINF(1)) and (XINF(0) and YINF(0)) );	-- NAN is 1 either x or y are NAN or if x and y are opposite infinities
	
end Behavioral;

