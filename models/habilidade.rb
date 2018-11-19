class Habilidade
	attr_accessor :id, :nome

	def initialize id = nil, nome = nil
		@id = id if id
		@nome = nome if nome
	end
end