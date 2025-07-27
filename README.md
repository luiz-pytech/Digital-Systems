# Sistemas Digitais: Práticas e Projeto Final (DCA3301)

![Linguagem](https://img.shields.io/badge/Linguagem-VHDL-blue.svg)
![Ferramentas](https://img.shields.io/badge/Ferramentas-Quartus%20%7C%20ModelSim-lightgrey)
![Status](https://img.shields.io/badge/status-concluído-green)

## 🎯 Visão Geral

Este repositório contém todas as práticas de laboratório e o projeto final desenvolvidos na disciplina **Sistemas Digitais — Prática (DCA3301.1)**, ministrada no curso de Engenharia de Computação.

O objetivo é documentar a jornada de aprendizado em VHDL, desde a implementação de circuitos combinacionais básicos até o desenvolvimento de um sistema RTL (Register-Transfer Level) completo e funcional.

---

## 🗂️ Estrutura do Repositório

O conteúdo está organizado em duas seções principais para facilitar a navegação:

### 🌟 Projeto Final
O projeto de conclusão da disciplina, que integra todos os conceitos aprendidos em um sistema sequencial complexo.

➡️ **[Ver detalhes do Projeto Final](./00_Projeto_Final_Cambio_Automatico/)**

### 🔬 Práticas de Laboratório
Uma coleção dos exercícios semanais que construíram a base de conhecimento em VHDL, cobrindo desde lógica combinacional até máquinas de estado.

➡️ **[Ver índice das Práticas de Laboratório](./01_Praticas_de_Laboratorio/)**

---

## 🛠️ Ferramentas e Tecnologias

* **VHDL:** Linguagem de descrição de hardware utilizada para modelar, simular e sintetizar os circuitos.
* **Intel Quartus Prime:** Ferramenta para síntese, compilação, análise de tempo e programação de FPGAs da família Altera/Intel.
* **ModelSim:** Software para simulação funcional e verificação do comportamento lógico dos circuitos VHDL antes da implementação em hardware.
* **FPGA DE10-Lite:** Placa de desenvolvimento utilizada para a implementação física, testes e validação dos projetos. _(Sugestão: Se usou outra placa, altere o nome aqui)_.

---

## 🚀 Como Executar os Projetos

1.  Navegue até a pasta do projeto ou prática desejada (`00_...` ou `01_...`).
2.  Abra o arquivo de projeto `.qpf` no **Intel Quartus Prime**.
3.  Compile o projeto para verificar a sintaxe e sintetizar o circuito.
4.  Para simulação, utilize o **ModelSim** para visualizar as formas de onda e validar a lógica.
5.  Para testes em hardware, grave o arquivo de programação (`.sof`) na placa **FPGA**.

*Nota: Cada seção principal contém um `README.md` específico com mais detalhes sobre a implementação.*

---