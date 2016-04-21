Builder::App.controllers :build do
  
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
  post :verify, :map => "/verify" do
    #overeni funkcnosti receptu
  end
    
  post :upload, :map => "/upload" do
    #harani souboru
    #vezmeme soubor, ulozime do tempu a navratime cestu
    path = 'upload/' + params['file'][:filename]
    File.open(path, "w") do |f|
      f.write(params['file'][:tempfile].read)
    end
    return path
  end

end
