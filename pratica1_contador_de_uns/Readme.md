# Prática 1 - Circuitos Digitais
- Projeto: Circuito contador de 1's (uns)
- Disciplina: Sistemas Digitais - Prática: DCA3303.1
- Aluno: Luiz Felipe de Souza Silva

## Objetivos do circuito
- Projetar um circuito que, a partir das entradas A, B e C, indique nas saídas S1 e S2 a quantidade de bits ‘1’ presentes.
- Montar tabela verdade, simplificar equações, desenhar o circuito lógico, implementar em VHDL, simular no Quartus e mapear na FPGA.

## Tabela verdade
| A | B | C | S1 | S2 |
|---|---|---|----|----|
| 0 | 0 | 0 | 0  | 0  |
| 0 | 0 | 1 | 0  | 1  |
| 0 | 1 | 0 | 0  | 1  |
| 0 | 1 | 1 | 1  | 0  |
| 1 | 0 | 0 | 0  | 1  |
| 1 | 0 | 1 | 1  | 0  |
| 1 | 1 | 0 | 1  | 0  |
| 1 | 1 | 1 | 1  | 1  |

## Equações simplificadas
- S1 = BC + A(B xor C)
- S2 = A XOR B XOR C

## Circuito em portas lógicas

## Códigos em VHDL
- [Porta AND](https://github.com/luiz-pytech/Praticas_Sistemas_Digitais/pratica1_contador_de_uns/PortaAnd.vhdl)
- [Porta OR](https://github.com/luiz-pytech/Praticas_Sistemas_Digitais/pratica1_contador_de_uns/PortaOr.vhdl)
- [Porta Xor](https://github.com/luiz-pytech/Praticas_Sistemas_Digitais/pratica1_contador_de_uns/PortaXor.vhdl)
- [Contador de Bits](https://github.com/luiz-pytech/Praticas_Sistemas_Digitais/pratica1_contador_de_uns/bitsContador.vhdl)

## Simulação
- Foram utilizados o Quartus e o ModelSim e simulação de todas as entradas possíveis de ABC e verificando os leds.
