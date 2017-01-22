Portal::App.controllers :main do
  
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
  
  get :index, :map => "/" do
    @soubory = buildTree(userDir(),/\.yml$/)
    render 'main/index'
  end

  post :process do

  end

  get :login, :map => "/login" do
    render 'main/login'
  end

  post :login, :map => "/login" do
    if account = Account.authenticate(params[:username], params[:password])
      logger.debug account
      Account.current = account
      redirect url(:main, :index)
    else
      params[:email] = h(params[:email])
      flash.now[:error] = pat('login.error')
      @error = "Chybné uživatelské jméno nebo heslo"
      render "/main/login"
    end
  end

  delete :login, :map => "/login" do
    set_current_account(nil)
    redirect url(:main, :index)
  end
  get :logout, :map => "/logout" do
    set_current_account(nil)
    Account.current = nil
    redirect url(:main, :index)
  end

end
