Portal::App.controllers :tariff do
  layout "main"

  get :index do
    @limits = Limit.all
    @tariffs = Tariff.all
    @packages = Package.all

    @limits_select = Array.new
    @limits.each do |limit|
      @limits_select << [limit.name,limit.id]
    end

    @tariffs_select = Array.new

    @tariffs.each do |tariff|
      logger.debug(tariff.inspect)
      @tariffs_select << [tariff.name,tariff.id]
    end unless @tariffs.nil?

    render "tariff/index"
  end

  post :create, :map =>"create/*model" do
    model = params[:model]
    logger.debug(params.inspect)

    case model
      when "limit"
        next if params[:name].nil? or params[:parameter].nil?
        limit = Limit.new
        limit.name = params[:name]
        limit.parameter = params[:parameter]
        limit.save
      when "tariff"
        tariff = Tariff.new
        tariff.name = params[:name]
        tariff.price = params[:price]
        tariff.limit = Limit.find_by_id(params[:limit])
        tariff.save
      when "package"
        package = Package.new
        package.name = params[:name]
        tariffs = params[:tariffs]
        if(tariffs.is_a?(Array))
          tariffs = tariffs[0] if tariffs.size == 1
          tariffs = tariffs.split(",") if tariffs.include?(",")
        end
        if tariffs.size == 1
          tariff = Tariff.find_by_id(tariffs)
          package.tariffs << tariff unless tariff.nil?
        else
          tariffs.each do |tar|
            logger.debug("Pridavam #{tar}")
            tariff = Tariff.find_by_id(tar)
            package.tariffs << tariff unless tariff.nil?
          end
        end
        package.save
    end
    return 200
  end

  post :delete, :map =>"delete/*model" do
    model = params[:model]
    case model
      when "limit"
        limit = Limit.find_by_id(params[:data])
        limit.destroy unless limit.nil?
      when "tariff"
        tariff = Tariff.find_by_id(params[:data])
        tariff.destroy unless tariff.nil?
      when "package"
        package = Package.find_by_id(params[:data])
        package.destroy unless package.nil?
    end
    return 200
  end

  post :create do
    unless params["sim"].nil?
      tariff = Tariff.new
      tariff.serial = params["sim"]
      tariff.phone = params["phone"]
      tarif.save
    end

    @phones = Sim.all
    render "sim/list.erb"
  end

  post :update do

  end

  post :delete do
    phone = Sim.find_by serial: params["data"]
    phone.delete unless phone.nil?

    @phones = Sim.all
    return 202
  end
end