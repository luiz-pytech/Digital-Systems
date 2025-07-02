entity DecoderGear is
port(
  G1,G0: in bit;
  s0,s1,s2,s3,s4,s5,s6: out bit
);
end DecoderGear;

architecture behav of DecoderGear is
begin
s0 <= not(not G1 and not G0);
s1 <= not((not G1 and not G0) or (G1 and G0));
s2 <= G1;
s3 <= not(G1 and G0);
s4 <= not G1 or G1;
s5 <= not(not G1 and not G0);
s6 <= not G1 or G1;
end architecture behav;
