entity bitsContador is
port(
A,B,C: in bit;
S1, S2: out bit
);
end bitsContador;

architecture behav of bitsContador is
    signal and_bc: bit;
    signal xor_bc: bit;
    signal and_s1: bit;
    signal xor_s2: bit;

    signal s1_final: bit;

component PortaAnd is
port(en1,en2 : in bit;
saida_and : out bit
);
end component;

component PortaOr is
port(input1,input2 : in bit;
saida_or : out bit
);
end component;

component PortaXor is
port(entXor1,entXor2 : in bit;
saida_xor : out bit
);
end component;
begin
   u1: PortaAnd port map(en1 => B, en2 => C, saida_and => and_bc);
   u2: PortaXor port map(entXor1 => B, entXor2 => C, saida_xor => xor_bc);
   u3: PortaAnd port map(en1 => A, en2 => xor_bc, saida_and => and_s1);
   u4: PortaOr port map(input1 => and_bc, input2 => and_s1, saida_or => s1_final);
   u5: PortaXor port map(entXor1 => A, entXor2 => xor_bc, saida_xor => xor_s2);

   S1 <= s1_final;
   S2 <= xor_s2;
end architecture behav;