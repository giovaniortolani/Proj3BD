CREATE TABLE FUNCAO_PESSOA (
	FUNCAO VARCHAR2(10) NOT NULL,
	NUM_PASSAPORTE VARCHAR2(11) NOT NULL,
	
	CONSTRAINT PK_FUNCAO_PESSOA PRIMARY KEY (NUM_PASSAPORTE)
);

CREATE TABLE NACAO (
	NOME_NACAO VARCHAR2(30) NOT NULL,
	NOME_CONTINENTE VARCHAR2(20) NOT NULL,
	QTD_ATLETAS NUMBER NOT NULL ,
	HINO VARCHAR2(2000) NOT NULL, 
	ESPORTE_FAVORITO VARCHAR2(30) NOT NULL,
	BANDEIRA VARCHAR2(50) NOT NULL,
	
  	CONSTRAINT CK_CONTINENTE CHECK (NOME_CONTINENTE IN ('AFRICA', 'AMERICA', 'ASIA', 'EUROPA', 'OCEANIA')),
	CONSTRAINT PK_NACAO PRIMARY KEY (NOME_NACAO),
	CONSTRAINT CK_QTD_ATLETAS CHECK (QTD_ATLETAS > 0)
);

CREATE TABLE EMAIL (
	EMAIL_NOME VARCHAR2(40) NOT NULL,
	SENHA VARCHAR2(20) NOT NULL,
	
	CONSTRAINT PK_EMAIL PRIMARY KEY (EMAIL_NOME)
);

CREATE TABLE MODALIDADE (
	CODIGO_MODALIDADE NUMBER NOT NULL,
	NOME_MODALIDADE VARCHAR(30) NOT NULL,
	DESCRICAO_MODALIDADE VARCHAR2(100) NOT NULL,
	
	CONSTRAINT PK_MODALIDADE PRIMARY KEY (CODIGO_MODALIDADE),
	CONSTRAINT SK_MODALIDADE UNIQUE (NOME_MODALIDADE)
);

CREATE TABLE PREPARADOR (
	NUM_PASSAPORTE VARCHAR2(11) NOT NULL,
	NOME_PREPARADOR VARCHAR(60) NOT NULL,
	DATA_NASCIMENTO DATE NOT NULL,
	SEXO CHAR(1) NOT NULL,
	CIDADE_PREPARADOR VARCHAR(30),
	ESTADO_PREPARADOR VARCHAR(30),
	PAIS_PREPARADOR VARCHAR(30) NOT NULL,
	EMAIL_NOME VARCHAR2(40) NOT NULL,
	
    CONSTRAINT CK_PREPARADOR_SEXO  CHECK(SEXO IN ('M', 'F')),
	CONSTRAINT PK_PREPARADOR PRIMARY KEY (NUM_PASSAPORTE),
	CONSTRAINT SK_PREPARADOR UNIQUE (EMAIL_NOME),
	CONSTRAINT FK_PREPARADOR_NACAO FOREIGN KEY (PAIS_PREPARADOR) REFERENCES NACAO(NOME_NACAO) ON DELETE CASCADE,
	CONSTRAINT FK_PREPARADOR_EMAIL FOREIGN KEY (EMAIL_NOME) REFERENCES EMAIL(EMAIL_NOME) ON DELETE CASCADE,
	CONSTRAINT FK_PREPARADOR_FUNCAOPESSOA FOREIGN KEY (NUM_PASSAPORTE) REFERENCES FUNCAO_PESSOA(NUM_PASSAPORTE) ON DELETE CASCADE
);

CREATE TABLE PREPARADOR_TELEFONE (
	PREPARADOR VARCHAR2(11) NOT NULL,
	TELEFONE VARCHAR(20) NOT NULL,
	
	CONSTRAINT PK_PREPARADOR_TELEFONE PRIMARY KEY (PREPARADOR, TELEFONE),
	CONSTRAINT FK_PREPARADOR_TEL_PREPARADOR FOREIGN KEY (PREPARADOR) REFERENCES PREPARADOR(NUM_PASSAPORTE)  ON DELETE CASCADE
);

