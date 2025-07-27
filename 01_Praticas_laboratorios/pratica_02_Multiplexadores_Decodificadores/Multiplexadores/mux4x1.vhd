entity Mux4x1 is
port(
  i0,i1,i2,i3,s0, s1: in bit;
  d: out bit
);
end Mux4x1;

architecture behav of Mux4x1 is
    -- Descrição dos sinais
    signal mux1 : bit;
    signal mux2: bit;
    signal and_i1_s0: bit;
    signal out_final: bit;

component Mux2x1_logic_gate is
port(i0,i1, s0 : in bit;
     d : out bit
);
end component;

begin
   u0: Mux2x1_logic_gate port map(i0 => i0, i1 => i1 , s0 => s1, d => mux1);
   u1: Mux2x1_logic_gate port map(i0 => i2, i1 => i3 ,s0 => s1, d => mux2);
   u2: Mux2x1_logic_gate port map(i0 => mux1 , i1 => mux2 , s0=> s0, d =>out_final );

   d <= out_final;
end architecture behav;