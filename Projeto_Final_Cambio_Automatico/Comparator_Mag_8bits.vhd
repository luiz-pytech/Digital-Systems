library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Comparator_Mag_8bits is
    port(
        A, B: in std_logic_vector(7 downto 0);
        lt, eq, gt: out std_logic
    );
end Comparator_Mag_8bits;

architecture behav of Comparator_Mag_8bits is
begin

    lt <= ( (not A(7) and B(7)) or
            ((A(7) xnor B(7)) and not A(6) and B(6)) or
            ((A(7) xnor B(7)) and (A(6) xnor B(6)) and not A(5) and B(5)) or
            ((A(7) xnor B(7)) and (A(6) xnor B(6)) and (A(5) xnor B(5)) and not A(4) and B(4)) or
            ((A(7) xnor B(7)) and (A(6) xnor B(6)) and (A(5) xnor B(5)) and (A(4) xnor B(4)) and not A(3) and B(3)) or
            ((A(7) xnor B(7)) and (A(6) xnor B(6)) and (A(5) xnor B(5)) and (A(4) xnor B(4)) and (A(3) xnor B(3)) and not A(2) and B(2)) or
            ((A(7) xnor B(7)) and (A(6) xnor B(6)) and (A(5) xnor B(5)) and (A(4) xnor B(4)) and (A(3) xnor B(3)) and (A(2) xnor B(2)) and not A(1) and B(1)) or
            ((A(7) xnor B(7)) and (A(6) xnor B(6)) and (A(5) xnor B(5)) and (A(4) xnor B(4)) and (A(3) xnor B(3)) and (A(2) xnor B(2)) and (A(1) xnor B(1)) and not A(0) and B(0)) );

    eq <= (A(7) xnor B(7)) and (A(6) xnor B(6)) and (A(5) xnor B(5)) and (A(4) xnor B(4)) and 
           (A(3) xnor B(3)) and (A(2) xnor B(2)) and (A(1) xnor B(1)) and (A(0) xnor B(0));

    gt <= ( (A(7) and not B(7)) or
            ((A(7) xnor B(7)) and A(6) and not B(6)) or
            ((A(7) xnor B(7)) and (A(6) xnor B(6)) and A(5) and not B(5)) or
            ((A(7) xnor B(7)) and (A(6) xnor B(6)) and (A(5) xnor B(5)) and A(4) and not B(4)) or
            ((A(7) xnor B(7)) and (A(6) xnor B(6)) and (A(5) xnor B(5)) and (A(4) xnor B(4)) and A(3) and not B(3)) or
            ((A(7) xnor B(7)) and (A(6) xnor B(6)) and (A(5) xnor B(5)) and (A(4) xnor B(4)) and (A(3) xnor B(3)) and A(2) and not B(2)) or
            ((A(7) xnor B(7)) and (A(6) xnor B(6)) and (A(5) xnor B(5)) and (A(4) xnor B(4)) and (A(3) xnor B(3)) and (A(2) xnor B(2)) and A(1) and not B(1)) or
            ((A(7) xnor B(7)) and (A(6) xnor B(6)) and (A(5) xnor B(5)) and (A(4) xnor B(4)) and (A(3) xnor B(3)) and (A(2) xnor B(2)) and (A(1) xnor B(1)) and A(0) and not B(0)) );

end architecture behav;