CREATE TABLE ATLETA (
	NUM_PASSAPORTE VARCHAR2(11) NOT NULL,
	NOME VARCHAR2(60) NOT NULL,
	DATA_NASCIMENTO DATE NOT NULL,
	SEXO CHAR(1) NOT NULL,
	PESO NUMBER(5,2) NOT NULL,
	ALTURA NUMBER(3,2) NOT NULL,
	SITUACAO VARCHAR2(20) DEFAULT 'REGULAR' NOT NULL,
	N_PUNICOES NUMBER(1) DEFAULT 0 NOT NULL,
	MODALIDADE NUMBER NOT NULL,
	PAIS_ATLETA VARCHAR2(30) NOT NULL,
	PREPARADOR VARCHAR2(11) NOT NULL,
	
    CONSTRAINT CK_ATLETA_SEXO  CHECK(SEXO IN ('M', 'F')),
	CONSTRAINT CK_PESO CHECK (PESO > 0 AND PESO < 300),
	CONSTRAINT CK_ALTURA CHECK (ALTURA > 0 AND ALTURA < 3),
	CONSTRAINT CK_SITUACAO CHECK (SITUACAO IN ('REGULAR', 'IRREGULAR', 'RECUPERADO', 'BANIDO')),
	CONSTRAINT CK_NPUNICOES CHECK (N_PUNICOES >= 0 AND N_PUNICOES <= 3),
	CONSTRAINT PK_ATLETA PRIMARY KEY (NUM_PASSAPORTE),
	CONSTRAINT FK_ATLETA_FUNCAOPESSOA FOREIGN KEY (NUM_PASSAPORTE) REFERENCES FUNCAO_PESSOA(NUM_PASSAPORTE)  ON DELETE CASCADE,
	CONSTRAINT FK_ATLETA_MODALIDADE FOREIGN KEY (MODALIDADE) REFERENCES MODALIDADE(CODIGO_MODALIDADE)  ON DELETE CASCADE,
	CONSTRAINT FK_ATLETA_NACAO FOREIGN KEY (PAIS_ATLETA) REFERENCES NACAO(NOME_NACAO)  ON DELETE CASCADE,
	CONSTRAINT FK_ATLETA_PREPARADOR FOREIGN KEY (PREPARADOR) REFERENCES PREPARADOR(NUM_PASSAPORTE) ON DELETE CASCADE
);

CREATE TABLE TREINO (
	CODIGO_TREINO NUMBER NOT NULL,
	DESCRICAO_TREINO VARCHAR2(300) NOT NULL,
	ALIMENTACAO VARCHAR2(300) NOT NULL,
	
	CONSTRAINT PK_TREINO PRIMARY KEY (CODIGO_TREINO)
);

CREATE TABLE RECUPERACAO (
	CODIGO_RECUPERACAO NUMBER NOT NULL,
	DESCRICAO_RECUPERACAO VARCHAR2(100) NOT NULL,
	DESCANSO VARCHAR2(100) NOT NULL,
	
	CONSTRAINT PK_RECUPERACAO PRIMARY KEY (CODIGO_RECUPERACAO)
);

CREATE TABLE MEDICO (
	CRM VARCHAR2(15) NOT NULL,
	DOC_IDENTIDADE VARCHAR2(8) NOT NULL,
	ENDERECO VARCHAR2(40) NOT NULL,
	NOME VARCHAR2(60) NOT NULL,
	
	CONSTRAINT PK_MEDICO PRIMARY KEY (CRM)
);

CREATE TABLE MEDICO_TELEFONE (
	MEDICO VARCHAR2(11) NOT NULL,
	TELEFONE VARCHAR(20) NOT NULL,
	
	CONSTRAINT PK_MEDICO_TELEFONE PRIMARY KEY (MEDICO, TELEFONE),
	CONSTRAINT FK_MEDICO_TEL_MEDICO FOREIGN KEY (MEDICO) REFERENCES MEDICO(CRM) ON DELETE CASCADE
);

