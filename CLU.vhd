library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CLU is
	port(
		X    : in  std_logic_vector(31 downto 0);
		Y    : in  std_logic_vector(31 downto 0);
		SUB  : in  std_logic;
		PINF : out std_logic;		-- 1 if the result is positive infinity
		NINF : out std_logic;		-- 1 if the result is negative infinity
		NAN  : out std_logic			-- 1 if the result is NaN
	);
end CLU;

architecture Behavioral of CLU is

	signal XEXP255 : std_logic;
	signal XMAN0   : std_logic;		-- 1 if the x's mantissa is 0
	signal XNAN    : std_logic;
	signal XINF    : std_logic_vector(1 downto 0);		-- 01 if +inf, 11 if -inf ~ if the second bit is 0, X is not inf
	
	signal YEXP255 : std_logic;
	signal YMAN0   : std_logic;		-- 1 if the y's mantissa is 0
	signal YNAN    : std_logic;
	signal YINF    : std_logic_vector(1 downto 0);		-- 01 if +inf, 11 if -inf ~ if the second bit is 0, Y is not inf
	
begin

	XEXP255 <= '1' when X(30 downto 23) = "11111111" else '0';
	XMAN0   <= '1' when X(22 downto 0) = "00000000000000000000000" else '0';
	YEXP255 <= '1' when Y(30 downto 23) = "11111111" else '0';
	YMAN0   <= '1' when Y(22 downto 0) = "00000000000000000000000" else '0';
	
	-- set INF
	XINF <= X(31) & (XEXP255 and XMAN0);
	YINF <= (Y(31) xor SUB) & (YEXP255 and YMAN0);
	
	-- result is +inf if the operands are: inf + inf, inf + n or n + inf
	PINF <= '1' when ((XINF = "01") and (YINF = "01")) or ((XINF = "01") and (YINF /= "11")) or ((XINF /= "11") and (YINF = "01")) else '0';
	
	-- result is -inf if the operands are: -inf -inf, -inf +n or n -inf
	NINF <= '1' when ((XINF = "11") and (YINF = "11")) or ((XINF = "11") and (YINF /= "01")) or ((XINF /= "01") and (YINF = "11")) else '0';
		
	-- set NAN
	XNAN <= XEXP255 and (not XMAN0);
	YNAN <= YEXP255 and (not YMAN0);
	NAN  <= (XNAN or YNAN) or ((XINF(1) xor YINF(1)) and (XINF(0) and YINF(0)) );	-- NAN is if 1 either x or y are NAN or if x and y are opposite infinities
	
end Behavioral;

