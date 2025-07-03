library ieee;
use ieee.std_logic_1164.all;

entity and_gate is
	port(
	a_and, b_and: in std_logic;
	s_and: out std_logic
	);
end and_gate;

architecture main of and_gate is
	begin
	s_and <= a_and and b_and;
end architecture main;