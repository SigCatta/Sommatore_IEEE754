
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX2 is
    port(
        A : in std_logic;
        B : in std_logic;
        S : in std_logic;
        Z : out std_logic
    );
end MUX2;

architecture Behavioral of MUX2 is

begin
    Z <= ( A and (not S) ) or ( B and S);
end Behavioral;
