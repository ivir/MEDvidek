Portal::App.controllers :sim do
  layout "main"
  # get :index, :map => '/foo/bar' do
  #   session[:foo] = 'bar'
  #   render 'index'
  # end

  # get :sample, :map => '/sample/url', :provides => [:any, :js] do
  #   case content_type
  #     when :js then ...
  #     else ...
  # end

  # get :foo, :with => :id do
  #   "Maps to url '/foo/#{params[:id]}'"
  # end

  # get '/example' do
  #   'Hello world!'
  # end
  
  get :index do
    @phones = Sim.all
    render "sim/list.erb"
  end

  post :create do
    unless params["sim"].nil?
      phone = Sim.new
      phone.serial = params["sim"]
      phone.phone = params["phone"]
      phone.save
    end
    unless params["data"].nil?
      phone = Sim.new
      phone.serial = params["data"]["sim"]
      phone.phone = params["data"]["phone"]
      phone.save
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

  get :sync do

  end

end
