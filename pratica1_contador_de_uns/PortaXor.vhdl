ENTITY PortaXor IS
  PORT(entXor1, entXor2 : IN BIT;
       saida_xor : OUT BIT);
END PortaXor;

ARCHITECTURE behav OF PortaXor IS
BEGIN
  saida_xor <= entXor1 XOR entXor2;
END ARCHITECTURE behav;
