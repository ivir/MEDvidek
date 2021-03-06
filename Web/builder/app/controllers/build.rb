require_relative("../../../../arbitrMED")
require 'json'

Builder::App.controllers :build do
  
  # get :index, :map => '/foo/bar' do
  #   session[:foo] = 'bar'
  #   render 'index'
  # end

  get :index, :map => "/" do
    session[:test] = 'zkouska'
    render 'builder'
  end


  #osetreni ziskani CSRF tokenu pro moznost nahravani dat pomoci GET/POST
  get :csrf_token, :map => '/csrf_token', :provides => :json do
    logger.debug 'Retrieving csrf_token'
    result = '{ "csrf": "' + session[:csrf] + '"}'
    logger.debug result
    result
  end

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
  post :verify, :map => "/verify" do
    #ulozeni receptu
    logger.debug params.to_s
    recipe = params["recipe"]

    #osetreni cest
    data = YAML.load(recipe)
    data.each { |modu|
      modu.each { |modul,parameters|
        parameters.each {|k, val|
          next unless val.is_a?(String)
          soubor = File.basename(val)
          uplna_cesta = File.join("temp", session[:session_id],soubor)
          parameters[k] = uplna_cesta if File.exist?(uplna_cesta)
          if( (k == "file") && (modul.include?("Export") || modul.include?("Report")))
            parameters[k] = uplna_cesta
            p "Nastavuji parametr #{k} na #{uplna_cesta}"
          end
        }
      }
    }

    app = ArbitrMED.new
    app.loadRecipeYAML(data)
    app.cook() #provedeme predany recept
    out = app.getOutput()
    return '{"result":' + out.to_json() + '}' if out.respond_to? :to_json
    return JSON.generate({:result => out})
  end
    
  post :upload, :map => "/upload" do
    #nahravani souboru
    #vezmeme soubor, ulozime do tempu a navratime cestu
    logger.debug params.to_s
    userdir = File.join("temp", session[:session_id])
    FileUtils.mkdir_p(userdir)
    path = File.join(userdir,params["0"][:filename])

    #zkopirujeme docasny soubor na spravne misto
    FileUtils.cp(params["0"][:tempfile].path,path)
    return params["0"][:filename]
  end

  get :download_file, :map => "/download/:file" do
    #fce pro osetreni moznosti stazeni dat
    uplna_cesta = File.join("temp", session[:session_id],params[:file])
    send_file(uplna_cesta,:filename => File.basename(uplna_cesta), :disposition => 'attachment') if File.exist?(uplna_cesta)
  end

  get :download, :map => "/download" do
    #vypisovani vsech souboru v adresari s moznosti stazeni
    userdir = File.join("temp", session[:session_id])
    FileUtils.mkdir_p(userdir) # nutno osetrit zdali nahodou jiz neexistuje
    @files = Dir.entries(userdir)
    @files.delete_if{|val| (val == ".") || (val == "..")}
    render 'download'
    #vypiseme ulozene soubory
  end

  delete :dowload_del, :map => "/download" do
    #smazeme zvoleny soubor
  end

  get :process, :map => "/process" do
    #zobrazi formular spolu s jiz nahranymi daty v ramci sance
    userdir = File.join("temp", session[:session_id])
    FileUtils.mkdir_p(userdir) # nutno osetrit zdali nahodou adresar jiz neexistuje
    @files = Dir.entries(userdir)
    @files.delete_if{|val| (val == ".") || (val == "..")}
    render "process"
  end
  get :process_file, :map => "/process/:file" do

    #fce prijala recept a zpracuje jej

    nazev = File.basename(params[:file])
    uplna_cesta = File.join("temp", session[:session_id],nazev)
    data = YAML.load_file(uplna_cesta)
    # nahradime nazvy souboru za uplne cesty k nemu;
    # nahrada se provede v okamziku, kdy soubor existuje;

    # samostatne je osetrena situace, kdy se jedna o Export nebo Report dat, pak se u parametru file provede nahrada
    data.each { |modu|
      modu.each { |modul,parameters|
        parameters.each {|k, val|
          next unless val.is_a?(String)
          soubor = File.basename(val)
          uplna_cesta = File.join("temp", session[:session_id],soubor)
          parameters[k] = uplna_cesta if File.exist?(uplna_cesta)
          if( (k == "file") && (modul.include?("Export") || modul.include?("Report")))
            parameters[k] = uplna_cesta
            p "Nastavuji parametr #{k} na #{uplna_cesta}"
          end
        }
      }
    }
    #--------------
    app = ArbitrMED.new
    app.loadRecipeYAML(data)
    app.cook() #provedeme predany recept
    out = app.getOutput()
    return '{"result":' + out.to_json() + '}' if out.respond_to? :to_json
    return JSON.generate({:result => out})
  end

end

