library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Cambio_Automatico is

port(
      clk, rst: in std_logic;
      throttle, brake: in std_logic;
      gear_sel: in std_logic_vector(1 downto 0);
      leds_speed: out std_logic_vector(7 downto 0);
      switches_gear: out std_logic_vector(1 downto 0);
      leds_gearD: out std_logic_vector(2 downto 0);
      
      -- saídas para display de gear (s0-s6)
      display_gear_s0, display_gear_s1, display_gear_s2, display_gear_s3, display_gear_s4, display_gear_s5, display_gear_s6: out std_logic;

       -- saídas para display de gearD (s0-s6)
      display_driver_s0, display_driver_s1, display_driver_s2, display_driver_s3, display_driver_s4, display_driver_s5, display_driver_s6: out std_logic

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
signal speed_eq_255_datapath_for_controlador : std_logic;

-- Sinais dos clr e ld do controlador para o datapath
signal ld_speed_controlador_for_datapath : std_logic;
signal clr_speed_controlador_for_datapath: std_logic; 
signal ld_gear_controlador_for_datapath: std_logic; 
signal clr_gear_controlador_for_datapath : std_logic; 
signal ld_gearD_controlador_for_datapath : std_logic; 
signal clr_gearD_controlador_for_datapath : std_logic;

-- Sinal de seleção de operação na velocidade (incremento ou decremento) do controlador para o datapath
signal select_speed_op_controlador_for_datapath : std_logic;

-- Sinal da marcha de driver do controlador para o datapath
signal gearD_controlador_for_datapath: std_logic_vector(2 downto 0);

-- Sinal do switches gear do datapath para o controlador
signal gear_datapath_for_controlador : std_logic_vector(1 downto 0);

-- Sinais para saida do datapath para display
signal speed_for_led: std_logic_vector(7 downto 0);
signal out_gear_for_display: std_logic_vector(1 downto 0);
signal out_gearD_for_display: std_logic_vector(2 downto 0);

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

end component;

component DecoderGear is
port(
      G1,G0: in std_logic;
      s0,s1,s2,s3,s4,s5,s6: out std_logic
);
end component;

component DecoderGearD is 
port(
      G2, G1,G0: in std_logic;
      s0,s1,s2,s3,s4,s5,s6: out std_logic
);
end component;

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
		gear => gear_datapath_for_controlador, gearD => gearD_controlador_for_datapath
			  
);
switches_gear <= gear_sel;

datapath: datapath_cambio port map(
		clk => clk, rst => rst, 
		gear => gear_sel,
		gearD => gearD_controlador_for_datapath,
		select_speed_op => select_speed_op_controlador_for_datapath,
		ld_speed => ld_speed_controlador_for_datapath, 
		clr_speed => clr_speed_controlador_for_datapath, 
		ld_gear => ld_gear_controlador_for_datapath, 
		clr_gear => clr_gear_controlador_for_datapath, 
		ld_gearD => ld_gearD_controlador_for_datapath, 
		clr_gearD => clr_gearD_controlador_for_datapath,
		speed_eq_0 => speed_eq_0_datapath_for_controlador,
		speed_lt_20 => speed_lt_20_datapath_for_controlador,
		speed_lt_40 => speed_lt_40_datapath_for_controlador,
		speed_lt_60 => speed_lt_60_datapath_for_controlador,
		speed_lt_80 => speed_lt_80_datapath_for_controlador,
		speed_lt_100 => speed_lt_100_datapath_for_controlador,
		speed_eq_255 => speed_eq_255_datapath_for_controlador,
		speed => speed_for_led,
		out_gear=> out_gear_for_display,
		out_gearD => out_gearD_for_display
);

Decoder_Alavanca: DecoderGear port map(
      G1 => out_gear_for_display(1), G0 => out_gear_for_display(0),
      s0 => display_gear_s0,
      s1 => display_gear_s1,
      s2 => display_gear_s2,
      s3 => display_gear_s3,
      s4 => display_gear_s4,
      s5 => display_gear_s5,
      s6 => display_gear_s6) ;

Decoder_Driver: DecoderGearD port map(
      G2 =>out_gearD_for_display(2),
      G1 => out_gearD_for_display(1),
      G0 => out_gearD_for_display(0),
      s0 => display_driver_s0,
      s1 => display_driver_s1,
      s2 => display_driver_s2,
      s3 => display_driver_s3,
      s4 => display_driver_s4,
      s5 => display_driver_s5,
      s6 => display_driver_s6);
		
leds_speed <= speed_for_led;

end architecture behav;