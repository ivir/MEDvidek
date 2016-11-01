Portal::Report.controllers :list do
  
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
    'Hello world!'
  end

  get :search do
    # vyhleda konkretni obdobi
  end

  post :export do
    #provede export do PDF, CSV, HTML
  end

  post :store do
    #ulozeni zaznamu do DB
    person = params["name"]

    bill = Billing.new
    bill.name = person
    bill.save
  end

  get :load do
    #nacteni reportu za dany mesic s notifikaci zdali vyuctovani akceptovali nebo ne
  end

  get :generate do
    #vygenerovani notifikaci uzivatelum pro potvrzeni
  end
end
