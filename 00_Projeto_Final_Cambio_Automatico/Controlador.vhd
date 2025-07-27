library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Controlador is
port(
    brake, throttle: in std_logic;
    gear: in std_logic_vector(1 downto 0);
    clk, rst : in std_logic;
   
    speed: out std_logic_vector(7 downto 0);
    out_gear: out std_logic_vector(1 downto 0);
    out_gearD: out std_logic_vector(2 downto 0);

-- SAIDA NO DISPLAY
    s_gear : out std_logic_vector(6 downto 0);
    s_gearD : out std_logic_vector(6 downto 0)
);
end Controlador;

architecture behav of Controlador is
   
    type statetype is (S_Park, S_Reverse, S_Neutral, S_Driver, S_WaitAction, S_Throttle, S_Brake);
    signal currentstate, nextstate: statetype;
   
    signal ld_speed, clr_speed, ld_gear, clr_gear, ld_gearD, clr_gearD: std_logic;
    signal select_speed_op: std_logic;
   
    signal gearD_int: std_logic_vector(2 downto 0);

    signal speed_eq_0, speed_lt_20, speed_lt_40, speed_lt_60, speed_lt_80, speed_lt_100, speed_eq_255: std_logic;
   
    signal speed_out: std_logic_vector(7 downto 0);
   
    signal const_0    : std_logic_vector(7 downto 0) := "00000000";
    signal const_20   : std_logic_vector(7 downto 0) := "00010100";
    signal const_40   : std_logic_vector(7 downto 0) := "00101000";
    signal const_60   : std_logic_vector(7 downto 0) := "00111100";
    signal const_80   : std_logic_vector(7 downto 0) := "01010000";
    signal const_100  : std_logic_vector(7 downto 0) := "01100100";
    signal const_255  : std_logic_vector(7 downto 0) := "11111111";

signal speed_inc, speed_dec, new_speed: std_logic_vector(7 downto 0);
    signal gear_reg_out: std_logic_vector(1 downto 0);
    signal gearD_reg_out: std_logic_vector(2 downto 0);

    signal seg_gear_s0, seg_gear_s1, seg_gear_s2, seg_gear_s3, seg_gear_s4, seg_gear_s5, seg_gear_s6: std_logic;
    signal seg_gearD_s0, seg_gearD_s1, seg_gearD_s2, seg_gearD_s3, seg_gearD_s4, seg_gearD_s5, seg_gearD_s6: std_logic;
   
    component Registrador2bits is
    port(
        clock, load, clr: in std_logic;
        reg2_in    : in  std_logic_vector(1 downto 0);
        reg2_out   : out std_logic_vector(1 downto 0)
    );
    end component;
   
    component Registrador3bits is
    port(
        clock, load, clr: in std_logic;
        reg3_in    : in  std_logic_vector(2 downto 0);
        reg3_out   : out std_logic_vector(2 downto 0)
    );
    end component;
   
    component Registrador8bits is
    port(
        clock, load, clr: in std_logic;
        reg8_in    : in  std_logic_vector(7 downto 0);
        reg8_out   : out std_logic_vector(7 downto 0)
    );
    end component;
   
    component Comparator_Mag_8bits is
    port(
        A, B: in std_logic_vector(7 downto 0);
        lt, eq, gt: out std_logic
    );
    end component;
   
    component mux2x1_8b is
    port(
        A, B: in std_logic_vector(7 downto 0);
        S0: in std_logic;
        Q: out std_logic_vector(7 downto 0)
    );
    end component;

    -- Componentes para visualização no display
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
    speed_inc <= std_logic_vector(unsigned(speed_out) + 1);
    speed_dec <= std_logic_vector(unsigned(speed_out) - 1);
   
    Mux_Speed: mux2x1_8b port map (
        A => speed_dec,  
        B => speed_inc,  
        S0 => select_speed_op,  
        Q => new_speed
    );
   
    Registrador_Speed: Registrador8bits port map(
        clock => clk,  
        load => ld_speed,  
        clr => clr_speed,  
        reg8_in => new_speed,  
        reg8_out => speed_out
    );
   
    Registrador_Alavanca: Registrador2bits port map(
        clock => clk,  
        load => ld_gear,  
        clr => clr_gear,  
        reg2_in => gear,  
        reg2_out => gear_reg_out
    );
   
    Registrador_Driver: Registrador3bits port map(
        clock => clk,
        load => ld_gearD,
        clr => clr_gearD,
        reg3_in => gearD_int,  
        reg3_out => gearD_reg_out
    );
   
    Comparador_eq_0: Comparator_Mag_8bits port map(
        A => speed_out,  
        B => const_0,  
        lt => open,  
        eq => speed_eq_0,  
        gt => open
    );
    Comparador_lt_20: Comparator_Mag_8bits port map(
        A => speed_out,  
        B => const_20,  
        lt => speed_lt_20,  
        eq => open,  
        gt => open
    );
    Comparador_lt_40: Comparator_Mag_8bits port map(
        A => speed_out,  
        B => const_40,  
        lt => speed_lt_40,  
        eq => open,  
        gt => open
    );
    Comparador_lt_60: Comparator_Mag_8bits port map(
        A => speed_out,  
        B => const_60,  
        lt => speed_lt_60,  
        eq => open,  
        gt => open
    );
    Comparador_lt_80: Comparator_Mag_8bits port map(
        A => speed_out,  
        B => const_80,  
        lt => speed_lt_80,  
        eq => open,  
        gt => open
    );
    Comparador_lt_100: Comparator_Mag_8bits port map(
        A => speed_out,  
        B => const_100,  
        lt => speed_lt_100,  
        eq => open,  
        gt => open
    );
    Comparador_eq_255: Comparator_Mag_8bits port map(
        A => speed_out,  
        B => const_255,  
        lt => open,  
        eq => speed_eq_255,  
        gt => open
    );

