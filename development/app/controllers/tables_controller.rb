class TablesController < ApplicationController
  # before_filter :check_role
  before_filter :prepare_model_name, only:   [:records]
  before_filter :set_class_name,     except: [:index]
  before_filter :set_fields_and_associations, only: [:new, :edit]
  before_filter :find_instance,      only:   [:edit, :update, :destroy]

  layout 'tables'

  def index
    @models = Dir.glob("#{Rails.root}/app/models/*.rb").map{ |path| File.basename(path).gsub('.rb', '').gsub('_', ' ').capitalize }.sort
  end

  def records
    @models = Dir.glob("#{Rails.root}/app/models/*.rb").map{ |path| File.basename(path).gsub('.rb', '').gsub('_', ' ').capitalize }.sort
    @records      = @class_name.all.page(params[:page]).per(50)
    @fields       = @class_name.fields.reject{ |field| field.to_s.include? '_id' }
    @associations = ClassBuilder.associations(@class_name)
  end

  def new
  end

  def create
    instance = @class_name.create(class_params)
    if instance.persisted?
      flash[:notice] = "#{@class_name} created successfully"
      redirect_to records_tables_path(model_name: params[:model_name])
    else
      flash[:error] = instance.errors.full_messages.to_sentence
      redirect_to :back
    end
  end

  def edit
  end

  def update
    if @instance.update(class_params)
      flash[:notice] = "#{@class_name} updated successfully"
      redirect_to records_tables_path(model_name: params[:model_name])
    else
      flash[:error] = @instance.errors.full_messages.to_sentence
      redirect_to :back
    end
  end

  def destroy
    @instance.destroy
    flash[:notice] = "#{@class_name} deleted successfully"
    redirect_to records_tables_path(model_name: params[:model_name])
  end

  protected

  def prepare_model_name
    params[:model_name] = params[:model_name].gsub(' ', '_').camelcase
  end

  def set_class_name
    @class_name = params[:model_name].constantize
  end

  def set_fields_and_associations
    @fields       = changable_fields
    @associations = ClassBuilder.associations(@class_name)
  end

  def find_instance
    @instance = @class_name.find(params[:id])
  end

  def class_params
    class_name_sym = params[:model_name].downcase.to_sym

    fields = changable_fields
    fields.each do |field, configs|
      # convert string to time
      params[class_name_sym][field] = params[class_name_sym][field].to_time if configs[:type] == Time
      # convert string to integer
      params[class_name_sym][field] = params[class_name_sym][field].to_i    if configs[:type] == Integer
    end

    # posibility to set nil association
    associations = ClassBuilder.associations(@class_name)
    associations.each do |class_name, target_name|
      params[class_name_sym]["#{target_name}_id"] = nil if params[class_name_sym]["#{target_name}_id"].blank?
    end

    params.require(class_name_sym).permit(fields.keys + association_params)
  end

  def changable_fields
    ClassBuilder.fields(@class_name)
  end

  def association_params
    ClassBuilder.associations(@class_name).map{ |a| "#{a[1].to_s}_id" }
  end

  def check_role
    authorize :admin, :admin?
  end
end
