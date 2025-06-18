entity Decode_Comp is
   port(a4,a3,a2,a1, E: in bit;
   s0,s1,s2,s3,s4,s5,s6: out bit);
end Decode_Comp;
 architecture behav of Decode_Comp is
   signal out_aux:BIT_VECTOR(6 DOWNTO 0);
   signal in_aux:BIT_VECTOR(4 DOWNTO 0);
 begin
 in_aux<= E & a4 & a3 & a2 & a1;--Usado para concatenar os sinais de entrada
 with in_aux select
   out_aux<="1000000" when "10000",
            "1111001" when "10001",
            "0100100" when "10010",
            "0110000" when "10011",
            "0011001" when "10100";
            "0010010" when "10101";
            "0000010" when "10110";
            "1111000" when "10111";
            "0000000" when "11000";
            "0010000" when "11001";
            "1111111" when others;
 s0<=out_aux(0);
 s1<=out_aux(1);
 s2<=out_aux(2);
 s3<=out_aux(3);
 s4<=out_aux(4);
 s5<=out_aux(5);
 s6<=out_aux(6);
 end behav;