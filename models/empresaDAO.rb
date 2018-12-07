require_relative("conexao.rb")
require_relative("empresa.rb")

class EmpresaDAO
    def save(empresa)
        array = [empresa.nome, empresa.email, empresa.login, empresa.senha, empresa.tipo];
        
        if empresa.id.nil?
            query = 'INSERT INTO empresa (nome, email, login, senha, tipo) VALUES ($1, $2, $3, $4, $5) RETURNING id'
        else
            query = 'UPDATE empresa SET nome = $2, email = $3, login = $4, senha = $5, tipo = $6 WHERE id = $1'
            array = [empresa.id, empresa.nome, empresa.email, empresa.login, empresa.senha, empresa.tipo];
        end
        
        res = conecta{|con|         
            con.exec_params(query, array)
        }
        
        empresa.id = res[0]["id"] if res.ntuples == 1

        empresa
    end
    
    def list
        res = conecta{|con|
            con.exec('SELECT * FROM empresa')
        }
        lista = []
        res.each {|linha|
            empresa = Empresa.new nil, linha["nome"], linha["email"], linha["login"], linha["senha"], linha["tipo"]
            empresa.id = linha["id"]
            lista.push empresa
        }
        lista
    end

    def delete(id)
        if id
            conecta{|con|         
                con.exec_params('DELETE FROM empresa WHERE id = $1', [id])
            } 
        end
	end

    def get(id)
        res = conecta{|con|
            con.exec_params(
                'SELECT * FROM empresa WHERE id = $1', [id])
        }
        
        if(res.ntuples == 1)
            empresa = Empresa.new nil, res[0]["nome"], res[0]["email"], res[0]["login"], res[0]["senha"], res[0]["tipo"]
            empresa.id = res[0]["id"]
            empresa
        else
            nil
        end
    end

    def getLogin(login)
        res = conecta{|con|
            con.exec_params(
                'SELECT * FROM empresa WHERE login = $1', [login])
        }
        
        if(res.ntuples == 1)
            empresa = Empresa.new nil, res[0]["nome"], res[0]["email"], res[0]["login"], res[0]["senha"], res[0]["tipo"]
            empresa.id = res[0]["id"]
            empresa
        else
            nil
        end
    end
end
