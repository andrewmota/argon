require_relative("conexao.rb")
require_relative("candidatura.rb")
require_relative("vagaDAO.rb")
require_relative("usuarioDAO.rb")

class CandidaturaDAO
    def save(candidatura)
        array = [candidatura.usuario.id, candidatura.vaga.id, candidatura.status];
        
        if candidatura.id.nil?
            query = 'INSERT INTO candidatura (idusuario, idvaga, status) VALUES ($1, $2, $3) RETURNING id'
        else
            query = 'UPDATE candidatura SET idusuario = $2, idvaga = $3, status = $4 WHERE id = $1'
            array = [candidatura.id, candidatura.usuario.id, candidatura.vaga.id, candidatura.status];
        end
        
        res = conecta{|con|         
            con.exec_params(query, array)
        }
        
        candidatura.id = res[0]["id"] if res.ntuples == 1

        candidatura
    end
    
    def list
        res = conecta{|con|
            con.exec('SELECT * FROM candidatura')
        }
        usuarioDAO = UsuarioDAO.new
        vagaDAO = VagaDAO.new
        lista = []

        res.each {|linha|
            candidatura = Candidatura.new
            candidatura.id = linha["id"]
            candidatura.usuario = usuarioDAO.get(linha["idusuario"])
            candidatura.vaga = vagaDAO.get(linha["idvaga"])
            candidatura.status = linha["status"]

            lista.push candidatura
        }
        lista
    end

    def delete(id)
        if id
            conecta{|con|         
                con.exec_params('DELETE FROM candidatura WHERE id = $1', [id])
            } 
        end
	end

    def get(id)
        res = conecta{|con|
            con.exec_params(
                'SELECT * FROM candidatura WHERE id = $1', [id])
        }
        
        if(res.ntuples == 1)
            usuarioDAO = UsuarioDAO.new
            vagaDAO = VagaDAO.new
            candidatura = Candidatura.new
            candidatura.id = res[0]["id"]
            candidatura.usuario = usuarioDAO.get(res[0]["idusuario"])
            candidatura.vaga = vagaDAO.get(res[0]["idvaga"])
            candidatura.status = res[0]["status"]

            candidatura
        else
            nil
        end
    end

    def getUsuario(idUsuario)
        res = conecta{|con|
            con.exec('SELECT * FROM candidatura WHERE idusuario = $1', [idUsuario])
        }
        usuarioDAO = UsuarioDAO.new
        vagaDAO = VagaDAO.new
        lista = []

        res.each {|linha|
            candidatura = Candidatura.new
            candidatura.id = linha["id"]
            candidatura.usuario = usuarioDAO.get(linha["idusuario"])
            candidatura.vaga = vagaDAO.get(linha["idvaga"])
            candidatura.status = linha["status"]

            lista.push candidatura
        }
        lista
    end

    def getVaga(idVaga)
        res = conecta{|con|
            con.exec('SELECT * FROM candidatura WHERE idvaga = $1', [idVaga])
        }
        usuarioDAO = UsuarioDAO.new
        vagaDAO = VagaDAO.new
        lista = []

        res.each {|linha|
            candidatura = Candidatura.new
            candidatura.id = linha["id"]
            candidatura.usuario = usuarioDAO.get(linha["idusuario"])
            candidatura.vaga = vagaDAO.get(linha["idvaga"])
            candidatura.status = linha["status"]

            lista.push candidatura
        }
        lista
    end

    def getContagemVaga(idVaga)
        res = conecta{|con|
            con.exec('SELECT count(*) as contagem FROM candidatura WHERE idvaga = $1', [idVaga])
        }

        if(res.ntuples == 1)
            res[0]["contagem"]
        else
            nil
        end
    end

    def getArrayVagasUsuario(idUsuario)
        res = conecta{|con|
            con.exec('SELECT * FROM candidatura WHERE idusuario = $1', [idUsuario])
        }
        lista = []

        res.each {|linha|
            lista.push linha["idvaga"]
        }
        lista
    end 
end
