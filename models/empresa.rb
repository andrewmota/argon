class Empresa
	attr_accessor :id, :nome, :email, :login, :senha, :tipo, :vagas

	def initialize id = nil, nome = nil, email = nil, login = nil, senha = nil, tipo = nil, vagas = []
		@id = id if id
		@nome = nome if nome
		@email = email if email
		@login = login if login 
        @senha = senha if senha
        @tipo = tipo if tipo
		@vagas = vagas if vagas
	end
end