CREATE TABLE ROTINA (
	CODIGO_ROTINA NUMBER NOT NULL,
	TEMPO_EXECUCAO NUMBER(2) NOT NULL,
	DIA_SEMANA VARCHAR2(55) NOT NULL,
	PREPARADOR VARCHAR2(11) NOT NULL,
	TREINO NUMBER NOT NULL,
	RECUPERACAO NUMBER,
	
	CONSTRAINT CK_TEMPO_EXECUCAO CHECK (TEMPO_EXECUCAO >= 0 AND TEMPO_EXECUCAO <= 24),
	CONSTRAINT PK_ROTINA PRIMARY KEY (CODIGO_ROTINA),
	CONSTRAINT FK_ROTINA_PREPARADOR FOREIGN KEY (PREPARADOR) REFERENCES PREPARADOR(NUM_PASSAPORTE) ON DELETE CASCADE,
	CONSTRAINT FK_ROTINA_TREINO FOREIGN KEY (TREINO) REFERENCES TREINO(CODIGO_TREINO) ON DELETE CASCADE,
	CONSTRAINT FK_ROTINA_RECUPERACAO FOREIGN KEY (RECUPERACAO) REFERENCES RECUPERACAO(CODIGO_RECUPERACAO) ON DELETE CASCADE
);

CREATE TABLE ATENDIMENTO (
	MEDICO VARCHAR2(15) NOT NULL,
	ATLETA VARCHAR2(11) NOT NULL,
	
	CONSTRAINT PK_ATENDIMENTO PRIMARY KEY (ATLETA, MEDICO),
	CONSTRAINT FK_ATENDIMENTO_MEDICO FOREIGN KEY (MEDICO) REFERENCES MEDICO(CRM) ON DELETE CASCADE,
	CONSTRAINT FK_ATENDIMENTO_ATLETA FOREIGN KEY (ATLETA) REFERENCES ATLETA(NUM_PASSAPORTE) ON DELETE CASCADE
);

CREATE TABLE ATLETA_ROTINA (
	ATLETA VARCHAR2(11) NOT NULL,
	ROTINA NUMBER NOT NULL,
	
	CONSTRAINT PK_ATLETA_ROTINA PRIMARY KEY (ATLETA, ROTINA),
	CONSTRAINT FK_ATLETAROTINA_ROTINA FOREIGN KEY (ROTINA) REFERENCES ROTINA(CODIGO_ROTINA) ON DELETE CASCADE,
	CONSTRAINT FK_ATLETAROTINA_ATLETA FOREIGN KEY (ATLETA) REFERENCES ATLETA(NUM_PASSAPORTE) ON DELETE CASCADE
);

CREATE TABLE DIAGNOSTICO (
	CODIGO_DIAGNOSTICO NUMBER NOT NULL,
	DESCRICAO VARCHAR2(300) NOT NULL,
	
	CONSTRAINT PK_DIAGNOSTICO PRIMARY KEY (CODIGO_DIAGNOSTICO)
);

CREATE TABLE TIPO_OCORRENCIA (
	OCORRENCIA NUMBER NOT NULL,
	TIPO VARCHAR2(6) NOT NULL,
	
	CONSTRAINT PK_TIPO_OCORRENCIA PRIMARY KEY (OCORRENCIA),
	CONSTRAINT CK_TIPO_OCORRENCIA CHECK (TIPO IN ('TESTE', 'DOPING'))
);

CREATE TABLE TRATAMENTO (
	CODIGO_TRATAMENTO NUMBER NOT NULL,
	DIAGNOSTICO NUMBER NOT NULL,
	DESC_EFETIVIDADE VARCHAR2(100) NOT NULL,
	DESC_METODO VARCHAR2(300) NOT NULL,
	
	CONSTRAINT PK_TRATAMENTO PRIMARY KEY (CODIGO_TRATAMENTO),
	CONSTRAINT FK_TRATAMENTO_DIAGNOSTICO FOREIGN KEY (DIAGNOSTICO) REFERENCES DIAGNOSTICO(CODIGO_DIAGNOSTICO) ON DELETE CASCADE
);

