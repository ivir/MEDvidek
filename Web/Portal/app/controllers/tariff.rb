Portal::App.controllers :tariff do
  layout "main"

  get :index do
    @tariffs = Tariff.all
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