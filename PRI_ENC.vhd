library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
 
 
entity PRI_ENC is
    port(
        X: in  std_logic_vector(23 downto 0);
        Y: out std_logic_vector(7 downto 0)
    );
end PRI_ENC;
 
architecture rtl of PRI_ENC is
begin
    Y <= "00000000"  when X(23)='1'
         else "00000001"  when X(23 downto 22)="01"
         else "00000010"  when X(23 downto 21)="001"
         else "00000011"  when X(23 downto 20)="0001"
         else "00000100"  when X(23 downto 19)="00001"
         else "00000101"  when X(23 downto 18)="000001"
         else "00000110"  when X(23 downto 17)="0000001"
         else "00000111"  when X(23 downto 16)="00000001"
         else "00001000"  when X(23 downto 15)="000000001"
         else "00001001"  when X(23 downto 14)="0000000001"
         else "00001010"  when X(23 downto 13)="00000000001"
         else "00001011"  when X(23 downto 12)="000000000001"
         else "00001100"  when X(23 downto 11)="0000000000001"
         else "00001101"  when X(23 downto 10)="00000000000001"
         else "00001110"  when X(23 downto 9)="000000000000001"
         else "00001111"  when X(23 downto 8)="0000000000000001"
         else "00010000"  when X(23 downto 7)="00000000000000001"
         else "00010001"  when X(23 downto 6)="000000000000000001"
         else "00010010"  when X(23 downto 5)="0000000000000000001"
         else "00010011"  when X(23 downto 4)="00000000000000000001"
         else "00010100"  when X(23 downto 3)="000000000000000000001"
         else "00010101"  when X(23 downto 2)="0000000000000000000001"
         else "00010110"  when X(23 downto 1)="00000000000000000000001"
         else "00010111"  when X(23 downto 0)="000000000000000000000001"
         else "11111111";
 
 
end rtl;