CREATE TABLE TESTE_DOPING (
	CODIGO_TESTE_DOPING NUMBER NOT NULL,
	DATA_TESTE DATE NOT NULL,
	ATLETA VARCHAR2(15) NOT NULL,
	MEDICO VARCHAR2(11) NOT NULL,
	RESULTADO VARCHAR(8) NOT NULL,
	
	CONSTRAINT CK_RESULTADO CHECK (RESULTADO IN ('POSITIVO', 'NEGATIVO')),
	CONSTRAINT PK_TESTE_DOPING PRIMARY KEY (CODIGO_TESTE_DOPING),
	CONSTRAINT SK_TESTE_DOPING UNIQUE (DATA_TESTE, ATLETA, MEDICO),
	CONSTRAINT FK_TDOPING_TIPO_OCORR FOREIGN KEY (CODIGO_TESTE_DOPING) REFERENCES TIPO_OCORRENCIA(OCORRENCIA) ON DELETE CASCADE,
	CONSTRAINT FK_TDOPING_ATENDIMENTO FOREIGN KEY (ATLETA, MEDICO) REFERENCES ATENDIMENTO(ATLETA, MEDICO) ON DELETE CASCADE
);

CREATE TABLE LESAO (
	CODIGO_LESAO NUMBER NOT NULL,
	DATA_LESAO DATE NOT NULL,
	ATLETA VARCHAR2(15) NOT NULL,
	MEDICO VARCHAR2(11) NOT NULL,
	DESCRICAO VARCHAR(100) NOT NULL,
	
	CONSTRAINT PK_LESAO PRIMARY KEY (CODIGO_LESAO),
	CONSTRAINT SK_LESAO UNIQUE (DATA_LESAO, ATLETA, MEDICO),
	CONSTRAINT FK_LESAO_TIPOOCORR FOREIGN KEY (CODIGO_LESAO) REFERENCES TIPO_OCORRENCIA(OCORRENCIA) ON DELETE CASCADE,
	CONSTRAINT FK_LESAO_ATENDIMENTO FOREIGN KEY (ATLETA, MEDICO) REFERENCES ATENDIMENTO(ATLETA, MEDICO) ON DELETE CASCADE
);

CREATE TABLE CONSULTA (
	DATA_CONSULTA DATE NOT NULL,
	ATLETA VARCHAR2(15) NOT NULL,
	MEDICO VARCHAR2(11) NOT NULL,
	DIAGNOSTICO NUMBER NOT NULL,
	
	CONSTRAINT PK_CONSULTA PRIMARY KEY (DATA_CONSULTA, ATLETA, MEDICO),
	CONSTRAINT FK_CONSULTA_ATENDIMENTO FOREIGN KEY (ATLETA, MEDICO) REFERENCES ATENDIMENTO(ATLETA, MEDICO) ON DELETE CASCADE,
	CONSTRAINT FK_CONSULTA_DIAGNOSTICO FOREIGN KEY (DIAGNOSTICO) REFERENCES DIAGNOSTICO(CODIGO_DIAGNOSTICO) ON DELETE CASCADE
);

CREATE TABLE CONSULTA_SINTOMAS (
	DATA_CONSULTA DATE NOT NULL,
	ATLETA VARCHAR2(15) NOT NULL,
	MEDICO VARCHAR2(11) NOT NULL,
	DESCRICAO_SINTOMA VARCHAR2(100),
	
	CONSTRAINT PK_CONSULTA_SINTOMAS PRIMARY KEY (DATA_CONSULTA, ATLETA, MEDICO, DESCRICAO_SINTOMA),
	CONSTRAINT FK_CONSULTASINTOMAS_CONSULTA FOREIGN KEY (DATA_CONSULTA, ATLETA, MEDICO) REFERENCES CONSULTA(DATA_CONSULTA, ATLETA, MEDICO) ON DELETE CASCADE
);