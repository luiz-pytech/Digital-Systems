library ieee;
use ieee.std_logic_1164.all;

entity mux2x1_3b is
	port(
	A, B: in std_logic_vector(2 downto 0);
	S0: in std_logic;
	Q: out std_logic_vector(2 downto 0)
	);
end mux2x1_3b;

architecture main of mux2x1_3b is

	signal F1, F2: std_logic_vector(2 downto 0);
	
	component and_gate is
		port(
			a_and, b_and: in std_logic;
			s_and: out std_logic
		);
	end component;
	
	component or_gate is
		port(
			a_or, b_or: in std_logic;
			s_or: out std_logic
		);
	end component;
	
begin

	gen_and_or: for i in 0 to 2 generate
	
		u1: and_gate port map(a_and => A(i), b_and => not S0, s_and => F1(i));
		u2: and_gate port map(a_and => B(i), b_and => S0, s_and => F2(i));
		u3: or_gate port map(a_or => F1(i), b_or => F2(i), s_or => Q(i));
		
	end generate;
	
end architecture main;
	
	
	