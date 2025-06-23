entity Decoder is
port(
  a1,a2,a3,a4: in bit;
  s0,s1,s2,s3,s4,s5,s6: out bit
);
end Decoder;

architecture behav of Decoder is
begin
s0 <= not((not a4 and not a3 and not a1) or
      (a4 and not a3 and not a2) or
      (not a4 and a3 and a2 ) or
      (not a4 and not a3 and a2 and a1) or
      (not a4 and a3 and not a2 and a1));

s1 <= not((not a4 and not a3 and not a2) or
      (not a4 and not a3 and a2) or
      (a4 and not a3 and not a2) or
      (not a4 and a3 and not a2 and not a1) or
      (not a4 and a3 and a2 and a1));

s2 <= not((not a4 and not a3 and not a2) or
      (not a4 and a3 and  not a2) or
      (not a4 and a3 and a2) or
      (a4 and not a3 and not a2) or
      (not a4 and not a3 and a2 and a1));

s3 <= not((not a4 and not a3 and not a1 ) or
      (a4 and not a3 and not a2) or
      (not a4 and not a3 and a2 and a1 ) or
      (not a4 and a3 and not a2 and a1 ) or
      (not a4 and a3 and a2 and not a1));


s4 <= not((not a4 and a2 and not a1) or
      (not a3 and not a2 and not a1));

s5 <= not((not a4 and not a3 and not a2 and not a1)
   or (not a4 and a3 and not a2 and not a1)        
   or (not a4 and a3 and not a2 and a1)              
   or (not a4 and a3 and a2 and not a1)          
   or (a4 and not a3 and not a2 and not a1)      
   or (a4 and not a3 and not a2 and a1));        

s6 <= not((not a4 and not a3 and a2) or      
      (not a4 and a3 and not a2) or      
      (a4 and not a3 and not a2) or      
      (not a4 and a3 and a2 and not a1));
end architecture behav;