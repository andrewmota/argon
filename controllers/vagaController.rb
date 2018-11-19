require_relative("../models/vaga.rb")
require_relative("../models/vagaDAO.rb")
require 'digest'

class VagaController
    def initialize
        @dao = VagaDAO.new()
    end
    
    def save(params, empresa)
        vaga = Vaga.new(nil, params['titulo'], empresa, params['nivel'], params['tipoContrato'], params['remoto'], params['local'], params['salario'], params['descricao'])
        vaga.id = params['id'] if params['id']

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

    def getEmpresa(id)
        @dao.getEmpresa(id)
    end
end