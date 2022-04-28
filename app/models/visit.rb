class Visit < ApplicationRecord
    
    enum status: {
        Pendente: 0,
        Realiando: 1,
        Realizado: 2
    }

    
end
