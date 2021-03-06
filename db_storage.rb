# Trida DBStorage je urcena pro abstrakci pristupu dat
# bude zprostredkovávat pridavani/odebirani sloupcu, dat a i jejich aktualizaci s ohledem na narocnost uprav
#------------------------------------------------------------------------------------------------------------
#
# Myslenka:
#    Objekt si do SQLite nacte data z externich dat/DBStorage. V pripade DBStorage provede nejdrive overeni
# na pocet zaznamu a pripadne nacte pouze cast
#
#
#    DBStorage - provadi nacitani dat a poskytnuti datasetu pro zpracovani s pripadnym poskytnutim dalsich dat
#    Dataset - data navracena DBStorage pro zpracovani s moznosti pridavani/odebirani sloupcu a podobne upravy
#    DB_row - provedene upravy
#
#
#
#gem 'sqlite3', '~> 1.3.10'
#require 'sqlite3'

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

class Dataset
    private

    public
        def initialize
            #@data obsahuje skutecna data s nimiz se pracuje
            @data = Array.new
            #@renamed obsahuje informace o provedenych prejmenovani
            @renamed = Hash.new
            #@operations provedenych operaci
            @operations = Array.new
            #@columns nazvy jednotlivych sloupcu
            @columns = Hash.new
            
        end
        
        # pristup k datum a jejich uprava
        def [](row, sdata=nil)
            @data = Array.new if @data.nil?
            @data.push(Hash.new()) if (@data.last()).nil?
            (@data.last())[row] = sdata if !stdata.nil?
        end

        def each
            if block_given?
                @data.each {|i| yield(i)}
            else
              #TODO osetrit variantu, kdy je pouze volana fce s each <-- teoreticky by nemelo nastat
            end
        end

        def each_with_index
            if block_given?
                @data.each_with_index {|v,i| yield(v,i)}
            else
                #TODO osetrit variantu, kdy je pouze volana fce s each <-- teoreticky by nemelo nastat
            end
        end


        def delete_if
            if block_given?
                @data.delete_if{|i| yield(i)}
            end
        end

        #pridani sloupce
        def add_column(name,value)
            @columns = Hash.new if @data.nil?
            @columns[name] = value
            if !(@data.nil?)
                @data.each do |row|
                    row[name]=value if row[name].nil?
                end
            end
        end

        #pridani sloupce
        def set_column(name,value)
            @columns[name] = value
        end
        
        #prejmenovani sloupce
        def rename_column(oldname,newname)
            @renamed[oldname]=newname
            @data.each do |row|
                row[newname] = row[oldname]
            end
        end

        def verify_column(name)
          return false if @columns[name].nil?
          return true
        end

        #navrati pole nazvu sloupcu
        def columns()
            return @columns.keys
        end

        #spojeni dat z vice datasetu
        def join(secDataset,pair)
            #print "\n#{pair}\n"
            pair[0].downcase! unless @columns.include?(pair[0])
            pair[1].downcase! unless secDataset.columns.include?(pair[1])
            @data.each do |row|
                secDataset.each do |row2|
                    #print "\nPorovnavam #{row[pair[0]]} s #{row2[pair[1]]}\n"
                  if (row[pair[0]] == row2[pair[1]])
                    row.merge!(row2)
                    break
                  end
                end
                #secDataset.find(pair[0])
                #TODO zoptimalizovat -> zlepsit slozitost z m*n!
            end
            sloupce = secDataset.columns
            sloupce.each do |sl|
                set_column(sl,nil)
            end

        end

        #seradi vzestupne
        def sort(column,asceding=true)
            if asceding
                @data.sort! {|x,y| x[column] <=> y[column]}
            else
                @data.sort! {|x,y| y[column] <=> x[column]}
            end
        end
        #ulozeni datasetu, v columns jsou uvedeny sloupce, ktere se maji ulozit
        def store(columns=nil)
        end
        
        #vlozeni dat do datasetu
        def push(sdata)
          row = Hash.new
          @columns.each do |column,value|
            nvalue = sdata.shift()
            row.store(column,nvalue)
            row.store(column,value) if row[column].nil?
          end
          @data.push(row)
        end
        
        #navrati dataset sloupcu dle columns
        def get_data(columns=nil)
            @data
        end

        #smazani vsech dat v datasetu
        def clear

        end

        def to_s
            s = ""
            @columns.each_key(){|key| s += key + "\t"}
            s += "\n"
            @data.each do |row|
               row.each_pair { |key,value|
                   s += "#{value}\t" unless value.nil?
               }
                 s += "\n"
            end
        end

        #to_json provede konverzi datasetu do formy JSONu
        def to_json
            i = 0
            datas = Array.new
            td = Array.new

            ds = @data
            ds.each_with_index do |row,index|
                data = "{"
                td.clear
                row.each_pair do |key,value|
                    td.push("#{format(key)}: #{format(value)}")
                end

                data +=td.join(",")
                data += "}"
                datas.push(data)
            end
            data = "[#{datas.join(",")}]"
            data
        end

    def format(input)
        case input
            when Float then
                return input.to_s
            when BigDecimal then
                return input.to_s('F')
            when String then
                return "\"#{input.to_s}\""
            when nil then
                return "\"#{input.to_s}\""
            else
                return input.to_s
        end
    end
end

#class DBStorage
#private



#public
#    #construktor fce
#    def initialize
#        #@data = surova data; @changes = pole zmen
#        @data = SQLite3::Database.new(":memory:")
#        @changes = Hash.new
#    end

#    def create
#        return Dataset.new
#    end

 #   #prida sloupec
 #   #what = jakou tabulku rozsiruje
 #   #column = nazev rozsirujici polozky
 #   def column_add(what, column)
 #       ctype = "TEXT"
 #       ctype = "INT" if(column.is_a?(Integer))
 #       ctype = "FLOAT" if(column.is_a?(Float))

#        query = @data.prepare "Create table :name (Id INTEGER PRIMARY KEY, :column :ctype)"
#        query.stm (what + "_" + column.__id__), column.__id__, ctype
#        query.execute
#
#    end

 #   #prejmenuje sloupce z from na to
 #   # chybi zpusob vyuziti krom prejmenovavani na vystupu
 #   def column_rename(from, to)

 #   end


    #odstrani dany sloupec
 #   def column_remove(what)

 #   end

    #prida radek
    #where - do jake tabulky
    #sdata - data do konkretnich sloupcu
    # funguje na principu zapsani zmen do @changes, pricemz tyto zmeny se pomalu zapisuji do originalni databaze,
    # aby v situaci radku, ktery se bude casto menit se menit v pameti a do DBStorage se ulozil az po ustabilizovani
 #   def add(where,sdata)
 #       @changes[where] = sdata
 #   end

    #odstrani radek
 #   def remove(what)
 #       @changes[what] = nil
 #   end

    #aktualizace radku
 #   def update(how, condition)
 #   end

    #nacteni dat
 #   def load(what)
 #       @data.load(what) if(what.class == String)
 #       @data = what.clone() if(what.class == SQLite3::Database)
 #   end

    #ulozeni dat
 #   def store(where)
 #       tmp = SQLite3::Database.new(where)
 #       tmp = @data.clone
 #       tmp.close
 #   end

 #   #ulozeni vsech zmen
 #   def flush
 #   end

 #   #smazani vsech zmen
 #   def clear
 #   end

    #konfigurace pracovniho prostredi
 #   def configuration(parameters)
 #   end
#end