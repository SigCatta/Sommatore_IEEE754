library ieee;
use ieee.std_logic_1164.ALL;

entity ABSDIFF is
    generic(width: integer);
    port(
        X : in  std_logic_vector(width - 1 downto 0);
        Y : in  std_logic_vector(width - 1 downto 0);
        Z : out std_logic_vector(width - 1 downto 0);
        C : out std_logic                              -- 1 if y is greater the x, 0 otherwise 
    );
end ABSDIFF;

architecture STRUCT of ABSDIFF is
    component RCA is        -- subtracts X and Y
		generic(width : integer := width);
		port(
			X    : in  std_logic_vector(width - 1 downto 0);
			Y    : in  std_logic_vector(width - 1 downto 0);
			CIN  : in  std_logic;
			S    : out std_logic_vector(width - 1 downto 0);
			COUT : out std_logic
		);
	end component;
	
	component PA is         -- turns S to -S
		generic(width : integer := width);
		port(
			X    : in  std_logic_vector(width - 1 downto 0);
			CIN  : in  std_logic;
			S    : out std_logic_vector(width - 1 downto 0);
			COUT : out std_logic
		);
    end component;

    component MUX is       -- selects Si if positive, -Si otherwise
        generic(width : integer := width);
        port( 
            X : in  std_logic_vector(width - 1 downto 0);        -- S
            Y : in  std_logic_vector(width - 1 downto 0);        -- -S
            S : in  std_logic;        -- 1 if y is greater the x, 0 otherwise 
            Z : out std_logic_vector(width - 1 downto 0)
        );
    end component;
    
	signal S    : std_logic_vector(width - 1 downto 0);     -- Ex - Ey
	signal NOTS : std_logic_vector(width - 1 downto 0);     -- Ey - Ex
	signal COUT : std_logic;

begin

    U1: RCA port map(
        X => X,
        Y => not Y,
        CIN => '1',
        S => S,
        COUT => COUT           -- if the number is positive C will be 0, 1 otherwise
    );
    -- we have to take the opposite of COUT because the 'sing' bit would be the 9'th, therefore it's not present
    -- this means that if the carry of the last addition is 1, it should be added to the 'sign' bit, which is always 1
    -- therefore, since there always is a "9'th bit" with the value of 1, the real carry is the opposite of what is computed

	C <= not COUT;

	U2: PA port map(
		X => not S,
		CIN => '1',
		S => NOTS
	);
	 
	U3: MUX port map(	 
        X => S,
        Y => NOTS,
        S => not COUT,          -- same as C out
        Z => Z
	);

end STRUCT;
