Portal::App.controllers :holiday do
  layout "main"

  get :index do
    @tariffs = Travel.all
    render "tariff/holiday"
  end
end