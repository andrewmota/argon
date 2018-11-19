require_relative("conexao.rb")
require_relative("usuario.rb")
require_relative("vagaDAO.rb")

class UsuarioDAO
    def save(usuario)
        array = [usuario.nome, usuario.email, usuario.login, usuario.senha];
        
        if usuario.id.nil?
            query = 'INSERT INTO usuario (nome, email, login, senha) VALUES ($1, $2, $3, $4) RETURNING id'
        else
            query = 'UPDATE usuario SET nome = $2, email = $3, login = $4, senha = $5 WHERE id = $1'
            array<<usuario.id
        end
        
        res = conecta{|con|         
            con.exec_params(query, array)
        }
        
        usuario.id = res[0]["id"] if res.ntuples == 1

        usuario
    end
    
    def list
        res = conecta{|con|
            con.exec('SELECT * FROM usuario')
        }
        lista = []
        res.each {|linha|
            usuario = Usuario.new nil, linha["nome"], linha["email"], linha["login"], linha["senha"]

            usuario.id = linha["id"]
            #usuario.candidaturas = self.getCandidaturas(usuario.id)

            lista.push usuario
        }
        lista
    end

    def delete(id)
        if id
            conecta{|con|         
                con.exec_params('DELETE FROM usuario WHERE id = $1', [id])
            } 
        end
	end

    def get(id)
        res = conecta{|con|
            con.exec_params(
                'SELECT * FROM usuario WHERE id = $1', [id])
        }
        
        if(res.ntuples == 1)
            usuario = Usuario.new nil, res[0]["nome"], res[0]["email"], res[0]["login"], res[0]["senha"]

            usuario.id = res[0]["id"]
            #usuario.candidaturas = self.getCandidaturas(usuario.id)

            usuario
        else
            nil
        end
    end

    def getLogin(login)
        res = conecta{|con|
            con.exec_params(
                'SELECT * FROM usuario WHERE login = $1', [login])
        }
        
        if(res.ntuples == 1)
            usuario = Usuario.new nil, res[0]["nome"], res[0]["email"], res[0]["login"], res[0]["senha"]

            usuario.id = res[0]["id"]
            #usuario.candidaturas = self.getCandidaturas(usuario.id)

            usuario
        else
            nil
        end
    end

    def getCandidaturas(id)
        res = conecta{|con|
            con.exec('SELECT * FROM candidatura WHERE idusuario = $1', [id])
        }
        vagaDAO = VagaDAO.new
        lista = []

        res.each {|linha|
            vaga = vagaDAO.get(linha['idvaga'])
            lista.push vaga
        }
        lista
    end
end
