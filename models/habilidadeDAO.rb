require_relative("conexao.rb")
require_relative("habilidade.rb")

class habilidadeDAO
	def save(habilidade)
        array = [habilidade.nome];

        if habilidade.id.nil?
            query = 'INSERT INTO habilidade (nome) VALUES ($1) RETURNING id'
        else
            query = 'UPDATE habilidade SET nome = $2 WHERE id = $1'
            array<<habilidade.id
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

end