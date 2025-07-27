library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Registrador2bits is
port(
    clock, load, clr: in std_logic;
	 reg2_in    : in  std_logic_vector(1 downto 0);
    reg2_out   : out std_logic_vector(1 downto 0)
);

end Registrador2bits;

architecture behav of Registrador2bits is
    signal save_reg : std_logic_vector(1 downto 0);
begin
   reg2bits:process(clock, load, clr)
	begin
	if(clock = '1' and clock' event) then
	    if(clr = '1') then
			    save_reg(0) <= '0';
				save_reg(1) <= '0';
	    elsif(load = '1') then
		    save_reg <= reg2_in;
		end if;
	end if;
	end process;

	reg2_out <= save_reg;
end behav; 