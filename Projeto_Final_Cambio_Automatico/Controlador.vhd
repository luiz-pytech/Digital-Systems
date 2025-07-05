library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Controlador is
port(
    brake, throttle: in std_logic;
    gear: in std_logic_vector(1 downto 0);
    clk, rst : in std_logic;
    
    -- Outputs to external world
    speed: out std_logic_vector(7 downto 0);
    out_gear: out std_logic_vector(1 downto 0);
    out_gearD: out std_logic_vector(2 downto 0)
);
end Controlador;

architecture behav of Controlador is
    -- State type declaration
    type statetype is (S_Park, S_Reverse, S_Neutral, S_Driver, S_WaitAction, S_Throttle, S_Brake);
    signal currentstate, nextstate: statetype;
    
    -- Internal signals
    signal ld_speed, clr_speed, ld_gear, clr_gear, ld_gearD, clr_gearD: std_logic;
    signal select_speed_op: std_logic;
    signal gearD_int: std_logic_vector(2 downto 0);
    
    -- Speed comparison signals
    signal speed_eq_0, speed_lt_20, speed_lt_40, speed_lt_60, speed_lt_80, speed_lt_100, speed_eq_255: std_logic;
    signal speed_out: std_logic_vector(7 downto 0);
    
    -- Constants for comparison
    signal const_0    : std_logic_vector(7 downto 0) := "00000000";
    signal const_20   : std_logic_vector(7 downto 0) := "00010100";
    signal const_40   : std_logic_vector(7 downto 0) := "00101000";
    signal const_60   : std_logic_vector(7 downto 0) := "00111100";
    signal const_80   : std_logic_vector(7 downto 0) := "01010000";
    signal const_100  : std_logic_vector(7 downto 0) := "01100100";
    signal const_255  : std_logic_vector(7 downto 0) := "11111111";
    
    -- Datapath components
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
    
    -- Internal signals for datapath
    signal speed_inc, speed_dec, new_speed: std_logic_vector(7 downto 0);
    signal gear_reg_out: std_logic_vector(1 downto 0);
    signal gearD_reg_out: std_logic_vector(2 downto 0);
    
begin
    -- Datapath instantiation
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
    
    -- Connect outputs
    speed <= speed_out;
    out_gear <= gear_reg_out;
    out_gearD <= gearD_reg_out;
    
    -- State register
    statereg: process(clk, rst)
    begin
        if (rst='1') then -- estado inicial
            currentstate <= S_Park;
        elsif (clk='1' and clk' event) then
            currentstate <= nextstate;
        end if;
    end process;
    
    -- Combinational logic
    comblogic: process (currentstate, brake, throttle, speed_eq_0, gear, 
                        speed_lt_20, speed_lt_40, speed_lt_60, speed_lt_80, 
                        speed_lt_100, speed_eq_255)
    begin
        -- Default values
        nextstate <= currentstate;
        ld_speed <= '0';
        clr_speed <= '0';
        ld_gear <= '0';
        clr_gear <= '0';
        ld_gearD <= '0';
        clr_gearD <= '0';
        select_speed_op <= '0';
        
        case currentstate is
            when S_Park =>
                if (brake='1' and throttle = '0' and speed_eq_0 = '1') then
                    if(gear = "01") then
                        ld_gear <= '1';
                        nextstate <= S_Reverse;
                    else
                        nextstate <= S_Park;
                    end if;
                end if;
                
            when S_Reverse =>
                if (brake='1' and throttle = '0' and speed_eq_0 = '1') then
                    if(gear = "00") then
                        ld_gear <= '1';
                        nextstate <= S_Park;
                    elsif(gear = "10") then
                        ld_gear <= '1';
                        nextstate <= S_Neutral;
                    end if;
                end if;
                
            when S_Neutral =>
                if (brake='1' and throttle = '0' and speed_eq_0 = '1') then
                    if(gear = "01") then
                        ld_gear <= '1';
                        nextstate <= S_Reverse;
                    elsif(gear = "11") then
                        ld_gear <= '1';
                        nextstate <= S_Driver;
                    end if;
                end if;
                
            when S_Driver =>
                if (brake='1' and throttle = '0' and speed_eq_0 = '1') then
                    if(gear = "11") then
                        clr_speed <= '1';
                        ld_gearD <= '1';
								gearD_int <= "001";
                        nextstate <= S_WaitAction;
                    end if;
                end if;
                
            when S_WaitAction =>
                if (brake='1' and throttle = '0' and speed_eq_0 = '1') then
                    if(gear = "10") then
                        ld_gear <= '1';
                        nextstate <= S_Neutral;    
                    else
                        if speed_eq_0 = '0' then  -- só decrementa se estiver acima de zero
									  ld_speed <= '1';
									  select_speed_op <= '0';
								 end if;
								 ld_gearD <= '1';
								 nextstate <= S_Brake;
                    end if;
                elsif(brake='0' and throttle = '1' and speed_eq_0 = '1') then
                    ld_speed <= '1';
                    ld_gearD <= '1';
                    select_speed_op <= '1';
                    nextstate <= S_Throttle;
                end if;
                
            when S_Brake =>
                if (brake='1' and throttle = '0') then
                    if speed_eq_0 = '0' then
								 select_speed_op <= '0';
								 ld_speed <= '1';
							end if;
                    
                    if(speed_eq_0 = '1' or speed_lt_20 = '1') then
                        gearD_int <= "001";
								ld_gearD <= '1';
                    elsif(speed_lt_40 = '1') then
                        gearD_int <= "010";
								ld_gearD <= '1';
                    elsif(speed_lt_60 = '1') then
                        gearD_int <= "011";
								ld_gearD <= '1';
                    elsif(speed_lt_80 = '1') then
                        gearD_int <= "100";
								ld_gearD <= '1';
                    elsif(speed_lt_100 = '1') then
                        gearD_int <= "101";
								ld_gearD <= '1';
                    else
                        gearD_int <= "110";
								ld_gearD <= '1';
                    end if;
                    
                    if(brake = '0') then
                        nextstate <= S_WaitAction;
                    else
                        nextstate <= S_Brake;
                    end if;
                end if;
                
            when S_Throttle =>
                if (brake='0' and throttle = '1' and speed_eq_255 = '0') then
                    select_speed_op <= '1';
                    ld_speed <= '1';
                    
                    if(speed_eq_0 = '1' or speed_lt_20 = '1') then
                        gearD_int <= "001";
								ld_gearD <= '1';
                    elsif(speed_lt_40 = '1') then
                        gearD_int <= "010";
								ld_gearD <= '1';
                    elsif(speed_lt_60 = '1') then
                        gearD_int <= "011";
								ld_gearD <= '1';
                    elsif(speed_lt_80 = '1') then
                        gearD_int <= "100";
								ld_gearD <= '1';
                    elsif(speed_lt_100 = '1') then
                        gearD_int <= "101";
								ld_gearD <= '1';
                    else
                        gearD_int <= "110";
								ld_gearD <= '1';
                    end if;
                    
                    if(throttle = '0') then
                        nextstate <= S_WaitAction;
                    else
                        nextstate <= S_Throttle;
                    end if;
                end if;
        end case;
    end process;

end architecture behav;
