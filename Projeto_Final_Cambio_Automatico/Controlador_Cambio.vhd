library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Controlador_Cambio is
port(
	brake, throttle, speed_eq_0, speed_lt_20, speed_lt_40, speed_lt_60, speed_lt_80, speed_lt_100, speed_eq_255: in std_logic;
	ld_speed, clr_speed, ld_gear, clr_gear, ld_gearD, clr_gearD: out std_logic;
	select_speed_op: out std_logic;
	gear: in std_logic_vector(1 downto 0);
	gearD: out std_logic_vector(2 downto 0);
	clk, rst : in std_logic
);

end Controlador_Cambio;

architecture behav of Controlador_Cambio is
		type statetype is
		(S_Park, S_Reverse, S_Neutral, S_Driver, S_WaitAction, S_Throttle, S_Brake);
		signal currentstate, nextstate: statetype;
		
		begin
			statereg: process(clk, rst)
			begin
			if (rst='1') then -- estado inicial
			currentstate <= S_Park;
			elsif (clk='1' and clk' event) then
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
         gearD <= "001";
			
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

							
							nextstate <= S_WaitAction;
						end if;
					end if;
					
					when S_WaitAction =>
					if (brake='1' and throttle = '0' and speed_eq_0 = '1') then
							if(gear = "10") then
								ld_gear <= '1';
								nextstate <= S_Neutral;	
							else
								ld_speed <= '1';
								ld_gearD <= '1';
								select_speed_op <= '0';
								
								nextstate <= S_Brake;
							end if;
					elsif(brake='0' and throttle = '1' and speed_eq_0 = '1') then
							ld_speed <= '1';
							ld_gearD <= '1';
							select_speed_op <= '1';
							
							nextstate <= S_Throttle;
					end if;
					
					when S_Brake =>
					if (brake='1' and throttle = '0' and speed_eq_0 = '0') then
					      select_speed_op <= '0';
							ld_speed <= '1';
							
							if(speed_eq_0 = '1' or speed_lt_20 = '1') then
				             gearD <= "001";
							elsif(speed_lt_40 = '1') then
							    gearD <= "010";
							elsif(speed_lt_60 = '1') then
							    gearD <= "011";
							elsif(speed_lt_80 = '1') then
							    gearD <= "100";
							elsif(speed_lt_100 = '1') then
							    gearD <= "101";
							else
							    gearD <= "110";
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
				             gearD <= "001";
							elsif(speed_lt_40 = '1') then
							    gearD <= "010";
							elsif(speed_lt_60 = '1') then
							    gearD <= "011";
							elsif(speed_lt_80 = '1') then
							    gearD <= "100";
							elsif(speed_lt_100 = '1') then
							    gearD <= "101";
							else
							    gearD <= "110";
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