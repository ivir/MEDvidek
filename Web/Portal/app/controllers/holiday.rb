Portal::App.controllers :holiday do
  layout "main"

  get :index do
    @tariffs = Tariff.all
    render "tariff/holiday"
  end
end