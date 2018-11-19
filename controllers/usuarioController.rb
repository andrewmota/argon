require_relative("../models/usuario.rb")
require_relative("../models/usuarioDAO.rb")
require 'digest'

class UsuarioController
    def initialize
        @dao = UsuarioDAO.new()
    end
    
    def save(params)
        passwordEncrypted = @senha = Digest::MD5.hexdigest params['senha']
        usuario = Usuario.new(nil, params['nome'], params['email'], params['login'], passwordEncrypted)
        usuario.id = params['id'] if params['id']
        @dao.save(usuario)
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

    def post(params, usuario)
        postagemController = PostagemController.new()
        postagemController.save(params, usuario)
    end

    def verifyUser(params)
        passwordEncrypted = @senha = Digest::MD5.hexdigest params['senha']

        usuarioCadastrado = @dao.getLogin(params['login'])
        if(usuarioCadastrado)
            usuario = Usuario.new(nil, nil, nil, params['login'], passwordEncrypted)

            if(usuarioCadastrado.login == usuario.login and usuarioCadastrado.senha == usuario.senha)
                usuarioCadastrado
            end
        end
    end
end

