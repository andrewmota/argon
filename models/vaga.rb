class Vaga
	attr_accessor :id, :titulo, :empresa, :nivel, :tipoContrato, :remoto, :local, :salario, :descricao, :nroCandidaturas

	def initialize id = nil, titulo = nil, empresa = nil, nivel = nil, tipoContrato = nil, remoto = nil, local = nil, salario = nil, descricao = nil, nroCandidaturas = 0
		@id = id if id
		@titulo = titulo if titulo
		@empresa = empresa if empresa
		@nivel = nivel if nivel 
		@tipoContrato= tipoContrato if tipoContrato
		@remoto = remoto if remoto
		@local = local if local
		@salario = salario if salario
		@descricao = descricao if descricao
		@nroCandidaturas = nroCandidaturas if nroCandidaturas
	end
end