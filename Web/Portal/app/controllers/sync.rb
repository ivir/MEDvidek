Portal::App.controllers :sync do
#kontrolér pro provádění synchronizace dat
  get :index do
    @tariffs = Tariff.all
    render "tariff/index"
  end
end