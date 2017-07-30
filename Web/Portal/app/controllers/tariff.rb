Portal::App.controllers :tariff do

  get :index do
    @tariffs = Tariff.all
    render "tariff/index"
  end
end