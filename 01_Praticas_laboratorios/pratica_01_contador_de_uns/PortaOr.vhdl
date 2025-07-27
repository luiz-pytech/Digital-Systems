ENTITY PortaOr IS
  PORT(input1, input2 : IN BIT;
       saida_or : OUT BIT);
END PortaOr;

ARCHITECTURE behav OF PortaOr IS
BEGIN
  saida_or <= input1 OR input2;
END ARCHITECTURE behav;
