require_relative("../models/candidatura.rb")
require_relative("../models/candidaturaDAO.rb")
require 'digest'

class CandidaturaController
    def initialize
        @dao = CandidaturaDAO.new()
    end
    
    def save(params, usuario)
        candidatura = Candidatura.new(nil, usuario, params['vaga'])
        candidatura.id = params['id'] if params['id']

        @dao.save(vaga)
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

    def filtrar(filtro, valor)
        @dao.filtrar(filtro, valor)
    end

    def getUsuario(id)
        @dao.getUsuario(id)
    end
end