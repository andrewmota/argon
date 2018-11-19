require_relative("../models/postagem.rb")
require_relative("../models/postagemDAO.rb")
require 'digest'

class PostagemController
    def initialize
        @dao = PostagemDAO.new()
    end
    
    def save(params, usuario)
        postagem = Postagem.new nil, params['conteudo']
        postagem.usuario = usuario
        postagem.id = params['id'] if params['id']

        @dao.save(postagem)
    end

    def list
        @dao.list
    end

    def listUser(id)
        @dao.listUser(id)
    end

    def delete(id)
        @dao.delete(id)
    end

    def get(id)
        @dao.get(id)
    end
end

