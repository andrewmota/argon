require_relative("../models/habilidade.rb")
require_relative("../models/habilidadeDAO.rb")
require 'digest'

class HabilidadeController
    def initialize
        @dao = HabilidadeDAO.new()
    end
    
    def save(params)
        habilidade = Habilidade.new(nil, params['nome'])
        habilidade.id = params['id'] if params['id']
        habilidade = self.verificaHabilidade(habilidade)

        @dao.save(habilidade)

        habilidade
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

    def verificaHabilidade(habilidade)
        @dao.verificaHabilidade(habilidade)
    end

    def getUsuario(usuario)
        @dao.getUsuario(usuario)
    end

    def saveUsuario(params, habilidade)
        @dao.saveUsuario(params, habilidade)
    end

    def deleteUsuario(params)
        @dao.deleteUsuario(params['usuario'], params['habilidade'])
    end
end