# Trida DB je urcena pro abstrakci pristupu dat
# bude zprostredkovávat pridavani/odebirani sloupcu, dat a i jejich aktualizaci s ohledem na narocnost uprav
#------------------------------------------------------------------------------------------------------------
#
# Myslenka:
#    Objekt si do SQLite nacte data z externich dat/DB. V pripade DB provede nejdrive overeni na pocet zaznamu a pripadne nacte pouze cast
#
#
#
#
#
#
#
#
class DB_row
   def initialize
       @modified = false
       @data = nil
   end
   
   def [](column, sdata=nil)
       @data[column] = data unless sdata.nil
       @data
   end
end

class DB
private
    
    
    
public
    #construktor fce
    def initialize
        
    end
    #prida sloupec
    def column_add(what, column_data)
        
    end
    
    #prejmenuje sloupce z from na to
    def column_rename(from, to)
        
    end
    
    #odstrani dany sloupec
    def column_remove(what)
        
    end
    
    #prida radek
    #where - do jake tabulky
    #where - data do konkretnich sloupcu
    def add(where,data)
    end
    
    #odstrani radek
    def remove(what)
    end
    
    #aktualizace radku
    def update(how, condition)
    end
    
    #nacteni dat
    def load(what)
    end
    
    #ulozeni dat
    def store(where)
    end
    
    #ulozeni vsech zmen
    def flush
    end
    
    #smazani vsech zmen
    def clear
    end
    
    #konfigurage pracovniho prostredi
    def configuration(parameters)
    end
end