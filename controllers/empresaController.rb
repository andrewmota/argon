require_relative("../models/empresa.rb")
require_relative("../models/empresaDAO.rb")
require 'digest'

class EmpresaController
    def initialize
        @dao = EmpresaDAO.new()
    end
    
    def save(params)
        if !params['id']
            passwordEncrypted = Digest::MD5.hexdigest params['senha']
        else
            passwordEncrypted = params['senha']
        end
        empresa = Empresa.new(nil, params['nome'], params['email'], params['login'], passwordEncrypted, params['tipo'])
        empresa.id = params['id'] if params['id']

        @dao.save(empresa)
    end

    def list
        @dao.list
    end

    def delete(id)
        @dao.delete(id)
    end

    def get(id)
        @dao.get(id)
    end

    def verifyUser(params)
        passwordEncrypted = @senha = Digest::MD5.hexdigest params['senha']
        
        empresaCadastrada = @dao.getLogin(params['login'])
        if(!empresaCadastrada.nil?)
            empresa = Empresa.new(nil, nil, nil, params['login'], passwordEncrypted, nil)
            
            if(empresaCadastrada.login == empresa.login and empresaCadastrada.senha == empresa.senha)
                empresaCadastrada
            end
        end
    end
end