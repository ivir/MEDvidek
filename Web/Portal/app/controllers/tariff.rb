Portal::App.controllers :tariff do
  layout "main"

  get :index do
    @limits = Limit.all
    @tariffs = Tariff.all
    @packages = Package.all

    render "tariff/index"
  end

  post :create, :map =>"create/*model" do
    model = params[:model]
    case model
      when "limit"
        limit = Limit.new
        limit.name = params[:name]
        limit.parameter = params[:parameter]
        limit.save
      when "tariff"
        tariff = Tariff.new
        tariff.name = params[:name]
        tariff.price = params[:price]
        tariff.limit = params[:limit_id]
        tariff.save
      when "package"
        package = Package.new
        package.name = params[:name]
        package.save
    end
    render "tariff/index"
  end

  post :delete, :map =>"delete/*model" do
    model = params[:model]
    case model
      when "limit"
        limit = Limit.find_by_id(params[:id])
        limit.destroy unless limit.nil?
      when "tariff"
        tariff = Tariff.find_by_id(params[:id])
        tariff.destroy unless tariff.nil?
      when "package"
        package = Package.find_by_id(params[:id])
        package.destroy unless package.nil?
    end
    render "tariff/index"
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