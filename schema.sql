CREATE DATABASE trabfinal ;

CREATE TYPE nivel AS ENUM ('J', 'P', 'S');
CREATE TYPE "tipoContrato" AS ENUM ('E', 'C', 'P');
CREATE TYPE "tipoEmpresa" AS ENUM ('S', 'P', 'M', 'G');
CREATE TYPE remoto AS ENUM ('S', 'N');
CREATE TYPE status AS ENUM ('R', 'N', 'E');

CREATE TABLE usuario(
	id serial,
	nome text NOT NULL,
	email text NOT NULL,
	login text NOT NULL,
	senha text NOT NULL,
	CONSTRAINT "usuarioPK" PRIMARY KEY (id)
);

CREATE TABLE empresa(
	id serial,
	nome text NOT NULL,
	email text NOT NULL,
	login text NOT NULL,
	senha text NOT NULL,
	tipo "tipoEmpresa" NOT NULL,
	CONSTRAINT "empresaPK" PRIMARY KEY (id)
);

CREATE TABLE vaga(
	id serial,
	titulo text NOT NULL,
	idempresa int NOT NULL,
	nivel nivel NOT NULL,
	"tipoContrato" "tipoContrato" NOT NULL,
	remoto remoto NOT NULL,
	local text NOT NULL,
	salario numeric,
	descricao text,
	CONSTRAINT "vagaPK" PRIMARY KEY (id),
	CONSTRAINT "vagaFKempresa" FOREIGN KEY (idempresa) REFERENCES empresa(id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE candidatura(
	id serial,
	idusuario int NOT NULL,
	idvaga int NOT NULL,
	status status NOT NULL,
	CONSTRAINT "candidaturaPK" PRIMARY KEY (id),
	CONSTRAINT "candidaturaFKusuario" FOREIGN KEY (idusuario) REFERENCES usuario(id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT "candidaturaFKvaga" FOREIGN KEY (idvaga) REFERENCES vaga(id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE habilidade(
	id serial,
	nome text NOT NULL,
	CONSTRAINT "habilidadePK" PRIMARY KEY (id)
);

CREATE TABLE usuarioSkills(
	idusuario int NOT NULL,
	idhabilidade int NOT NULL,
	"tempoExperiencia" text NOT NULL,
	CONSTRAINT "usuarioSkillsFKusuario" FOREIGN KEY (idusuario) REFERENCES usuario(id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT "usuarioSkillshabilidade" FOREIGN KEY (idhabilidade) REFERENCES habilidade(id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE vagaSkills(
	idvaga int NOT NULL,
	idhabilidade int NOT NULL,
	"tempoExperiencia" text NOT NULL,
	CONSTRAINT "vagaSkillsFKvaga" FOREIGN KEY (idvaga) REFERENCES vaga(id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT "vagaSkillsFKhabilidade" FOREIGN KEY (idhabilidade) REFERENCES habilidade(id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);