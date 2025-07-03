library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity datapath_cambio is
port(
    gear: in std_logic_vector(1 downto 0);
    gearD: in std_logic_vector(2 downto 0);
    select_speed_op: in std_logic;
    ld_speed, clr_speed: in std_logic;
    ld_gear, clr_gear: in std_logic;
    ld_gearD, clr_gearD: in std_logic;
    clk: in std_logic;

    speed: out std_logic_vector(7 downto 0);
    out_gear: out std_logic_vector(1 downto 0);
    out_gearD: out std_logic_vector(2 downto 0)
);

end datapath_cambio;

architecture behav of datapath_cambio is

signal speed_out, speed_inc, speed_dec, new_speed: std_logic_vector(7 downto 0);
signal gear_reg_out: std_logic_vector(1 downto 0);
signal gearD_reg_out: std_logic_vector(2 downto 0);

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
  
u0: mux2x1_8b port map (A => speed_dec, B => speed_inc, S0 => select_speed_op, Q => new_speed);
u1: Registrador8bits port map(clock => clk, load => ld_speed, clr => clr_speed, reg8_in => new_speed, reg8_out => speed_out);
u2: Registrador2bits port map(clock => clk, load => ld_gearD, clr => clr_gearD, reg2_in => gear, reg2_out => gear_reg_out);
u2: Registrador3bits port map(clock => clk,load => ld_gearD,clr => clr_gearD,reg3_in => gearD, reg3_out => gearD_reg_out);


speed <= speed_out;
out_gear <= gear_reg_out;
out_gearD <= gearD_reg_out;

end architecture behav;