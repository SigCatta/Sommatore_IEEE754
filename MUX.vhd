library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX is
	 generic(width: integer);
    port(
        X : in  std_logic_vector (width - 1 downto 0);
        Y : in  std_logic_vector (width - 1 downto 0);
        S : in  std_logic;
        Z : out std_logic_vector (width - 1 downto 0)
    );
end MUX;

architecture Behavioral of MUX is

	component MUX2 is
		port(
			A : in  std_logic;
			B : in  std_logic;
			S : in  std_logic;
			Z : out std_logic
		);
	end component;

begin

	GEN: for I in 0 to width - 1 generate
		U: MUX2 port map(
			A => X(I),
			B => Y(I),
			S => S,
			Z => Z(I)
		);
	end generate;

end Behavioral;