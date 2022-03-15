class RomanNumeralsController < ApplicationController
  def index
    if params[:number].present?
      service = RomanNumeralService.new

      service.convert_to_roman_numeral(params[:number])

      if service.success
        @number = params[:number]
        @converted_number = service.converted_number
      else
        flash[:error] = service.errors.join(', ')
      end
    end

    render :index, locals: { number: @number, converted_number: @converted_number }
  end
end
