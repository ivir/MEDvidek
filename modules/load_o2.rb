require_relative('../module_med')
require_relative('../db_storage')

gem 'nokogiri'
require 'nokogiri'

class LoadO2 < ModuleMED

  def properties(memory,fdata)

    @store = fdata["store"]
    @memory = memory
    #@store = Dataset.new if @store.nil?
    @columns = fdata["information"]
    @file = fdata["file"]

    @data = Dataset.new
    @columns.each do |col|
      @data.add_column(col, 0)
    end
    ''
  end

  def execute(fdata)

    doc = Nokogiri::XML(File.open(@file))

    subs = doc.css('subscriber')
    #puts subs
    @line = Hash.new
    @content = Array.new

    subs.each do |su|

      subscriber(su)

      @columns.each do |col|
        @content.push @line[col]
      end

      @data.push @content

      @line.clear
      @content.clear
    end
    #puts @data
    @data
    @memory.store(@store,@data)
  end

  private
    def subscriber(node)
      phoneNumber = node["phoneNumber"]
      #puts phoneNumber
      summaryPrice = node["summaryPrice"]

      @line["mobil"] = Integer(phoneNumber)
      @line["uctovano"] = summaryPrice

      regularCharges node
      usageCharges node
      discounts node
      payments node

    end

    def regularCharges(node)
      regch = node.at_css("regularCharges")
      standardni_cena = regch["rcTotalPrice"] unless regch.nil?

      @line["tarifni_castka"] = standardni_cena
    end

    def usageCharges(node)
      usach = node.at_css("usageCharges")
      uctovana_castka = usach["ucTotalPrice"] unless usach.nil?

      @line["uctovana_castka"] = uctovana_castka
    end

    def discounts(node)
      disc = node.at_css("discounts")
      sleva = disc["discountTotalPrice"] unless disc.nil?

      @line["sleva"] = sleva

    end

    def payments(node)
      paym = node.at_css("payments")
      treti_strana = paym["paymentTotalPrice"] unless paym.nil?

      @line["treti_strana"] = treti_strana

    end
end