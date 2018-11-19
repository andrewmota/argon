require 'sinatra'
require_relative("controllers/usuarioController.rb")
require_relative("controllers/empresaController.rb")
require_relative("controllers/vagaController.rb")

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
end

hash = {
        "nivel" => {"J" => "Júnior", "P" => "Pleno", "S" => "Sênior"},
        "tipoContrato" => {"E" => "Estágio", "C" => "CLT", "P" => "PJ"},
        "remoto" => {"S" => "Remoto", "N" => "Presencial"},
        "tipo" => {"S" => "StartUp", "P" => "Pequena", "M" => "Média", "G" => "Grande"}
    }
enable :sessions

before "/usuario" do
    if !session[:usuario] then
        redirect "/login"
    end
end

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
    erb :vagas, :layout => :base
end

#Rotas Manutenção: Usuário/Empresa

get '/cadastro' do
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

get '/usuario/:id' do
    @usuario = usuarioController.get(params[:id])
    @postagens = postagemController.listUser(params[:id])
    erb :perfil, :layout => :base
end