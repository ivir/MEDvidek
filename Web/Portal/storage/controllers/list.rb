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

  get :csrf_token, :map => "/csrf_token", :provides => :json do
    logger.debug 'Retrieving csrf_token'
    result = '{ "csrf": "' + session[:csrf] + '"}'
    logger.debug result
    result
  end
  
  get :index, :map=>"/" do

    #vypisovani vsech souboru v adresari s moznosti stazeni
    @userdir = userDir()
    FileUtils.mkdir_p(@userdir) # nutno osetrit zdali nahodou jiz neexistuje
    @files = Dir.entries(@userdir)
    @files.delete_if{|val| (val == ".") || (val == "..")}
    render 'download'
    #vypiseme ulozene soubory
  end

  get :list, :provides => [:html, :json] do
    # :with => [:id, :name], :provides => [:html, :json]

    userdir = userDir()
    path = params[:dir]

    unless path.nil?
      path.gsub!(/^\.+/,'')
      userdir = File.join(userdir,path)
    end

    @userdir = userdir
    FileUtils.mkdir_p(userdir) # nutno osetrit zdali nahodou jiz neexistuje
    @files = Dir.entries(userdir)
    @files.delete_if{|val| (val == ".") || (val == "..")}
    @files.unshift("..") unless path.nil?
    case content_type
      when :js
        JSON.generate(@files)
      when :html
        render 'download'
    end

  end

  post :upload do
    #nahravani souboru
    #vezmeme soubor, ulozime do tempu a navratime cestu
    logger.debug params.to_s
    userdir = userDir()
    FileUtils.mkdir_p(userdir)
    path = File.join(userdir,params["0"][:filename])

    #zkopirujeme docasny soubor na spravne misto
    FileUtils.cp(params["0"][:tempfile].path,path)
    return params["0"][:filename]
  end

  delete :delete do
    userdir = userDir()
    path = File.join(userdir,params["file"])
    FileUtils.rm_f(path)
  end

  get :delete do
    userdir = userDir()
    FileUtils.mkdir_p(userdir)
    path = File.join(userdir,params["file"])
    FileUtils.rm_f(path)
  end

  get :new do
    userdir = File.join(userDir(),params["name"])
    FileUtils.mkdir_p(userdir)
  end

  get :download do
    uplna_cesta = File.join(userDir(),params[:file])
    send_file(uplna_cesta,:filename => File.basename(uplna_cesta), :disposition => 'attachment') if File.exist?(uplna_cesta)
  end

  get :path do

  end

  post :directory, :with => [:dir] do
    userdir = File.join(userDir(),:dir)
    FileUtils.mkdir_p(userdir)
    redirect url(:index)
  end

  post :store do
    userdir = userDir()
    FileUtils.mkdir_p(userdir)
    path = File.join(userdir,params["name"])

    #zkopirujeme docasny soubor na spravne misto
    f = File.new(path,"w+")
    f.write(params["data"])
    f.close
  end

  get :load do
    userdir = userDir()
    path = File.join(userdir,params["name"])

    #zkopirujeme docasny soubor na spravne misto
    File.open(path)
  end

end
