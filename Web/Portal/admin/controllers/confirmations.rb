Portal::Admin.controllers :confirmations do
  get :index do
    @title = "Confirmations"
    @confirmations = Confirmation.all
    render 'confirmations/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'confirmation')
    @confirmation = Confirmation.new
    render 'confirmations/new'
  end

  post :create do
    @confirmation = Confirmation.new(params[:confirmation])
    if @confirmation.save
      @title = pat(:create_title, :model => "confirmation #{@confirmation.id}")
      flash[:success] = pat(:create_success, :model => 'Confirmation')
      params[:save_and_continue] ? redirect(url(:confirmations, :index)) : redirect(url(:confirmations, :edit, :id => @confirmation.id))
    else
      @title = pat(:create_title, :model => 'confirmation')
      flash.now[:error] = pat(:create_error, :model => 'confirmation')
      render 'confirmations/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "confirmation #{params[:id]}")
    @confirmation = Confirmation.find(params[:id])
    if @confirmation
      render 'confirmations/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'confirmation', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "confirmation #{params[:id]}")
    @confirmation = Confirmation.find(params[:id])
    if @confirmation
      if @confirmation.update_attributes(params[:confirmation])
        flash[:success] = pat(:update_success, :model => 'Confirmation', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:confirmations, :index)) :
          redirect(url(:confirmations, :edit, :id => @confirmation.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'confirmation')
        render 'confirmations/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'confirmation', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Confirmations"
    confirmation = Confirmation.find(params[:id])
    if confirmation
      if confirmation.destroy
        flash[:success] = pat(:delete_success, :model => 'Confirmation', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'confirmation')
      end
      redirect url(:confirmations, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'confirmation', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Confirmations"
    unless params[:confirmation_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'confirmation')
      redirect(url(:confirmations, :index))
    end
    ids = params[:confirmation_ids].split(',').map(&:strip)
    confirmations = Confirmation.find(ids)
    
    if Confirmation.destroy confirmations
    
      flash[:success] = pat(:destroy_many_success, :model => 'Confirmations', :ids => "#{ids.join(', ')}")
    end
    redirect url(:confirmations, :index)
  end
end
