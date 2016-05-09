require_relative('../module_med')
require 'erb'
require 'ostruct'

#-----------
# zdroj - http://stackoverflow.com/questions/3242470/problem-using-openstruct-with-erb/8293786#8293786
# trida pro omezeni pristupu k datum

class ErbBinding < OpenStruct
  def get_binding
    return binding()
  end
end

#-----------
class Report < ModuleMED

  def properties(memory,fdata)
    #printf "Spusten\n"
    #print fdata
    @memory = memory
    @template = fdata["template"]
    @orientation = fdata["orientation"]
    @format = fdata["format"]
    @store = fdata["store"]
    @file = fdata["file"]

    @memory["output"] = @store
    ''
  end

  def execute(fdata)
    #printf "Jdu pracovat\n"

    vars = ErbBinding.new(@memory)

    template = "foo <%= bar %>"
    erb = ERB.new(File.read(@template))

    vars_binding = vars.send(:get_binding)
    vysledek = erb.result(vars_binding)

    case @format
      when "pdf"
        # generujeme do PDF
        kit = PDFKit.new(vysledek, :page_size => 'A4')
        #CSS styl
        #kit.stylesheets << '/path/to/css/file'

        # Get an inline PDF
        @memory[@store] = kit.to_pdf unless @store.nil?

        # Save the PDF to a file
        file = kit.to_file(@file) unless @file.nil?

      when "txt"
        # generovani do TXT souboru
      when "html"
        # generovani do HTML
      else
        #neznamy format -> ulozime do store
        @memory[@store] = vysledek unless @store.nil?
    end

  end

end