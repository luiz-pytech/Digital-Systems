entity Mux2x1_Comp is
port(i0,i1,s0 : in bit; -- No qual s0 é a porta de seleção
    d : out bit);
end Mux2x1_Comp;
architecture behav of Mux2x1_Comp is
begin
  with s0 select
    d <= i0 when '0',
    i1 when '1';
end behav;