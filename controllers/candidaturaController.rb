require_relative("../models/candidatura.rb")
require_relative("../models/candidaturaDAO.rb")
require 'digest'

class CandidaturaController
    def initialize
        @dao = CandidaturaDAO.new()
    end
    
    def save(vaga, usuario)
        candidatura = Candidatura.new(nil, usuario, vaga, "R")
        #candidatura.id = params['id'] if params['id']

        @dao.save(candidatura)
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
    
    def getVaga(id)
        @dao.getVaga(id)
    end

    def getUsuario(id)
        @dao.getUsuario(id)
    end

    def getArrayVagasUsuario(id)
        @dao.getArrayVagasUsuario(id)
    end
end