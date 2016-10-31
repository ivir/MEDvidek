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
    session[:datapath] = "mares"
    #vypisovani vsech souboru v adresari s moznosti stazeni
    userdir = File.join("temp", session[:datapath])
    FileUtils.mkdir_p(userdir) # nutno osetrit zdali nahodou jiz neexistuje
    @files = Dir.entries(userdir)
    @files.delete_if{|val| (val == ".") || (val == "..")}
    render 'download'
    #vypiseme ulozene soubory
  end

  get :list do
    # :with => [:id, :name], :provides => [:html, :json]
    userdir = File.join("temp", session[:datapath])
    FileUtils.mkdir_p(userdir) # nutno osetrit zdali nahodou jiz neexistuje
    @files = Dir.entries(userdir)
    @files.delete_if{|val| (val == ".") || (val == "..")}
    JSON.generate(@files)
  end

  post :upload do
    #nahravani souboru
    #vezmeme soubor, ulozime do tempu a navratime cestu
    logger.debug params.to_s
    userdir = File.join("temp", session[:datapath])
    FileUtils.mkdir_p(userdir)
    path = File.join(userdir,params["0"][:filename])

    #zkopirujeme docasny soubor na spravne misto
    FileUtils.cp(params["0"][:tempfile].path,path)
    return params["0"][:filename]
  end

  delete :delete do
    userdir = File.join("temp", session[:datapath])
    path = File.join(userdir,params["file"])
    FileUtils.rm_f(path)
  end

  get :delete do
    userdir = File.join("temp", session[:datapath])
    FileUtils.mkdir_p(userdir)
    path = File.join(userdir,params["file"])
    FileUtils.rm_f(path)
  end

  get :new do
    userdir = File.join("temp", session[:datapath],params["name"])
    FileUtils.mkdir_p(userdir)
  end

  get :download do
    uplna_cesta = File.join("temp", session[:session_id],params[:file])
    send_file(uplna_cesta,:filename => File.basename(uplna_cesta), :disposition => 'attachment') if File.exist?(uplna_cesta)
  end

  get :path do

  end

  post :store do
    userdir = File.join("temp", session[:datapath])
    FileUtils.mkdir_p(userdir)
    path = File.join(userdir,params["name"])

    #zkopirujeme docasny soubor na spravne misto
    f = File.new(path,"w+")
    f.write(params["data"])
    f.close
  end

  get :load do
    userdir = File.join("temp", session[:datapath])
    path = File.join(userdir,params["name"])

    #zkopirujeme docasny soubor na spravne misto
    File.open(path)
  end

end
