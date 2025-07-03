entity Registrador3bits is
port(
    
	 clock, load, clr: in std_logic;
	 reg3_in    : in  std_logic_vector(2 downto 0);
     reg3_out   : out std_logic_vector(2 downto 0)

);

end Registrador3bits;

architecture behav of Registrador3bits is
    signal save_reg : std_logic_vector(2 downto 0);
begin
    reg3bits:process (clock, load, clr)
	begin
	if(clock' = '1' and clock' event)
	    if(clr = '1') then
			    save_reg(0) <= '0';
				save_reg(1) <= '0';
			    save_reg(2) <= '0';	
	    elsif(load = '1') then
		    save_reg <= reg3_in;
		end if;
	end if;
	end process;

	reg3_out <= save_reg;
end behav;  
		     