Portal::App.controllers :tariff do
  layout "main"

  get :index do
    @tariffs = Tariff.all
    render "tariff/index"
  end
end