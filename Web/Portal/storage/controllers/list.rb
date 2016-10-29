Portal::Storage.controllers :list do
  
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
    #vypisovani vsech souboru v adresari s moznosti stazeni
    userdir = File.join("temp", session[:session_id])
    FileUtils.mkdir_p(userdir) # nutno osetrit zdali nahodou jiz neexistuje
    @files = Dir.entries(userdir)
    @files.delete_if{|val| (val == ".") || (val == "..")}
    render 'download'
    #vypiseme ulozene soubory
  end

  get :list do

  end

  post :upload do

  end

  get :delete do

  end

  get :new do

  end

  get :download do

  end

  get :path do

  end

end
