library ieee;
use ieee.std_logic_1164.all;

entity Pacemaker is
  port(
    s, z, clk, rst : in std_logic;
    t, p : out std_logic
  );
end Pacemaker;

architecture behav of Pacemaker is
  type statetype is (resetTemporizador, espera, contracao);
  signal currentstate, nextstate : statetype;
begin

  -- Bloco de registrador de estado
  statereg: process(clk, rst)
  begin
    if rst = '1' then
      currentstate <= resetTemporizador;
    elsif rising_edge(clk) then
      currentstate <= nextstate;
    end if;
  end process;

  comblogic: process(currentstate, s, z)
  begin
    t <= '0';
    p <= '0';
    nextstate <= currentstate;

    case currentstate is
      when resetTemporizador =>
        t <= '1';
        nextstate <= espera;

      when espera =>
        if s = '1' then
          nextstate <= resetTemporizador;
        elsif z = '1' then
          nextstate <= contracao;
        else
          nextstate <= espera;
        end if;

      when contracao =>
        p <= '1';
        nextstate <= resetTemporizador;

    end case;
  end process;

end behav;