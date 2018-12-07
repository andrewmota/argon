require_relative("conexao.rb")
require_relative("habilidade.rb")
require_relative("usuarioDAO.rb")
require_relative("vagaDAO.rb")

class HabilidadeDAO
	def save(habilidade)
        array = [habilidade.nome];

        if habilidade.id.nil?
            query = 'INSERT INTO habilidade (nome) VALUES ($1) RETURNING id'
        else
            query = 'UPDATE habilidade SET nome = $2 WHERE id = $1'
            array = [habilidade.id, habilidade.nome]
        end
        
        res = conecta{|con|         
            con.exec_params(query, array)
        }
        
        habilidade.id = res[0]["id"] if res.ntuples == 1

        habilidade
    end

    def list
        res = conecta{|con|
            con.exec('SELECT * FROM habilidade')
        }
        lista = []
        res.each {|linha|
            habilidade = Habilidade.new nil, linha["nome"]
            habilidade.id = linha["id"]
            lista.push habilidade
        }
        lista
    end

    def delete(id)
        if id
            conecta{|con|         
                con.exec_params('DELETE FROM habilidade WHERE id = $1', [id])
            } 
        end
	end

	def get(id)
        res = conecta{|con|
            con.exec_params(
                'SELECT * FROM habilidade WHERE id = $1', [id])
        }
        
        if(res.ntuples == 1)
            habilidade = Habilidade.new nil, res[0]["nome"]
            habilidade.id = res[0]["id"]
            habilidade
        else
            nil
        end
    end

    def verificaHabilidade(habilidade)
        puts habilidade.nome
        res = conecta{|con|
            con.exec_params(
                "SELECT * FROM habilidade WHERE nome ILIKE $1", [habilidade.nome])
        }

        if(res.ntuples > 0)
            habilidadeAchada = Habilidade.new nil, res[0]["nome"]
            habilidadeAchada.id = res[0]["id"]
            habilidadeAchada
        else
            habilidade
        end
    end

    def getUsuario(usuario)
        res = conecta{|con|
            con.exec('SELECT habilidade.id, habilidade.nome, usuarioSkills."tempoExperiencia" FROM usuarioSkills INNER JOIN habilidade ON habilidade.id = usuarioSkills.idHabilidade WHERE usuarioSkills.idusuario = $1', [usuario.id])
        }
        lista = Hash.new

        res.each {|linha|
            habilidade = Habilidade.new nil, linha["nome"]
            habilidade.id = linha["id"]

            lista[habilidade] = linha["tempoExperiencia"]
        }
        
        lista
    end

    def saveUsuario(params, habilidade)
        usuarioDAO = UsuarioDAO.new
        usuario = usuarioDAO.get(params['usuario'])

        query = 'INSERT INTO usuarioSkills (idusuario, idhabilidade, "tempoExperiencia") VALUES ($1, $2, $3)'

        res = conecta{|con|         
            con.exec_params(query, [usuario.id, habilidade.id, params['tempo']])
        }
    end

    def deleteUsuario(usuario, habilidade)
        if usuario and habilidade
            conecta{|con|         
                con.exec_params('DELETE FROM usuarioSkills WHERE idusuario = $1 and idhabilidade = $2', [usuario, habilidade])
            } 
        end
    end

    def getVaga(vaga)
        res = conecta{|con|
            con.exec('SELECT habilidade.id, habilidade.nome, vagaSkills."tempoExperiencia" FROM vagaSkills INNER JOIN habilidade ON habilidade.id = vagaSkills.idHabilidade WHERE vagaSkills.idvaga = $1', [vaga.id])
        }
        lista = Hash.new

        res.each {|linha|
            habilidade = Habilidade.new nil, linha["nome"]
            habilidade.id = linha["id"]

            lista[habilidade] = linha["tempoExperiencia"]
        }
        
        lista
    end

    def saveVaga(params, habilidade)
        vagaDAO = VagaDAO.new
        vaga = vagaDAO.get(params['vaga'])

        query = 'INSERT INTO vagaSkills (idvaga, idhabilidade, "tempoExperiencia") VALUES ($1, $2, $3)'

        res = conecta{|con|         
            con.exec_params(query, [vaga.id, habilidade.id, params['tempo']])
        }
    end

    def deleteVaga(vaga, habilidade)
        if vaga and habilidade
            conecta{|con|         
                con.exec_params('DELETE FROM vagaSkills WHERE idvaga = $1 and idhabilidade = $2', [vaga, habilidade])
            } 
        end
    end
end