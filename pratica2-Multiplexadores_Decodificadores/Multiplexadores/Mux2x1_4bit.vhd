ENTITY Mux2x1_4bit IS
    PORT(
        A   : IN BIT_VECTOR(3 DOWNTO 0);
        B   : IN BIT_VECTOR(3 DOWNTO 0);
        SEL : IN BIT;
        Y   : OUT BIT_VECTOR(3 DOWNTO 0)
    );
END;

ARCHITECTURE behav OF Mux2x1_4bit IS
BEGIN
    Y(0) <= (A(0) AND (NOT SEL)) OR (B(0) AND SEL);
    Y(1) <= (A(1) AND (NOT SEL)) OR (B(1) AND SEL);
    Y(2) <= (A(2) AND (NOT SEL)) OR (B(2) AND SEL);
    Y(3) <= (A(3) AND (NOT SEL)) OR (B(3) AND SEL);
END;
