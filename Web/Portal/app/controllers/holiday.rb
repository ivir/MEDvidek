Portal::App.controllers :holiday do

  get :index do
    @tariffs = Tariff.all
    render "tariff/index"
  end
end