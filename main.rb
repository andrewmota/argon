require 'sinatra'
require_relative("controllers/usuarioController.rb")
require_relative("controllers/empresaController.rb")
require_relative("controllers/vagaController.rb")
require_relative("controllers/candidaturaController.rb")

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
end

hash = {
        "nivel" => {"J" => "Júnior", "P" => "Pleno", "S" => "Sênior"},
        "tipoContrato" => {"E" => "Estágio", "C" => "CLT", "P" => "PJ"},
        "remoto" => {"S" => "Remoto", "N" => "Presencial"},
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

    if !session[:usuario].nil? then
        @usuario = session[:usuario]
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
before '/usuario/*' do
    if session[:empresa] or !session[:usuario] then
        redirect "/login"
    end
end

get '/usuario/candidaturas' do
    @titulo = "Candidaturas"
    @usuario = session[:usuario]
    @candidaturas = candidaturaController.getUsuario(@usuario.id)
    erb :candidaturas, :layout => :baseAdmin
end

#Rotas: Empresa
before '/empresa/*' do
    if !session[:empresa] or session[:usuario] then
        redirect "/login"
    end
end

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