
CREATE OR ALTER TRIGGER TGR_Media_INsert ON [Disciplina_matricula] AFTER UPDATE-- Depois de atualizar dados nesta tabela
--Esta trigger sempre é executada ap-s um UPDATE na nossa tabela, poderia ser feito em qqr DML
AS
BEGIN
    IF (UPDATE(Nota_2))-- Só executa a trigger se houver update na coluna Nota_2
    BEGIN
    -- 1º Declara os valores nas variáveis
        DECLARE @ID_Matricula INT, @ID_Disciplina INT, @Nota_1 NUMERIC(4,2), @Nota_2 NUMERIC(4,2), @Media NUMERIC (4,2)    
    -- 2º Atribui os valores na tabela que estamos inserindo
         SELECT @ID_Matricula = ID_Matricula, @ID_Disciplina = ID_Disciplina, @Nota_1 = Nota_1, @Nota_2 = Nota_2 FROM INSERTED
    -- 3º Executa o comando ou a regra que precisamos.
         SET @Media = (@Nota_1 + @Nota_2) / 2 
    -- 4º Atualiza a tabela com o valor calculado de Média
        UPDATE [Disciplina_matricula] SET Media = @Media 
        WHERE ID_Matricula = @ID_Matricula AND ID_Disciplina = @ID_Disciplina   --(SUPER!!) SEMPRE COLOCAR ONDE VAI SER FEIRA A ALTERAÇÃO PQ SENÃO TUDO É ALTERADO!!
    END
END;
GO

CREATE OR ALTER TRIGGER TGR_Altera_Situacao ON [Disciplina_matricula] AFTER UPDATE
AS
BEGIN
    IF (UPDATE(Media)) -- só vai executar se houver um UPDATE na coluna Media
    BEGIN
        DECLARE @ID_Matricula INT, @ID_Disciplina INT, @Media NUMERIC (4,2), @Situacao VARCHAR(19)
        SELECT @ID_Matricula = ID_Matricula, @ID_Disciplina = ID_Disciplina, @Situacao = Situacao, @Media = Media FROM INSERTED
        SET @Situacao = CASE 
            WHEN (@Media >= 5) THEN 'Aprovado'
            ELSE 'Reprovado'
        END
            PRINT(@Situacao) -- Só para mostrar a atual situação.

         UPDATE[Disciplina_matricula] SET Situacao = @Situacao  
         WHERE ID_Matricula = @ID_Matricula AND ID_Disciplina = @ID_Disciplina   --(SUPER!!) SEMPRE COLOCAR ONDE VAI SER FEIRA A ALTERAÇÃO PQ SENÃO TUDO É ALTERADO!!
    END
END;
GO

CREATE OR ALTER TRIGGER TGR_Situacao_Por_Faltas ON [Disciplina_matricula] AFTER UPDATE
AS
BEGIN
    IF (UPDATE(Falta))
    BEGIN        
        DECLARE @ID_Matricula INT, @ID_Disciplina INT, @Falta INT, @Carga SMALLINT, @Situacao VARCHAR(19)

        SELECT @ID_Matricula = i.ID_Matricula, @ID_Disciplina = i.ID_Disciplina, @Falta = i.Falta, @Carga = d.Carga_Horária, @Situacao = i.Situacao 
        FROM inserted i
        JOIN [Disciplina] d ON i.ID_Disciplina = d.ID_Disciplina              

        SET @Situacao = CASE 
            WHEN (@Falta > (@Carga / 2)) THEN 'Reprovado_Faltas'
            ELSE 'Aprovado'
        END
        PRINT(@Situacao)

        UPDATE[Disciplina_matricula] SET Situacao = @Situacao        
        WHERE ID_Matricula = @ID_Matricula AND ID_Disciplina = @ID_Disciplina
        PRINT('Passei aqui')
    END
END;
GO

SELECT * FROM [Disciplina_matricula] JOIN [Disciplina] ON Disciplina_matricula.ID_Disciplina = Disciplina.ID_Disciplina