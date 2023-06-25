library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SOMMATORE_NOPIPELINE is
	port(
		X   : in  std_logic_vector(31 downto 0);
		Y   : in  std_logic_vector(31 downto 0);
		SUB : in  std_logic;
		Z   : out std_logic_vector(31 downto 0);
		
		CLK : in std_logic;
		RST : in std_logic
	);
end SOMMATORE_NOPIPELINE;

architecture Behavioral of SOMMATORE_NOPIPELINE is

	signal rIN_X   : std_logic_vector(31 downto 0);
	signal rIN_Y   : std_logic_vector(31 downto 0);
	signal rIN_SUB : std_logic;

	
	component DENORMALIZE is
		port(
			X      : in  std_logic_vector(31 downto 0);
			Y      : in  std_logic_vector(31 downto 0);
			SUB    : in  std_logic;
			DNORMX : out std_logic_vector(24 downto 0);
			DNORMY : out std_logic_vector(24 downto 0);
			EXP    : out std_logic_vector(7 downto 0)
		);
	end component;
	
	signal DNORMX : std_logic_vector(24 downto 0);
	signal DNORMY : std_logic_vector(24 downto 0);
	signal EXP    : std_logic_vector(7 downto 0);
	
	
	signal r1_DNORMX : std_logic_vector(24 downto 0);
	signal r1_DNORMY : std_logic_vector(24 downto 0);
	signal r1_EXP    : std_logic_vector(7 downto 0);
	signal r2_EXP    : std_logic_vector(7 downto 0);

	
	
	component CLU is
		port(
			X    : in  std_logic_vector(31 downto 0);
			Y    : in  std_logic_vector(31 downto 0);
			SUB  : in  std_logic;
			PINF : out std_logic;
			NINF : out std_logic;
			NAN  : out std_logic
		);
	end component;
		
	signal PINF : std_logic;
	signal NINF : std_logic;
	signal NAN  : std_logic;
		
	signal r1_PINF : std_logic;
	signal r1_NINF : std_logic;
	signal r1_NAN  : std_logic;
	signal r2_PINF : std_logic;
	signal r2_NINF : std_logic;
	signal r2_NAN  : std_logic;
	
	
	component DENORMALIZED_SUM is
		port(
			X    : in  std_logic_vector(24 downto 0);
			Y    : in  std_logic_vector(24 downto 0);
			M    : out std_logic_vector(23 downto 0);
			SIGN : out std_logic;
			INCR : out std_logic
		);
	end component;
	
	signal M    : std_logic_vector(23 downto 0);
	signal SIGN : std_logic;
	signal INCR : std_logic;
	
	signal r2_M    : std_logic_vector(23 downto 0);
	signal r2_SIGN : std_logic;
	signal r2_INCR : std_logic;


	component NORMALIZE is
		port(
			SIGN : in std_logic;
			EXP  : in std_logic_vector(7 downto 0);
			MAN  : in std_logic_vector(23 downto 0);
			INCR : in std_logic;
			PINF : in std_logic;
			NINF : in std_logic;
			NAN  : in std_logic;
			Z    : out std_logic_vector(31 downto 0)
		);
	end component;

	signal OUTPUT : std_logic_vector(31 downto 0);
	signal rOUT_Z : std_logic_vector(31 downto 0);
begin

	U1: DENORMALIZE
		port map(
			X      => rIN_X,
			Y      => rIN_Y,
			SUB    => rIN_SUB,
			DNORMX => DNORMX,
			DNORMY => DNORMY,
			EXP    => EXP
		);
		
	U2: CLU
		port map(
			X    => rIN_X,
			Y    => rIN_Y,
			SUB  => rIN_SUB,
			PINF => PINF,
			NINF => NINF,
			NAN  => NAN
		);
		
	U3: DENORMALIZED_SUM
		port map(
			X    => r1_DNORMX,
			Y    => r1_DNORMY,
			M    => M,
			SIGN => SIGN,
			INCR => INCR
		);
		
		
	U4: NORMALIZE
		port map(
			SIGN => r2_SIGN,
			EXP  => r2_EXP,
			MAN  => r2_M,
			INCR => r2_INCR,
			PINF => r2_PINF,
			NINF => r2_NINF,
			NAN  => r2_NAN,
			Z    => OUTPUT
		);

	Z <= rOUT_Z;

	CLOCK: process(CLK, RST)
		begin
			if (RST = '1') then
			-- INPUT registers
				rIN_X   <= (others => '0');
				rIN_Y   <= (others => '0');
				rIN_SUB <= '0';
				
			-- DENORMALIZE registers
				r1_DNORMX <= (others => '0');
				r1_DNORMY <= (others => '0'); 
				r1_EXP    <= (others => '0');
				r2_EXP    <= (others => '0');

			-- CLU registers
				r1_PINF <= '0';
				r1_NINF <= '0';
				r1_NAN  <= '0';
				r2_PINF <= '0';
				r2_NINF <= '0';
				r2_NAN  <= '0';

			-- SUM registers
				r2_M    <= (others => '0');
				r2_SIGN <= '0';
				r2_INCR <= '0';

			-- NORMALIZE registers (output)
				rOUT_Z <= (others => '0');

			else
				if (CLK'EVENT and CLK = '1') then
				-- INPUT registers
					rIN_X   <= X;
					rIN_Y   <= Y;
					rIN_SUB <= SUB;

				-- DENORMALIZE registers
					r1_DNORMX <= DNORMX;
					r1_DNORMY <= DNORMY; 
					r1_EXP    <= EXP;
					r2_EXP    <= r1_EXP;

				-- CLU registers
					r1_PINF <= PINF;
					r1_NINF <= NINF;
					r1_NAN  <= NAN;
					r2_PINF <= r1_PINF;
					r2_NINF <= r1_NINF;
					r2_NAN  <= r1_NAN;
					
				-- SUM registers
					r2_M    <= M;
					r2_SIGN <= SIGN;
					r2_INCR <= INCR;
				
				-- NORMALIZE registers (output)
					rOUT_Z <= OUTPUT;
					
				end if;
			end if;
		end process;
		
end Behavioral;

