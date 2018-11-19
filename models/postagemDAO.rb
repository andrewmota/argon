require_relative("conexao.rb")
require_relative("postagem.rb")
require_relative("usuarioDAO.rb")

class PostagemDAO
    def save(postagem)
        array = [postagem.conteudo, postagem.usuario.id];

        if postagem.id.nil?
            query = 'INSERT INTO postagem (conteudo, usuario) VALUES ($1, $2) RETURNING id'
        else
            query = 'UPDATE postagem SET conteudo = $2, usuario = $3 WHERE id = $1'
            array<<postagem.id
        end
        
        res = conecta{|con|         
            con.exec_params(query, array)
        }
        
        postagem.id = res[0]["id"] if res.ntuples == 1

        postagem
    end
    
    def list
        res = conecta{|con|
            con.exec('SELECT * FROM postagem ORDER BY id desc')
        }
        lista = []
        res.each {|linha|
            usuarioDAO = UsuarioDAO.new
            postagem = Postagem.new nil, linha["conteudo"]
            postagem.usuario = usuarioDAO.get(linha["usuario"])
            postagem.id = linha["id"]
            lista.push postagem
        }
        lista
    end

    def listUser(id)
        res = conecta{|con|
            con.exec('SELECT * FROM postagem WHERE usuario = $1 ORDER BY id desc', [id])
        }
        lista = []
        res.each {|linha|
            usuarioDAO = UsuarioDAO.new
            postagem = Postagem.new nil, linha["conteudo"]
            postagem.usuario = usuarioDAO.get(linha["usuario"])
            postagem.id = linha["id"]
            lista.push postagem
        }
        lista
    end

    def delete(id)
        if id
            conecta{|con|         
                con.exec_params('DELETE FROM postagem WHERE id = $1', [id])
            } 
        end
	end

    def get(id)
        res = conecta{|con|
            con.exec_params(
                'SELECT * FROM postagem WHERE id = $1', [id])
        }
        
        if(res.ntuples == 1)
            usuarioDAO = UsuarioDAO.new
            postagem = Postagem.new nil, res[0]["conteudo"]
            postagem.usuario = usuarioDAO.get(res[0]["usuario"])
            postagem.id = res[0]["id"]
            postagem
        else
            nil
        end
    end
end
