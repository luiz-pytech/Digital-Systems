entity DecoderGearD is
port(
  G2, G1,G0: in std_logic;
  s0,s1,s2,s3,s4,s5,s6: out std_logic
);
end DecoderGearD;

architecture behav of DecoderGearD is
begin
s0 <= (not G2 and not G1 and G0) or (G2 and not G1 and not G0);
s1 <= (G2 and not G1 and G0) or (G2 and G1 and not G0);
s2 <= not G2 and G1 and not G0;
s3 <= (not G2 and not G1 and G0) or (G2 and not G1 and not G0);
s4 <= not((not G2 and G1 and not G0) or (G2 and G1 and not G0));
s5 <= (not G2 and not G1 and G0) or (not G2 and G1 and not G0) or (not G2 and G1 and G0);
s6 <= not G2 and not G1 and G0;
end architecture behav;
