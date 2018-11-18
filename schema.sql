CREATE DATABASE trabfinal ;

CREATE TYPE nivel AS ENUM ('J', 'P', 'S');
CREATE TYPE "tipoContrato" AS ENUM ('E', 'C', 'P');
CREATE TYPE remoto AS ENUM ('S', 'N');


CREATE TABLE usuario(
	id serial,
	nome varchar(30) NOT NULL,
	email varchar(50) NOT NULL,
	login varchar(20) NOT NULL,
	senha varchar(20) NOT NULL,
	CONSTRAINT "usuarioPK" PRIMARY KEY (id)
);

CREATE TABLE empresa(
	id serial,
	nome varchar(30) NOT NULL,
	email varchar(50) NOT NULL,
	login varchar(20) NOT NULL,
	senha varchar(20) NOT NULL,
	tipo varchar(20) NOT NULL,
	CONSTRAINT "empresaPK" PRIMARY KEY (id)
);

CREATE TABLE vaga(
	id serial,
	titulo text NOT NULL,
	idempresa int NOT NULL,
	nível nivel,
	"tipoContrato" "tipoContrato",
	remoto remoto,
	local text,
	salario numeric,
	descricao text
	CONSTRAINT "vagaPK" PRIMARY KEY (id)
);

CREATE TABLE candidatura(
	id serial,
	idusuario int NOT NULL,
	idvaga int NOT NULL,
	CONSTRAINT "candidaturaPK" PRIMARY KEY (id)
);

CREATE TABLE habilidade(
	id serial,
	nome varchar(50) NOT NULL,
	CONSTRAINT "habilidadePK" PRIMARY KEY (id)
);

CREATE TABLE usuarioSkills(
	idusuario int NOT NULL,
	idhabilidade int NOT NULL,
	"tempoExperiencia" text NOT NULL,
	CONSTRAINT "usuarioSkillsFKusuario" FOREIGN KEY (idusuario) REFERENCES usuario(id),
		ON DELETE CASCADE
		ON UPDATE CASCADE
	CONSTRAINT "usuarioSkillshabilidade" FOREIGN KEY (idhabilidade) REFERENCES habilidade(id),
		ON DELETE CASCADE
		ON UPDATE CASCADE
);
