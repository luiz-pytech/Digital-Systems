library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Cambio_Automatico is
port(
	brake, throttle, speed_eq_0, speed_lt_20, speed_lt_40, speed_lt_60, speed_lt_80, speed_lt_100: in std_logic;
	ld_speed, clr_speed, ld_gear, clr_gear, ld_gearD, clr_gearD: out std_logic;
	select_speed_op, select_gearD: out std_logic;
	gear: in std_logic_vector(2 downto 0)
);

end Cambio_Automatico;

architecture behav of Cambio_Automatico is
		type statetype is
		(S_Park, S_Reverse, S_Neutral, S_Driver, S_WaitAction, S_Throttle, S_Brake);
		signal currentstate, nextstate: statetype;
		
		begin
			statereg: process(clk, rst)
			begin
			if (rst='1') then -- estado inicial
			currentstate <= S_Park;
			elsif (clk='1' and clk ' event) then
			currentstate <= nextstate;
			end if;
			end process;
		
		comblogic: process (currentstate, brake, throttle, speed_eq_0)
			begin
			case currentstate is
				when S_Park =>
					if (brake='1' and throttle = '0' and speed_eq_0 = '1') then
						if(gear = '01')
							ld_speed <= '0';
							clr_speed <= '0';
							ld_gear <= '1';
							clr_gear <= '0';
							ld_gearD <= '0';
							clr_gearD <= '0';
							
							nextstate <= S_Reverse;
						else
							nextstate <= S_Park;
						end if;
					end if;
					
				when S_Reverse =>
					if (brake='1' and throttle = '0' and speed_eq_0 = '1') then
						if(gear = '00') then
							ld_speed <= '0';
							clr_speed <= '0';
							ld_gear <= '1';
							clr_gear <= '0';
							ld_gearD <= '0';
							clr_gearD <= '0';
							
							nextstate <= S_Park;
						elsif(gear = '10') then
							ld_speed <= '0';
							clr_speed <= '0';
							ld_gear <= '1';
							clr_gear <= '0';
							ld_gearD <= '0';
							clr_gearD <= '0';
							nextstate <= S_Neutral;
						end if;
					end if;
					
				when S_Neutral =>
					if (brake='1' and throttle = '0' and speed_eq_0 = '1') then
						if(gear = '01') then
							ld_speed <= '0';
							clr_speed <= '0';
							ld_gear <= '1';
							clr_gear <= '0';
							ld_gearD <= '0';
							clr_gearD <= '0';
							
							nextstate <= S_Reverse;
						elsif(gear = '11') then
							ld_speed <= '0';
							clr_speed <= '0';
							ld_gear <= '1';
							clr_gear <= '0';
							ld_gearD <= '0';
							clr_gearD <= '0';
							nextstate <= S_Driver;
						end if;
					end if;
					
				when S_Driver =>
					if (brake='1' and throttle = '0' and speed_eq_0 = '1') then
						if(gear = '11') then
							ld_speed <= '0';
							clr_speed <= '1';
							ld_gear <= '0';
							clr_gear <= '0';
							ld_gearD <= '1';
							clr_gearD <= '0';
							select_gearD <= '0';
							
							nextstate <= S_WaitAction;
						end if;
					end if;
					
					when S_WaitAction =>
					if (brake='1' and throttle = '0' and speed_eq_0 = '0') then
							if(gear = '10') then
								ld_speed <= '0';
								clr_speed <= '0';
								ld_gear <= '1';
								clr_gear <= '0';
								ld_gearD <= '0';
								clr_gearD <= '0';
								nextstate <= S_Neutral;	
							else
								ld_speed <= '1';
								clr_speed <= '0';
								ld_gearD <= '1';
								clr_gearD <= '0';
								
								nextstate <= S_Brake;
							end if;
					elsif(brake='0' and throttle = '1') then
							ld_speed <= '1';
							clr_speed <= '0';
							ld_gearD <= '1';
							clr_gearD <= '0';
							
							nextstate <= S_Brake;
					end if;
			when S_On2 =>
			x <= '1'; -- laser ainda ligado
			nextstate <= S_On3;
			when S_On3 =>
			x <= '1'; -- laser ainda ligado
			nextstate <= S_Off;
			end case;
			end process;



end architecture behav;