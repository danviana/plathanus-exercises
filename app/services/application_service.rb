class ApplicationService
  attr_reader :errors, :record

  class_attribute :model_name

  def self.service_for(model_name)
    self.model_name = model_name.to_s.classify
  end

  def initialize(parameters = {})
    @parameters = parameters

    @success = false
    @errors = []
  end

  def create
    record = model.new(@parameters)

    save_record(record)
  end

  def update(id)
    record = model.find(id)

    images_param = @parameters.delete(:images)
    record.assign_attributes(@parameters)
    record.images.attach(images_param) if images_param.present?

    save_record(record)
  end

  def destroy(id)
    record = model.find(id)

    if record.destroy
      @success = true
      @record = record
    else
      @success = false
      @errors = record.errors.full_messages
    end
  end

  def success?
    @success
  end

  private

  def model
    self.class.model_name.constantize
  end

  def save_record(record)
    if record.save
      @success = true
      @record = record.reload
    else
      @success = false
      @errors = record.errors.full_messages
    end
  end
end
