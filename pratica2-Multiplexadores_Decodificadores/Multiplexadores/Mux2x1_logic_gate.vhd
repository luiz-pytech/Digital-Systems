entity Mux2x1_logic_gate is
port(
  i0,i1,s0: in bit;
  d: out bit
);
end Mux2x1_logic_gate;

architecture behav of Mux2x1_logic_gate is
    signal not_s0 : bit;
    signal and_i0_s0: bit;
    signal and_i1_s0: bit;
    signal d_final: bit;

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

component PortaNot is
        port(entrada : in bit;
             saida_not : out bit);
end component;

begin
   u0: PortaNot port map(entrada => s0, saida_not => not_s0);
   u1: PortaAnd port map(en1 => i0, en2 => not_s0, saida_and => and_i0_s0);
   u2: PortaAnd port map(en1 => i1, en2 => s0, saida_and => and_i1_s0);
   u3: PortaOr port map(input1 => and_i0_s0, input2 => and_i1_s0, saida_or => d_final);

   d <= d_final;
end architecture behav;