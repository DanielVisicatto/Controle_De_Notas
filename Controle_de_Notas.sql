CREATE DATABASE Controle_de_Notas
GO
USE Controle_de_Notas
GO

BEGIN TRANSACTION
CREATE TABLE [Aluno](
    Nome                VARCHAR (100)           NOT NULL,
    RA                  VARCHAR (12)            NOT NULL,

    CONSTRAINT PK_Aluno                                       PRIMARY KEY (RA)
)
GO

CREATE TABLE [Disciplina](
    Nome                VARCHAR (30)            NOT NULL,
    Carga_Horária       SMALLINT                NOT NULL,
    ID_Disciplina       INT                     NOT NULL,

    CONSTRAINT PK_Disciplina                                  PRIMARY KEY (ID_Disciplina)
)
GO

CREATE TABLE [Matricula](
    ID_Matricula        INT IDENTITY (1,1),
    RA_Aluno            VARCHAR (12)            NOT NUll,
    Ano                 SMALLINT                NOT NULL,
    Semestre            SMALLINT                NOT NULL,

    CONSTRAINT PK_MAtricula                                   PRIMARY KEY(ID_matricula),
    CONSTRAINT FK_Matricula_RA_Aluno                          FOREIGN KEY(RA_Aluno)                         REFERENCES Aluno (RA),
    -- temos de tornar uma restricao para que nossos dados nao sejam repetidos se juntos
    CONSTRAINT UN_Matricula                                   UNIQUE (RA_Aluno, Ano, Semestre)
)
GO

CREATE TABLE [Disciplina_matricula](
    ID_Matricula        INT                     NOT NULL,
    ID_Disciplina       INT                     NOT NULL,
    Situacao            VARCHAR (19)            NOT NUll,
    Nota_1              NUMERIC (4,2),
    Nota_2              NUMERIC (4,2),
    Nota_Subs           NUMERIC (4,2),
    Falta               SMALLINT,

    CONSTRAINT PK_Disciplina_Matricula                       PRIMARY KEY (ID_Matricula, ID_Disciplina),
    CONSTRAINT FK_Disciplina_Matricula_Codigo_Matricula      FOREIGN KEY (ID_Matricula)                     REFERENCES Matricula (ID_Matricula),
    CONSTRAINT FK_Dusciplina_Matricula_ID_disciplina         FOREIGN KEY (ID_Disciplina)                    REFERENCES Disciplina (ID_Disciplina)
)
COMMIT

--Selects Simples
SELECT * FROM [Aluno]
SELECT * FROM [Matricula]
SELECT * FROM [Disciplina]
SELECT * FROM [Disciplina_matricula]

--Inserts
INSERT INTO [Aluno]                 VALUES ('Giovani', 1);
INSERT INTO [Aluno] (RA, Nome)      VALUES (2, 'Ana Maria')
INSERT INTO [Aluno]                 VALUES ('Daniel', 3)

INSERT INTO [Disciplina]            VALUES ('Banco de Dados', 80, 1), ('IA', 80, 2), ('S.O.', 60, 3)

INSERT INTO [Matricula]             VALUES (3,2023,1)
INSERT INTO [Matricula]             VALUES (2,2023,2)
INSERT INTO [Matricula]             VALUES (1,2023,2)

INSERT INTO [Disciplina_matricula] (ID_Matricula, ID_Disciplina, Falta, Situacao)
VALUES (1, 1, 0, 'Matriculado')
INSERT INTO [Disciplina_matricula] (ID_Matricula, ID_Disciplina, Falta, Situacao)
VALUES (1, 2, 0, 'Matriculado')
INSERT INTO [Disciplina_matricula] (ID_Matricula, ID_Disciplina, Falta, Situacao)
VALUES (2, 1, 0, 'Matriculado')

--Updates
-- Usamos o Update [TABELA] SET COLUNA = DADOS WHERE ..... para fazer alguma alteração de valor em uma coluna da nossa tabela.
UPDATE [Disciplina]
SET Nome = 'Inteligência Artificial', Carga_Horária = 100
WHERE ID_Disciplina =2

