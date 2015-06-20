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
gem 'sqlite3', '~> 1.3.10'
require 'sqlite3'

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
        @data = SQLite3::Database.new(":memory:")
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
        @data.load(what) if(what.class == String)
        @data = what.clone() if(what.class == SQLite3::Database)
    end
    
    #ulozeni dat
    def store(where)
        tmp = SQLite3::Database.new(where)
        tmp = @data.clone
        tmp.close
    end
    
    #ulozeni vsech zmen
    def flush
    end
    
    #smazani vsech zmen
    def clear
    end
    
    #konfigurace pracovniho prostredi
    def configuration(parameters)
    end
end