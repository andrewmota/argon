class Candidatura
	attr_accessor :id, :usuario, :vaga

	def initialize id = nil, usuario = nil, vaga = nil
		@id = id if id
		@usuario = usuario if usuario
		@vaga = vaga if vaga
	end
end