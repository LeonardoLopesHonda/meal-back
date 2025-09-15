## PT/BR:

### 1. Requisitos Funcionais (RF)

`1.1`. Cadastro e Autenticação de Estudantes

        RF01: O sistema deve possuir um banco de dados pré-cadastrado com as informações dos estudantes

        RF02: O sistema deve permitir que estudantes cadastrados acessem a aplicação utilizando seu CPF e senha. 

        RF03: O usuário para o primeiro acesso será a parte do e-mail institucional antes do "@" e a senha será o CPF do estudante.

        RF04: Ao realizar o primeiro acesso, o estudante deve ser direcionado a uma tela para a criação de uma nova senha pessoal. 
        
        RF05: Caso o nome de um estudante não conste na base de dados, o aplicativo deve oferecer uma opção para que ele solicite seu registro. 
        
        RF06: Para solicitar o registro, o estudante deverá informar seu nome completo, CPF e um contato (e-mail). 

        RF07: O login no sistema deve ser permitido apenas para estudantes que estão com o curso em andamento, com a matrícula em dia.

        RF08 – O sistema deve enviar a solicitação de registro para análise/admin.

`1.2`. Feedback sobre Merenda

        RF09: Após o login, o estudante deve visualizar uma lista das análises de merenda que estão abertas para feedback. 
        
        RF10: O estudante deve poder selecionar uma análise/opção de refeição para fornecer seu feedback. 

        RF11: Na tela de feedback, o estudante deve poder atribuir uma nota de 0 a 10 para a merenda, sendo este um campo obrigatório. 

        RF12: A tela de feedback pode, opcionalmente, exibir uma imagem do prato de comida avaliado, contendo descrição para leitores de tela. 

        RF13: A tela de feedback deve conter um campo de texto não obrigatório para observações adicionais.
            - Nota obrigatória de 0 a 10
            - Comentário opcional (texto livre)
            - Visualização da imagem do prato (quando disponível)

        RF14 – O estudante só pode enviar um feedback por análise.

`1.3`. Administração

        RF15 - O sistema deve possuir um perfil de administrador com permissões para gerenciar as análises. 

        RF16: O administrador deve poder cadastrar uma nova análise de merenda. 

        RF17: Ao cadastrar uma análise, o administrador deve informar: a descrição da merenda, a data e o período em que foi ofertada, os turnos para os quais a análise será exibida, e a data e hora de encerramento da pesquisa. 

        RF18: O sistema deve gerar um relatório para o administrador com os feedbacks consolidados dos estudantes. 

        RF19: O relatório deve apresentar a nota média geral, a quantidade de votos para cada nota (de 0 a 10), e o número total de estudantes que participaram e que não participaram da pesquisa. 

        RF20: O sistema deve permitir a visualização de informações do relatório de formas variadas, como, por exemplo, agrupadas por turno.


### 2. Requisitos Não Funcionais (RNF)

       RNF01 - Plataforma: O sistema deve ser uma aplicação para dispositivos móveis. 

       RNF02 - Usabilidade: A interface deve ser intuitiva para que os estudantes e administradores consigam realizar suas tarefas sem dificuldades.

       RNF03 - Segurança: As informações dos estudantes, como nome e CPF, devem ser armazenadas de forma segura no banco de dados. 

       RNF04 - Controle de Versão: A equipe de desenvolvimento deverá utilizar o GitHub para controlar todas as versões do projeto. 

       RNF05 - Repositório: O código-fonte do projeto deverá ser mantido em um repositório privado no GitHub, com acesso concedido aos membros da equipe e ao professor. 

       RNF06 - Documentação de Commits: As mensagens de commit no repositório devem seguir boas práticas de escrita e serão consideradas na avaliação do projeto. 

       RNF07 - Metodologia de Desenvolvimento: O projeto deve ser desenvolvido utilizando a abordagem ágil, com a execução de três sprints. 

       RNF08 - Testes: A equipe deve gerar casos de teste para a aplicação, executá-los e registrar os bugs encontrados como issues no GitHub. 

---


## ENG:

### 1. Functional Requirements (FR)

 `1.1. Student Registration and Authentication`

      FR01: The system must have a pre-registered database with student information.

      FR02: The system must allow registered students to access the application using their CPF and password.

      FR03: For the first login, the username will be the part of the institutional email before the "@" and the password will be the student's CPF.

      FR04: Upon first login, the student must be directed to a screen to create a new personal password.

      FR05: If a student's name is not in the database, the application must offer an option for them to request registration.

      FR06: To request registration, the student must provide their full name, CPF, and a contact email.

      FR07: System login must be allowed only for currently enrolled students.

      FR08: The system must send the registration request to an administrator for analysis.
      

 `1.2. Meal Feedback`

      FR09: After logging in, the student must see a list of open meal surveys available for feedback.

      FR10: The student must be able to select a survey/meal option to provide their feedback.

      FR11: On the feedback screen, the student must be able to assign a rating from 0 to 10 for the meal, with this field being mandatory.

      FR12: The feedback screen may optionally display an image of the meal being rated, including a description for screen readers.

      FR13: The feedback screen must contain a non-mandatory text field for additional comments.

                 - Mandatory rating from 0 to 10 
                 - Optional comment (free text) 
                 - View meal image (when available) 

      FR14: The student can only submit one feedback per survey.

 `1.3. Administration`

      FR15: The system must have an administrator profile with permissions to manage surveys.

      FR16: The administrator must be able to create a new meal survey.

      FR17: When creating a survey, the administrator must provide: the meal description, the date and period it was offered, the shifts for which the survey will be displayed, and the survey's end date and time.

      FR18: The system must generate a report for the administrator with consolidated student feedback.

      FR19: The report must present the overall average score, the count of votes for each score (from 0 to 10), and the total number of students who participated and did not participate in the survey.

      FR20: The system must allow the report information to be viewed in various ways, such as grouped by shift.


## 2. Non-Functional Requirements (NFR)

      NFR01 - Platform: The system must be a mobile application.

      NFR02 - Usability: The interface must be intuitive so that students and administrators can perform their tasks without difficulty.

      NFR03 - Security: Student information, such as name and CPF, must be stored securely in the database.

      NFR04 - Version Control: The development team must use GitHub to control all project versions.

      NFR05 - Repository: The project's source code must be kept in a private GitHub repository, with access granted to team members and the professor.

      NFR06 - Commit Documentation: Commit messages in the repository must follow good writing practices and will be considered in the project evaluation.

      NFR07 - Development Methodology: The project must be developed using an agile approach, with the execution of three sprints.

      NFR08 - Testing: The team must generate test cases for the application, execute them, and log any bugs found as issues on GitHub.
