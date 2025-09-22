# Meal Back 🥓

![alt text](/assets/images/image.png)

## Cloning Project

1. Clone this repo

   ```bash
   git clone git@github.com:LeonardoLopesHonda/meal-back.git
   ```

---

## Setting up your machine (Ubuntu - WSL)

1. First install the android-studio

   ```bash
   sudo apt install android-studio
   ```

> Follow the expo [docs](https://docs.expo.dev/workflow/android-studio-emulator)

2. Now set the PATH to `android-sdk`

   ```bash
   nano ~/.bashrc
   ```

3. Write on the end of `.bashrc`:

   ```bash
   export ANDROID_HOME=$HOME/Android/Sdk
   export PATH=$PATH:$ANDROID_HOME/emulator
   export PATH=$PATH:$ANDROID_HOME/platform-tools
   ```

4. Now install these packages:

   ```bash
   sudo apt install -y automake build-essential libtool libssl-dev watchman
   ```

5. Open a device emulator on android studio

![Device Manager - Android Studio](/assets/images/device-manager.png)

> If you're facing permission problems follow [this](https://stackoverflow.com/a/45749003/19612959)

---

## Starting Project

1. Install dependencies

   ```bash
   npm install
   ```

2. Start the app

   ```bash
   npx expo start
   ```

   Or use a npm command on the `package.json`

   ```bash
   npm run
   ```

   > `+` (one of these)

   ```json
   "start": "expo start",
   "android": "expo start --android",
   "ios": "expo start --ios",
   "web": "expo start --web",
   ```


## Histórico de Atualizações do Projeto

---

## 18/08 - Organização de Processos

1.  Divisão das funções dos integrantes do grupo e escolha da linguagem
    > **Leonardo Honda:** Documentação, Organização das Issues, Criação da `main`, Instrução de configuração do ambiente e WSL, Infraestrutura e Desenvolvimento.
    >
    > **Leonardo Neves:** DER, Levantamento de Requisições e Funcionalidades, Estórias.
    >
    > **Matheus Retamozo:** Backlogs e Readme de atualizações.
    >
    > **Mylenna Salles:** Correção do DER, Criação da Interface, Organização do Banco de Dados.

---

## 23/08

1.  Issues criadas (Honda)
2.  Entrega do primeiro DER (Leonardo Neves)
3.  Entrega dos Requisitos e Funcionalidades do App (Mylenna)
4.  Início de desenvolvimento da Infraestrutura (Honda)

---

## 03/09

1.  Correção do DER, primeira atualização (Leonardo Neves)
2.  Término do desenvolvimento da Infraestrutura (Honda)

---

## 08/09

1.  Início das atualizações de Readme e Organização da primeira Sprint real (Retamozo)
2.  Entrega do protótipo de design da Interface de Login do app (Mylenna)
3.  Organização de tarefas e correção de bugs (Honda e Mylenna)
4.  Melhora dos códigos da tela de login e cadastro (Honda)

---

## 13/09

1.  Sprint backlog (Retamozo)
2.  Atualização dos Requisitos, incluindo a lógica de um banco de dados pré-registrado com alunos (Mylenna)
3.  Correção do DER, seguindo os RF e RFN (Mylenna)
4.  Entrega do protótipo da tela de login e cadastro (Honda)

---

## 15/09

1.  Entrega das Estórias (Leonardo Neves)
2.  Atualização do backlog (Retamozo)
3.  Entrega da primeira parte da documentação (Honda)

---

## 20/09

1.  Atualização das estórias (Leonardo Neves)
2.  Incremento da backlog (Retamozo)

---