Decoder_Alavanca: DecoderGear port map(
G0 => gear_reg_out(0),
G1 => gear_reg_out(1),
s0 => seg_gear_s0,
s1 => seg_gear_s1,
s2 => seg_gear_s2,
s3 => seg_gear_s3,
s4 => seg_gear_s4,
s5 => seg_gear_s5,
s6 => seg_gear_s6
);

Decoder_Modo_Driver: DecoderGearD port map(
G0 => gearD_reg_out(0),
G1 => gearD_reg_out(1),
G2 => gearD_reg_out(2),
s0 => seg_gearD_s0,
s1 => seg_gearD_s1,
s2 => seg_gearD_s2,
s3 => seg_gearD_s3,
s4 => seg_gearD_s4,
s5 => seg_gearD_s5,
s6 => seg_gearD_s6
);

    speed <= speed_out;
    out_gear <= gear_reg_out;
    out_gearD <= gearD_reg_out;
   
    statereg: process(clk, rst)
    begin
        if (rst='1') then -- Reset assíncrono
            currentstate <= S_Park;
        elsif (rising_edge(clk)) then
            currentstate <= nextstate;
        end if;
    end process;
   
    comblogic: process (currentstate, brake, throttle, speed_eq_0, gear, speed_lt_20, speed_lt_40, speed_lt_60, speed_lt_80, speed_lt_100, speed_eq_255)
    begin
        nextstate <= currentstate;
        ld_speed <= '0';
        clr_speed <= '0';
        ld_gear <= '0';
        clr_gear <= '0';
        ld_gearD <= '0';
        clr_gearD <= '0';
        select_speed_op <= '0';
        gearD_int <= gearD_reg_out;
       
        case currentstate is
            when S_Park =>
                if (brake='1' and throttle = '0' and speed_eq_0 = '1' and gear = "01") then
                    ld_gear <= '1';
                    nextstate <= S_Reverse;
                end if;
           
            when S_Reverse =>
                if (brake='1' and throttle = '0' and speed_eq_0 = '1' and gear = "00") then
                    ld_gear <= '1';
                    nextstate <= S_Park;
                elsif (brake='1' and throttle = '0' and speed_eq_0 = '1' and gear = "10") then
                    ld_gear <= '1';
                    nextstate <= S_Neutral;
                end if;
           
            when S_Neutral =>
                if (brake='1' and throttle = '0' and speed_eq_0 = '1' and gear = "01") then
                    ld_gear <= '1';
                    nextstate <= S_Reverse;
                elsif (brake='1' and throttle = '0' and speed_eq_0 = '1' and gear = "11") then
                    ld_gear <= '1';
                    ld_gearD <= '1';
                    gearD_int <= "001";
                    nextstate <= S_Driver;
                end if;
           
            when S_Driver =>
                if (brake='1' and throttle = '0' and speed_eq_0 = '1' and gear = "10") then
                    ld_gear <= '1';
                    ld_gearD <= '1';  
                    nextstate <= S_Neutral;
                else
                    nextstate <= S_WaitAction;
                end if;
           
            when S_WaitAction =>
                if (brake='1' and throttle = '0' and speed_eq_0 = '0') then
                    select_speed_op <= '0';
                    ld_speed <= '1';        
                    nextstate <= S_Brake;
                elsif (brake='0' and throttle = '1') then
                    ld_speed <= '1';
                    select_speed_op <= '1';
                    nextstate <= S_Throttle;
                elsif (brake='1' and throttle = '0' and speed_eq_0 = '1' and gear = "10") then
                    ld_gear <= '1';
                    ld_gearD <= '1';
                    gearD_int <= "000";
                    nextstate <= S_Neutral;
                else
                    ld_speed <= '0';
                    select_speed_op <= '0';
                    nextstate <= S_WaitAction;
                end if;
           
            when S_Brake =>
               
                if (brake='1' and throttle = '0' and speed_eq_0 = '0') then
                    select_speed_op <= '0';
                    ld_speed <= '1';        
                else
                    ld_speed <= '0';        
                end if;
               
                if(speed_eq_0 = '1' or speed_lt_20 = '1') then gearD_int <= "001";
                elsif(speed_lt_40 = '1') then gearD_int <= "010";
                elsif(speed_lt_60 = '1') then gearD_int <= "011";
                elsif(speed_lt_80 = '1') then gearD_int <= "100";
                elsif(speed_lt_100 = '1') then gearD_int <= "101";
                else gearD_int <= "110";
                end if;
                ld_gearD <= '1';
               
               
                if (speed_eq_0 = '1' or brake = '0' or throttle = '1') then
                    nextstate <= S_WaitAction;
                else
                    nextstate <= S_Brake;
                end if;
           
            when S_Throttle =>
                if (brake='0' and throttle = '1' and speed_eq_255 = '0') then
                    select_speed_op <= '1';
                    ld_speed <= '1';        
                else
                    ld_speed <= '0';        
                end if;
               
                ld_gearD <= '1';

                if(speed_eq_0 = '1' or speed_lt_20 = '1') then gearD_int <= "001";
                elsif(speed_lt_40 = '1') then gearD_int <= "010";
                elsif(speed_lt_60 = '1') then gearD_int <= "011";
                elsif(speed_lt_80 = '1') then gearD_int <= "100";
                elsif(speed_lt_100 = '1') then gearD_int <= "101";
                else gearD_int <= "110";
                end if;
               
                if (throttle = '0' or speed_eq_255 = '1' or brake = '1') then  
                    nextstate <= S_WaitAction;
                else
                    nextstate <= S_Throttle;
                end if;
            when others =>
                nextstate <= S_Park;
        end case;
    end process;

s_gear(0) <= seg_gear_s0;  
s_gear(1) <= seg_gear_s1;
s_gear(2) <= seg_gear_s2;
s_gear(3) <= seg_gear_s3;
s_gear(4) <= seg_gear_s4;
s_gear(5) <= seg_gear_s5;
s_gear(6) <= seg_gear_s6;

s_gearD(0) <= seg_gearD_s0;
s_gearD(1) <= seg_gearD_s1;
s_gearD(2) <= seg_gearD_s2;
s_gearD(3) <= seg_gearD_s3;
s_gearD(4) <= seg_gearD_s4;
s_gearD(5) <= seg_gearD_s5;
s_gearD(6) <= seg_gearD_s6;

end architecture behav;
