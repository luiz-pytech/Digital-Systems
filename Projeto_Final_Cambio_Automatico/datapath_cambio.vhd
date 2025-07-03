library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity datapath_cambio is
port(
    clk, rst: in std_logic;
    gear: in std_logic_vector(1 downto 0);
    gearD: in std_logic_vector(2 downto 0);
    select_speed_op: in std_logic;
    ld_speed, clr_speed: in std_logic;
    ld_gear, clr_gear: in std_logic;
    ld_gearD, clr_gearD: in std_logic;

    speed: out std_logic_vector(7 downto 0);
    out_gear: out std_logic_vector(1 downto 0);
    out_gearD: out std_logic_vector(2 downto 0);

   speed_eq_0   : out std_logic;
   speed_lt_20  : out std_logic;
   speed_lt_40  : out std_logic;
   speed_lt_60  : out std_logic;
   speed_lt_80  : out std_logic;
   speed_lt_100 : out std_logic;
   speed_eq_255 : out std_logic
);

end datapath_cambio;

architecture behav of datapath_cambio is

signal speed_out, speed_inc, speed_dec, new_speed: std_logic_vector(7 downto 0);
signal gear_reg_out: std_logic_vector(1 downto 0);
signal gearD_reg_out: std_logic_vector(2 downto 0);

-- Sinais de entrada do comparador.
signal const_0    : std_logic_vector(7 downto 0) := "00000000";
signal const_20   : std_logic_vector(7 downto 0) := "00010100";
signal const_40   : std_logic_vector(7 downto 0) := "00101000";
signal const_60   : std_logic_vector(7 downto 0) := "00111100";
signal const_80   : std_logic_vector(7 downto 0) := "01010000";
signal const_100  : std_logic_vector(7 downto 0) := "01100100";
signal const_255  : std_logic_vector(7 downto 0) := "11111111";

-- Sinais de Saida de cada comparador:
signal speed_eq_0_out   : std_logic;
signal speed_lt_20_out  : std_logic;
signal speed_lt_40_out  : std_logic;
signal speed_lt_60_out  : std_logic;
signal speed_lt_80_out  : std_logic;
signal speed_lt_100_out : std_logic;
signal speed_eq_255_out : std_logic;

component Registrador2bits
port(
    clock, load, clr: in std_logic;
	reg2_in    : in  std_logic_vector(1 downto 0);
    reg2_out   : out std_logic_vector(1 downto 0)
);
end component;

component Registrador3bits
port(
    clock, load, clr: in std_logic;
	reg3_in    : in  std_logic_vector(2 downto 0);
    reg3_out   : out std_logic_vector(2 downto 0)
);
end component;

component Registrador8bits
port(
    clock, load, clr: in std_logic;
	reg8_in    : in  std_logic_vector(7 downto 0);
    reg8_out   : out std_logic_vector(7 downto 0)
);
end component;

component Comparator_Mag_8bits
port(
    A, B: in std_logic_vector(7 downto 0);
    lt, eq, gt: out std_logic
);
end component;

component mux2x1_8b
port(
    A, B: in std_logic_vector(7 downto 0);
	S0: in std_logic;
	Q: out std_logic_vector(7 downto 0)
);
end component;

begin

  speed_inc <= speed_out + 1;
  speed_dec <= speed_out - 1;
  
Mux_Speed: mux2x1_8b port map (A => speed_dec, B => speed_inc, S0 => select_speed_op, Q => new_speed);
Registrador_Speed: Registrador8bits port map(clock => clk, load => ld_speed, clr => clr_speed, reg8_in => new_speed, reg8_out => speed_out);
Registrador_Alavanca: Registrador2bits port map(clock => clk, load => ld_gear, clr => clr_gear, reg2_in => gear, reg2_out => gear_reg_out);
Registrador_Driver: Registrador3bits port map(clock => clk,load => ld_gearD,clr => clr_gearD,reg3_in => gearD, reg3_out => gearD_reg_out);
Comparador_eq_0: Comparator_Mag_8bits port map(A => speed_out , B=> const_0, lt => open, eq =>speed_eq_0_out, gt => open);
Comparador_lt_20: Comparator_Mag_8bits port map(A => speed_out, B=> const_20, lt => speed_lt_20_out , eq => open, gt => open);
Comparador_lt_40: Comparator_Mag_8bits port map(A => speed_out, B=> const_40 , lt => speed_lt_40_out, eq => open, gt => open);
Comparador_lt_60: Comparator_Mag_8bits port map(A => speed_out, B=> const_60, lt => speed_lt_60_out, eq => open, gt => open);
Comparador_lt_80: Comparator_Mag_8bits port map(A => speed_out, B=> const_80, lt => speed_lt_80_out, eq => open, gt => open);
Comparador_lt_100: Comparator_Mag_8bits port map(A => speed_out, B=> const_100, lt => speed_lt_100_out, eq => open, gt => open);
Comparador_eq_255: Comparator_Mag_8bits port map(A => speed_out, B=> const_255, lt => open, eq => speed_eq_255_out, gt => open);

speed <= speed_out;
out_gear <= gear_reg_out;
out_gearD <= gearD_reg_out;


speed_eq_0  <= speed_eq_0_out;
speed_lt_20 <= speed_lt_20_out;
speed_lt_40  <= speed_lt_40_out;
speed_lt_60  <= speed_lt_60_out;
speed_lt_80  <= speed_lt_80_out;
speed_lt_100 <= speed_lt_100_out;
speed_eq_255 <= speed_eq_255_out;

end architecture behav;