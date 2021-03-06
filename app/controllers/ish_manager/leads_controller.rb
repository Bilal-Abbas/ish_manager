class IshManager::LeadsController < IshManager::ApplicationController

  def index
    authorize! :index, Ish::Lead
    @leads = Ish::Lead.where( :profile => current_user.profile, :is_trash => false )
    if params[:is_done]
      @leads = @leads.where( :is_done => true )
    else
      @leads = @leads.where( :is_done => false )
    end
    render :layout => 'ish_manager/application_no_materialize'
  end

  def new
    @new_lead = Ish::Lead.new
    authorize! :new, @new_lead
  end

  def create
    @lead = Ish::Lead.new params[:lead].permit!
    @lead.profile = current_user.profile
    authorize! :create, @lead
    if @lead.save
      flash[:notice] = "created lead"
    else
      flash[:alert] = "Cannot create lead: #{@lead.errors.messages}"
    end
    redirect_to :action => 'index'
  end

  def show
    authorize! :redirect, IshManager::Ability
    redirect_to :action => :edit, :id => params[:id]
  end

  def edit
    @lead = Ish::Lead.find params[:id]
    authorize! :edit, @lead
  end

  def update
    @lead = Ish::Lead.find params[:id]
    authorize! :update, @lead
    if @lead.update_attributes params[:lead].permit!
      flash[:notice] = 'Successfully updated lead.'
    else
      flash[:alert] = "Cannot update lead: #{@lead.errors.messages}"
    end
    redirect_to :action => 'index'
  end

end
