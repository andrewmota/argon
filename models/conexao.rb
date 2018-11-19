require 'pg'

def conecta
	conf = {dbname:"trabFinal", user:"postgres", password:"", 
			host:"localhost", port:"5432"}
	begin
        c = PG.connect conf
        yield c
        
	rescue PG::Error => e
        puts  "Erro de conexão"
		puts e.message
        raise e
    ensure
        c.close if c
    end
end