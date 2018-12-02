require 'sinatra'
require_relative("controllers/usuarioController.rb")
require_relative("controllers/empresaController.rb")
require_relative("controllers/vagaController.rb")
require_relative("controllers/candidaturaController.rb")
require_relative("controllers/habilidadeController.rb")

helpers do
    def usuarioController 
        UsuarioController.new
    end
    def empresaController 
        EmpresaController.new
    end
    def vagaController 
        VagaController.new
    end
    def candidaturaController 
        CandidaturaController.new
    end
    def habilidadeController 
        HabilidadeController.new
    end
end

hash = {
    "nivel" => {"J" => "Júnior", "P" => "Pleno", "S" => "Sênior"},
    "tipoContrato" => {"E" => "Estágio", "C" => "CLT", "P" => "PJ"},
    "remoto" => {"S" => "Sim", "N" => "Não"},
    "tipo" => {"S" => "StartUp", "P" => "Pequena", "M" => "Média", "G" => "Grande"}
}
enable :sessions

#Rotas: Inícios
get '/' do
    redirect "/vagas"
end

get '/vagas' do
    if params.to_hash().count > 0
        params.to_hash().each do |filtro, valor|
            @vagas = vagaController.filtrar(filtro, valor)
            @subtitulo = "Vagas para Programadores e Desenvolvedores - #{hash[filtro][valor]}"
        end
    else 
        @vagas = vagaController.list()
        @subtitulo = "Vagas para Programadores e Desenvolvedores"
    end
    
    @candidaturas = nil
    if !session[:usuario].nil? then
        @usuario = session[:usuario]
        @candidaturas = candidaturaController.getArrayVagasUsuario(@usuario.id)
    elsif !session[:empresa].nil? then
        @empresa = session[:empresa]
    end

    @titulo = "Vagas de emprego"
    erb :index, :layout => :base
end

#Rotas: Cadastro/Login/Logout
get '/cadastro' do
    if session[:usuario] or session[:empresa] then
        redirect "/vagas"
    end

    @titulo = "Cadastrar"
    erb :cadastro, :layout => :baseForm
end

post '/cadastro' do
    if params['tipoUsuario'] == "empresa"
        empresa = empresaController.save(params)
        session[:empresa] = empresa
    else
        usuario = usuarioController.save(params)
        session[:usuario] = usuario
        redirect "/habilidades"
    end

    redirect "/vagas"
end

get '/login' do
    if session[:usuario] or session[:empresa] then
        redirect "/vagas"
    end

    @titulo = "Login"
    erb :login, :layout => :baseForm
end

post '/login' do
    if params['tipoUsuario'] == "empresa"
        response = empresaController.verifyUser(params)
        
        if !response.nil?
            session[:empresa] = response
            redirect "/vagas"
        end
    else
        response = usuarioController.verifyUser(params)
        if !response.nil?
            session[:usuario] = response
            redirect "/vagas"
        end
    end
    
    redirect "/login"
end

get '/logout' do
    session[:usuario] = nil
    session[:empresa] = nil
    redirect "/"
end

#Rotas: Usuário
get '/usuario/candidaturas' do
    if !session[:usuario] or session[:empresa] then
        redirect "/login"
    end

    @titulo = "Candidaturas"
    @usuario = session[:usuario]
    @candidaturas = candidaturaController.getUsuario(@usuario.id)
    erb :candidaturas, :layout => :baseAdmin
end

get '/usuario/:id' do
    @candidaturas = nil
    if !session[:usuario].nil? then
        @usuario = session[:usuario]
    elsif !session[:empresa].nil? then
        @empresa = session[:empresa]
    end

    @usuarioPerfil = usuarioController.get(params['id'])

    if !@usuario.nil? and @usuarioPerfil.id == @usuario.id
        redirect "/usuario"
    end

    @titulo = "Perfil " + @usuarioPerfil.nome
    @candidaturas = candidaturaController.getUsuario(@usuarioPerfil.id)
    @habilidades = habilidadeController.getUsuario(@usuarioPerfil)
    erb :usuario, :layout => :baseAdmin
end

get '/usuario' do
    if !session[:usuario] or session[:empresa] then
        redirect "/login"
    end

    @usuario = session[:usuario]
    @titulo = @usuario.nome
    @candidaturas = candidaturaController.getUsuario(@usuario.id)
    @habilidades = habilidadeController.getUsuario(@usuario)
    erb :perfil, :layout => :baseAdmin
end

get '/habilidades' do
    if !session[:usuario] or session[:empresa] then
        redirect "/login"
    end

    @usuario = session[:usuario]
    @habilidades = habilidadeController.getUsuario(@usuario)
    @titulo = "Selecione suas habilidades"
    erb :habilidades, :layout => :baseAdmin
end 

post '/habilidades/cadastro' do
    habilidade = habilidadeController.save(params)
    habilidadeController.saveUsuario(params, habilidade)
end

post '/habilidades/deletar' do
    habilidade = habilidadeController.deleteUsuario(params)
end

#Rotas: Empresa
get '/empresa/vagas' do
    @titulo = "Vagas anunciadas"
    @empresa = session[:empresa]
    @vagas = vagaController.getEmpresa(@empresa.id)
    erb :vagas, :layout => :baseAdmin
end

get '/vaga/cadastro' do
    if !session[:empresa] or session[:usuario] then
        redirect "/login"
    end

    @titulo = "Cadastrar Vaga"
    @opcoes = hash
    erb :cadastroVaga, :layout => :baseForm
end

post '/vaga/cadastro' do
    if !session[:empresa] or session[:usuario] then
        redirect "/login"
    end
    
    empresa = session[:empresa]
    vagaController.save(params, empresa)
    redirect "/vagas"
end

get '/vaga/editar/:id' do
    if !session[:empresa] or session[:usuario] then
        redirect "/login"
    end

    @vaga = vagaController.get(params['id'])
    @titulo = "Alterar Vaga"
    @opcoes = hash
    erb :alterarVaga, :layout => :baseForm    
end

get '/vaga/deletar/:id' do
    if !session[:empresa] or session[:usuario] then
        redirect "/login"
    end

    vaga = vagaController.get(params['id'])
    empresa = session[:empresa]
    if vaga.empresa.id === empresa.id
        vagaController.delete(params['id'])
        redirect "/empresa/vagas"
    else
        redirect "/vagas"
    end
end

get '/vaga/candidatar/:vaga' do
    if session[:empresa] or !session[:usuario] then
        redirect "/login"
    end

    usuario = session[:usuario]
    list = candidaturaController.getUsuario(usuario.id)
    if !list.include? params['vaga']
        vaga = vagaController.get(params['vaga'])
        candidaturaController.save(vaga, usuario)
    end

    redirect "/vagas"
end

get '/vaga/candidaturas/:vaga' do
    if !session[:empresa] or session[:usuario] then
        redirect "/login"
    end

    @empresa = session[:empresa]
    @titulo = "Candidaturas para a vaga: " + vagaController.get(params["vaga"]).titulo
    @candidaturas = candidaturaController.getVaga(params["vaga"])
    erb :candidaturas, :layout => :baseAdmin
end

get '/vaga/:id' do
    if session[:usuario]
        @usuario = session[:usuario]
        @candidaturas = candidaturaController.getArrayVagasUsuario(@usuario.id)
    end

    @vaga = vagaController.get(params["id"])
    @titulo = @vaga.titulo
    erb :vaga, :layout => :baseAdmin
end