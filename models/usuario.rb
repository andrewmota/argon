class Usuario
	attr_accessor :id, :nome, :email, :login, :senha, :habilidades

	def initialize id = nil, nome = nil, email = nil, login = nil, senha = nil, habilidades = []
		@id = id if id
		@nome = nome if nome
		@email = email if email
		@login = login if login 
		@senha = senha if senha
		@habilidades = habilidades if habilidades
	end
end