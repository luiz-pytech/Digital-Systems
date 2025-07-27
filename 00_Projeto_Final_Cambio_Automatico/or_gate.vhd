library ieee;
use ieee.std_logic_1164.all;

entity or_gate is
	port(
	a_or, b_or: in std_logic;
	s_or: out std_logic
	);
end or_gate;

architecture main of or_gate is
	begin
	s_or <= a_or or b_or;
end architecture main;