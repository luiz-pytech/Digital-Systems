entity Registrador8bits is
port(
    clock, load, clr: in std_logic;
	reg8_in    : in  std_logic_vector(7 downto 0);
    reg8_out   : out std_logic_vector(7 downto 0)
);
end Registrador8bits;

architecture behav of Registrador8bits is
    signal save_reg : std_logic_vector(7 downto 0);
begin
    reg8bits:process (clock, load, clr)
	begin
	if(clock' = '1' and clock' event)
	    if(clr = '1') then
			    save_reg(0) <= '0';
				save_reg(1) <= '0';
			    save_reg(2) <= '0';
                save_reg(3) <= '0';	
                save_reg(4) <= '0';	
                save_reg(5) <= '0';	
                save_reg(6) <= '0';	
                save_reg(7) <= '0';	
	    elsif(load = '1') then
		    save_reg <= reg8_in;
		end if;
	end if;
	end process;

	reg8_out <= save_reg;
end behav;