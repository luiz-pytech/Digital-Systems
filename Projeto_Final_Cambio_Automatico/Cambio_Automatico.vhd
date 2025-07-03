entity Cambio_Automatico is

port(
      clk, rst: in std_logic;
      throttle, brake: in std_logic;
      gear_sel: in std_logic_vector(1 downto 0);
      leds_speed: out std_logic_vector(7 downto 0);
      switches_gear: out std_logic_vector(1 downto 0);
      leds_gearD: out std_logic_vector(2 downto 0)

);

end Cambio_Automatico;


architecture behav of Cambio_Automatico is

-- Sinais dos comparadores do datapath para o controlador
signal speed_eq_0_datapath_for_controlador : std_logic;
signal speed_lt_20_datapath_for_controlador : std_logic;
signal speed_lt_40_datapath_for_controlador : std_logic;
signal speed_lt_60_datapath_for_controlador : std_logic;
signal speed_lt_80_datapath_for_controlador : std_logic;
signal speed_lt_100_datapath_for_controlador : std_logic;
signal speed_eq_252_datapath_for_controlador : std_logic;

-- Sinais dos clr e ld do controlador para o datapath
signal ld_speed_controlador_for_datapath : std_logic;
signal clr_speed_controlador_for_datapath: std_logic; 
signal ld_gear_controlador_for_datapath: std_logic; 
signal clr_gear_controlador_for_datapath : std_logic; 
signal ld_gearD_controlador_for_datapath : std_logic; 
signal clr_gearD_controlador_for_datapath : std_logic;

-- Sinal de seleção de operação na velocidade (Incremento ou Decremento) do controlador para o datapath
signal select_speed_op_controlador_for_datapath : std_logic;

-- Sinal da marcha de Driver do controlador para o datapath
signal gearD_controlador_for_datapath : std_logic;

component Controlador_Cambio is
port(
	brake, throttle, speed_eq_0, speed_lt_20, speed_lt_40, speed_lt_60, speed_lt_80, speed_lt_100, speed_eq_255: in std_logic;
	ld_speed, clr_speed, ld_gear, clr_gear, ld_gearD, clr_gearD: out std_logic;
	select_speed_op: out std_logic;
	gear: in std_logic_vector(1 downto 0);
	gearD: out std_logic_vector(2 downto 0);
	clk, rst : in std_logic
);

end component;


component datapath_cambio is
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

begin
controlador: Controlador_cambio port map( 
        clk => clk, rst => rst,
        brake => brake, 
		  throttle => throttle,
		  speed_eq_0 => speed_eq_0_datapath_for_controlador,
		  speed_lt_20 => speed_lt_20_datapath_for_controlador,
		  speed_lt_40 => speed_lt_40_datapath_for_controlador,
		  speed_lt_60 => speed_lt_60_datapath_for_controlador,
		  speed_lt_80 => speed_lt_80_datapath_for_controlador,
		  speed_lt_100 => speed_lt_100_datapath_for_controlador,
		  speed_eq_255 => speed_eq_255_datapath_for_controlador,
		  ld_speed => ld_speed_controlador_for_datapath, 
		  clr_speed => clr_speed_controlador_for_datapath, 
		  ld_gear => ld_gear_controlador_for_datapath, 
		  clr_gear => clr_gear_controlador_for_datapath, 
		  ld_gearD => ld_gearD_controlador_for_datapath, 
		  clr_gearD => clr_gearD_controlador_for_datapath,
		  select_speed_op => select_speed_op_controlador_for_datapath,
		  gear => switches_gear, gearD => gearD_controlador_for_datapath
		  
);

datapath: datapath_cambio port map(
        clk => clk, 
		  rst => rst, 
		  gear)

end architecture behav;