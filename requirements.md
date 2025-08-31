PT/BR:
1. Requisitos Funcionais (RF)

1.1. Cadastro e Autenticação de Estudantes

RF01 – O estudante deve poder realizar login informando CPF e senha.

RF02 – Se o estudante ainda não tiver senha cadastrada, deve poder criar uma senha.

RF03 – Para criação de senha, o sistema deve verificar se o nome informado existe na base de dados e validar com o CPF.

RF04 – Caso o nome não exista na base, o estudante deve poder solicitar registro informando:

Nome completo

CPF

Contato (e-mail ou telefone)


RF05 – O sistema deve enviar a solicitação de registro para análise/admin.


1.2. Feedback sobre Merenda

RF06 – O estudante, ao acessar, deve visualizar as análises de merenda abertas.

RF07 – O estudante deve poder selecionar uma análise e registrar o feedback com:

Nota obrigatória de 0 a 10

Comentário opcional (texto livre)

Visualização da imagem do prato (quando disponível)


RF08 – O estudante só pode enviar um feedback por análise.


1.3. Administração

RF09 – O administrador deve poder cadastrar uma nova análise de merenda, informando:

Descrição da merenda oferecida

Data em que foi ofertada

Período (manhã, tarde, noite)

Turnos aos quais a análise se aplica

Data e hora de encerramento da análise


RF10 – O administrador deve poder encerrar uma análise manualmente antes do prazo.


1.4. Relatórios e Estatísticas

RF11 – O sistema deve gerar relatórios com os seguintes dados:

Nota média geral

Quantidade de cada nota (0 a 10)

Número total de estudantes que responderam

Número de estudantes que não responderam


RF12 – O administrador deve poder visualizar resultados agrupados por turno.


2. Requisitos Não Funcionais (RNF)

RNF01 – O aplicativo deve ter autenticação segura (armazenar senha com hash).

RNF02 – O sistema deve ter interface simples e intuitiva (foco em usabilidade para estudantes).

RNF03 – O tempo de resposta do sistema deve ser inferior a 2 segundos em consultas comuns.

RNF04 – O app deve ser multiplataforma (Android, iOS) ou acessível via PWA.

RNF05 – O sistema deve registrar logs de operações administrativas.


__________________________________________________________________________________________


ENG:

1. Functional Requirements (FR)

1.1. Student Registration and Authentication

FR01 – Students must be able to log in using their CPF number and password.

FR02 – If students do not yet have a registered password, they must be able to create one.

RF03 – To create a password, the system must verify that the name entered exists in the database and validate it with the CPF.

RF04 – If the name does not exist in the database, students must be able to request registration by entering:

Full name

CPF

Contact details (email or phone number)


RF05 – The system must send the registration request for review/admin.


1.2. Feedback on School Meals

RF06 – When accessing the system, students must be able to view open school meal reviews.

RF07 – Students must be able to select a review and register their feedback with:

Mandatory score from 0 to 10

Optional comment (free text)

Image of the dish (when available)


RF08 – Students can only submit one feedback per review.


1.3. Administration

RF09 – The administrator must be able to register a new school meal review, providing:

Description of the meal offered

Date it was offered

Period (morning, afternoon, evening)

Shifts to which the review applies

Date and time of analysis closure


RF10 – The administrator must be able to manually close an analysis before the deadline.


1.4. Reports and Statistics

RF11 – The system must generate reports with the following data:

Overall average score

Number of each score (0 to 10)

Total number of students who responded

Number of students who did not respond


RF12 – The administrator must be able to view results grouped by shift.


2. Non-Functional Requirements (RNF)

RNF01 – The application must have secure authentication (store password with hash).

RNF02 – The system must have a simple and intuitive interface (focus on usability for students).

RNF03 – The system response time must be less than 2 seconds for common queries.

RNF04 – The app must be multiplatform (Android, iOS) or accessible via PWA.

RNF05 – The system must record logs of administrative operations.
