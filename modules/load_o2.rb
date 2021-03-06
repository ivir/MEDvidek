require_relative('../module_med')
require_relative('../db_storage')

require_relative("../modules/tools")

gem 'nokogiri'
require 'nokogiri'
require 'date'

class LoadO2 < ModuleMED

  def properties(memory,fdata)

    @store = fdata["store"]
    @memory = memory
    #@store = Dataset.new if @store.nil?
    @columns = fdata["information"]
    @file = fdata["file"]

    @file = @memory[@file] unless @memory[@file].nil?

    @memory["output"] = @store

    @data = Dataset.new
    @columns.each do |col|
      @data.add_column(col, 0)
    end
    ''
  end

  def execute(fdata)

    @file = @file[0] if @file.is_a?(Array)

    doc = Nokogiri::XML(File.open(@file))

    globalInfo = doc.css('summaryHead')
    #<summaryHead payerRefNum="3606068384"><billingPeriod to="2016-12-31" from="2016-12-01"/></summaryHead>
    billing = globalInfo.at_css("billingPeriod")
    refInfo = globalInfo.at_css('summaryHead')
    from = billing["from"]
    to = billing["to"]
    p globalInfo.to_s
    o2Year = Date.parse(from).year
    o2Month = Date.parse(from).month
    o2Reference = convert(refInfo["payerRefNum"])

    @memory.store("o2Year",o2Year)
    @memory.store("o2Month",o2Month)
    @memory.store("o2Reference",o2Reference)
    #-----
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
    include Format

    def subscriber(node)
      phoneNumber = node["phoneNumber"]
      #puts phoneNumber
      summaryPrice = node["summaryPrice"]

      @line["mobil"] = convert(phoneNumber)
      @line["uctovano"] = convert summaryPrice

      regularCharges node
      usageCharges node
      discounts node
      payments node

    end

    def regularCharges(node)
      regch = node.at_css("regularCharges")
      standardni_cena = regch["rcTotalPrice"] unless regch.nil?

      @line["tarifni_castka"] = convert(standardni_cena)
    end

    def usageCharges(node)
      usach = node.at_css("usageCharges")
      uctovana_castka = usach["ucTotalPrice"] unless usach.nil?

      @line["uctovana_castka"] = convert(uctovana_castka)

      #podrobne polozky

      @line["data_castka"] = getValue(usach,'usageCharge[usageType="D"]','subtotalPrice')
      @line["volani_castka"] = getValue(usach,'usageCharge[usageType="V"]','subtotalPrice')
      @line["zpravy_castka"] = getValue(usach,'usageCharge[usageType="M"]','subtotalPrice')
      @line["roaming_castka"] = getValue(usach,'usageCharge[usageType="R"]','subtotalPrice')

      @line["data_objem"] = getValue(usach,'usageCharge[usageType="D"] ucItem','quantity')
      @line["data_jednotka"] = getValue(usach,'usageCharge[usageType="D"] ucItem','displayedUom')
    end

    def discounts(node)
      disc = node.at_css("discounts")
      sleva = disc["discountTotalPrice"] unless disc.nil?

      @line["sleva"] = convert(sleva)

    end

    def payments(node)
      paym = node.at_css("payments")
      treti_strana = paym["paymentTotalPrice"] unless paym.nil?

      @line["treti_strana"] = convert(treti_strana)

    end

    def getValue(node,path,value)
      #nalezne hodnotu a provede konverzi, kterou navrati
      return nil if node.nil?
      where = node.at_css(path)
      something = where[value] unless where.nil?

      convert(something)
    end

end