UPDATE [Disciplina_matricula]
SET Falta = 666
WHERE ID_Matricula =3 AND ID_Disciplina =2
SELECT * FROM [Disciplina_matricula]

UPDATE [Disciplina_matricula]
SET Situacao = 'Matriculado'
WHERE ID_Matricula = 3 AND ID_Disciplina =2

UPDATE [Disciplina_matricula] SET Nota_1 = 6.0, Nota_2 = 6.0
WHERE ID_Matricula = 3 AND ID_Disciplina = 2

-- ALter Table
ALTER TABLE [Disciplina_matricula]
ADD
 Media              NUMERIC(4,2)
GO

--Select Join
SELECT m.Ano, m.Semestre, a.Nome, d.Nome
FROM Aluno a JOIN Matricula m ON a.RA = m.RA_Aluno
    JOIN Disciplina_matricula dm ON m.ID_Matricula = dm.ID_Matricula
    JOIN Disciplina d ON dm.ID_Disciplina = d.ID_Disciplina;

-- Colocando as notas e tentando tirar a média 
DELETE [Disciplina_matricula]
INSERT INTO [Disciplina_matricula] (ID_Matricula, ID_Disciplina, Nota_1, Nota_2, Nota_Subs, Falta, Situacao)
VALUES (1, 1, 6.50, 7.50, 8.0,  0, 'Matriculado')
INSERT INTO [Disciplina_matricula] (ID_Matricula, ID_Disciplina, Nota_1, Nota_2, Nota_Subs, Falta, Situacao)
VALUES (1, 2, 4.5, 7.0, 3.5, 0, 'Matriculado')
INSERT INTO [Disciplina_matricula] (ID_Matricula, ID_Disciplina, Nota_1, Nota_2, Nota_Subs, Falta, Situacao)
VALUES (2, 1, 6.0, 6.5, 5.5, 0, 'Matriculado')
INSERT INTO [Disciplina_matricula] (ID_Matricula, ID_Disciplina, Nota_1, Nota_2, Nota_Subs, Falta, Situacao)
VALUES (3, 2, 0.0, 8.0, 8.5, 0, 'Matriculado')
INSERT INTO [Disciplina_matricula] (ID_Matricula, ID_Disciplina, Nota_1, Nota_2, Nota_Subs, Falta, Situacao)
VALUES (3, 2, 0.0, 8.0, 8.5, 0, 'Matriculado')



SELECT 
a.Nome,
"Media" = CASE 
    WHEN (dm.Nota_Subs IS NULL) THEN (dm.Nota_1 + Nota_2) / 2
    WHEN (dm.Nota_Subs > dm.Nota_1) AND (dm.Nota_1 < dm.Nota_2) THEN (dm.Nota_Subs + dm.Nota_2) / 2
    WHEN (dm.Nota_Subs > dm.Nota_2) AND (dm.Nota_2 < dm.Nota_1) THEN (dm.Nota_Subs + dm.Nota_1) / 2   
   
END
FROM Aluno a JOIN Disciplina_matricula dm ON a.RA = dm.ID_Matricula
SELECT * FROM [Disciplina_matricula]

--CAGADA!!!! Cade o WHERE???!!!
--UPDATE [Disciplina]
--SET Nome = 'Inteligência Artificial', Carga_Horária = 100

--BEGIN TRANSACTION
--ROLLBACK
--COMMIT

--Vamos fazer uma trigger que calcula nossa média automaticamente, a partir da inserção da nota 2
-- Uma Trigger é acionada por gatilho, enquanto uma Procedure precisa ser executada, mas pode ser executada sempre que quisermos.
-- Agora vamos criar uma outra trigger que vai mudar a situação do aluno baseada na média.
-- Verificar quantidade de faltas da matéria, se for maior que a metade da carga, reprovado.