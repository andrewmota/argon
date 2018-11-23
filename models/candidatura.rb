class Candidatura
	attr_accessor :id, :usuario, :vaga, :status

	def initialize id = nil, usuario = nil, vaga = nil, status = nil
		@id = id if id
		@usuario = usuario if usuario
		@vaga = vaga if vaga
		@status = status if status
	end
end