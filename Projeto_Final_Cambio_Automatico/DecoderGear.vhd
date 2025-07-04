library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity DecoderGear is
port(
  G1,G0: in std_logic;
  s0,s1,s2,s3,s4,s5,s6: out std_logic
);
end DecoderGear;

architecture behav of DecoderGear is
begin
s0 <= not(not G1 and not G0);
s1 <= not((not G1 and not G0) or (G1 and G0));
s2 <= not((G1 and G0) or (G1 and not G0)) ;
s3 <= not(G1 and G0);
s4 <= not((not G1 and not G0) or (not G1 and G0) or (G1 and not G0) or (G1 and G0));
s5 <= not(not G1 and not G0);
s6 <= not((not G1 and not G0) or (not G1 and G0) or (G1 and not G0) or (G1 and G0));
end architecture behav;
