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

  get :csrf_token, :map => "csrf_token", :provides => :json do
    logger.debug 'Retrieving csrf_token'
    result = '{ "csrf": "' + session[:csrf] + '"}'
    logger.debug result
    result
  end
  
  get :index, :map => "/" do

    #vypisovani vsech souboru v adresari s moznosti stazeni
    @userdir = userDir()
    @files = Array.new
    FileUtils.mkdir_p(@userdir) # nutno osetrit zdali nahodou jiz neexistuje
    file = Dir.entries(@userdir)
    file.delete_if{|val| (val == ".") || (val == "..")}

    file.each do |item|
      full_path = File.join(@userdir,item)
        @files.push([item])
    end

    render 'download'
    #vypiseme ulozene soubory
  end

  get :list, :provides => [:html, :json, :js], :map => "list/*path" do
    # :with => [:id, :name], :provides => [:html, :json]

    userdir = userDir()
    FileUtils.mkdir_p(userdir) # nutno osetrit zdali nahodou jiz neexistuje

    path = params[:path]

    logger.debug params
    logger.debug "Cesta #{path}"
    @files = Array.new

    unless path.nil?
      path.gsub!(/^\.+/,'')
      userdir = File.join(userdir,path)
    else
      path = "/"
    end

    @userdir = userDir()

    if(Dir.exists?(userdir)) then
      file = Dir.entries(userdir)
      file.delete_if{|val| (val == ".") || (val == "..")}

      file.each do |item|
        spath = File.join(path,item)
        @files.push(spath.split(File::SEPARATOR))
      end
    end
    unless path.nil? then
      back = path.split(File::SEPARATOR)

      if back.size < 2 then
        @files.unshift([".."])
      else
        back.pop()
        @files.unshift(back)
      end
    end

    case content_type
      when :js
        JSON.generate(@files)
      when :json
        JSON.generate(@files)
      when :html
        render 'download'
    end

  end

  post :upload, :map => "upload" do
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

  delete :delete, :map => "delete" do
    userdir = userDir()
    path = File.join(userdir,params["file"])
    FileUtils.rm_f(path)
  end

  post :delete, :map => "delete" do
    userdir = userDir()
    FileUtils.mkdir_p(userdir)
    path = File.join(userdir,params["file"])
    FileUtils.rm_f(path)
  end

  get :new do
    userdir = File.join(userDir(),params["name"])
    FileUtils.mkdir_p(userdir)
  end

  get :download, :with => :file, :map => "download" do
    if params[:file].nil? then
      halt 404, "Not found"
    end

    sfile = params[:file].gsub(/\.+\//,'')
    uplna_cesta = File.join(userDir(),sfile)

    unless File.exists?(uplna_cesta) then
      halt 404, "File not found"
    end

    send_file(uplna_cesta,:filename => File.basename(uplna_cesta), :disposition => 'attachment')
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
