require_relative("conexao.rb")
require_relative("vaga.rb")
require_relative("empresaDAO.rb")
require_relative("usuarioDAO.rb")
require_relative("candidaturaDAO.rb")

class VagaDAO
    def initialize
        @hashNivel = {"J" => "Júnior", "P" => "Pleno", "S" => "Sênior"}
        @hashTipoContrato = {"E" => "Estágio", "C" => "CLT", "P" => "PJ"}
        @hashRemoto = {"S" => "Sim", "N" => "Não"}
    end

    def save(vaga)
        array = [vaga.titulo, vaga.empresa.id, vaga.nivel, vaga.tipoContrato, vaga.remoto, vaga.local, vaga.salario, vaga.descricao]
        
        if vaga.id.nil?
            query = 'INSERT INTO vaga(titulo, idempresa, nivel, "tipoContrato", remoto, local, salario, descricao) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING id'
        else
            query = 'UPDATE vaga SET titulo=$2, idempresa=$3, nivel=$4, "tipoContrato"=$5, remoto=$6, local=$7, salario=$8, descricao=$9 WHERE id = $1'
            array = [vaga.id, vaga.titulo, vaga.empresa.id, vaga.nivel, vaga.tipoContrato, vaga.remoto, vaga.local, vaga.salario, vaga.descricao]
        end
        
        res = conecta{|con|         
            con.exec_params(query, array)
        }
        
        vaga.id = res[0]["id"] if res.ntuples == 1

        vaga
    end
    
    def list
        res = conecta{|con|
            con.exec('SELECT * FROM vaga')
        }
        empresaDAO = EmpresaDAO.new
        candidaturaDAO = CandidaturaDAO.new
        lista = []

        res.each {|linha|
            vaga = Vaga.new nil, linha["titulo"], nil, @hashNivel[linha["nivel"]], @hashTipoContrato[linha["tipoContrato"]], @hashRemoto[linha["remoto"]], linha["local"], linha["salario"], linha["descricao"]

            vaga.id = linha["id"]
            vaga.empresa = empresaDAO.get(linha["idempresa"])
            vaga.nroCandidaturas = candidaturaDAO.getContagemVaga(vaga.id)

            lista.push vaga
        }
        lista
    end

    def delete(id)
        if id
            conecta{|con|         
                con.exec_params('DELETE FROM vaga WHERE id = $1', [id])
            } 
        end
	end

    def get(id)
        res = conecta{|con|
            con.exec_params('SELECT * FROM vaga WHERE id = $1', [id])
        }
        
        if(res.ntuples == 1)
            empresaDAO = EmpresaDAO.new
            candidaturaDAO = CandidaturaDAO.new

            vaga = Vaga.new nil, res[0]["titulo"], nil, @hashNivel[res[0]["nivel"]], @hashTipoContrato[res[0]["tipoContrato"]], @hashRemoto[res[0]["remoto"]], res[0]["local"], res[0]["salario"], res[0]["descricao"]
            
            vaga.id = res[0]["id"]
            vaga.empresa = empresaDAO.get(res[0]["idempresa"])
            vaga.nroCandidaturas = candidaturaDAO.getContagemVaga(vaga.id)

            vaga
        else
            nil
        end
    end

    def filtrar(filtro, valor)
        empresaDAO = EmpresaDAO.new
        candidaturaDAO = CandidaturaDAO.new
        lista = []

        case filtro
            when "tipoContrato"
                query = 'SELECT * FROM vaga WHERE "tipoContrato" = $1'
            when "nivel"
                query = 'SELECT * FROM vaga WHERE nivel = $1'
            when "remoto"
                query = 'SELECT * FROM vaga WHERE remoto = $1'
            when "tipo"
                query = 'SELECT * FROM vaga INNER JOIN empresa ON vaga.idempresa = empresa.id WHERE empresa.tipo = $1'
        end

        res = conecta{|con|
            con.exec(query, [valor])
        }

        res.each {|linha|
            vaga = Vaga.new nil, linha["titulo"], nil, @hashNivel[linha["nivel"]], @hashTipoContrato[linha["tipoContrato"]], @hashRemoto[linha["remoto"]], linha["local"], linha["salario"], linha["descricao"]

            vaga.id = linha["id"]
            vaga.empresa = empresaDAO.get(linha["idempresa"])
            vaga.nroCandidaturas = candidaturaDAO.getContagemVaga(vaga.id)

            lista.push vaga
        }
        lista
    end

    def getEmpresa(idEmpresa)
        res = conecta{|con|
            con.exec('SELECT * FROM vaga WHERE idempresa = $1', [idEmpresa])
        }
        empresaDAO = EmpresaDAO.new
        candidaturaDAO = CandidaturaDAO.new
        lista = []

        res.each {|linha|
            vaga = Vaga.new nil, linha["titulo"], nil, @hashNivel[linha["nivel"]], @hashTipoContrato[linha["tipoContrato"]], @hashRemoto[linha["remoto"]], linha["local"], linha["salario"], linha["descricao"]

            vaga.id = linha["id"]
            vaga.empresa = empresaDAO.get(linha["idempresa"])
            vaga.nroCandidaturas = candidaturaDAO.getContagemVaga(vaga.id)

            lista.push vaga
        }
        lista
    end
end
