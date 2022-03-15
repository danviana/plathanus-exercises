class PropertiesController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :load_property, only: %i[edit]

  def index
    @records = Property.all
  end

  def new
    @property = Property.new
  end

  def create
    service = PropertyService.new(create_params)

    service.create

    if service.success?
      flash[:success] = 'Propriedade criada com sucesso!'
    else
      flash[:error] = service.errors.join(', ')
    end

    redirect_to action: :new
  end

  def edit; end

  def update
    service = PropertyService.new(update_params)

    service.update(record_id)

    if service.success?
      flash[:success] = 'Propriedade alterada com sucesso!'
    else
      flash[:error] = service.errors.join(', ')
    end
    redirect_to action: :edit
  end

  def destroy
    service = PropertyService.new

    service.destroy(record_id)

    if service.success?
      flash[:success] = 'Propriedade excluída com sucesso!'
    else
      flash[:error] = service.errors.join(', ')
    end

    redirect_to action: :index
  end

  def remove_image
    attachment = Property.find(params[:property_id]).images.find(params[:attachment_id])
    attachment.purge

    redirect_back(fallback_location: { action: 'edit', id: params[:property_id] })
  rescue StandardError => e
    flash[:error] = e.message
    redirect_back(fallback_location: { action: 'edit', id: params[:property_id] })
  end

  protected

  def create_params
    params.require(:property).permit(:name, images: [])
  end

  def update_params
    create_params
  end

  def record_id
    params[:id]
  end

  def load_property
    @property = Property.find(record_id)
  end
end
