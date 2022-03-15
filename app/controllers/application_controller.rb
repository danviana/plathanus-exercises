class ApplicationController < ActionController::Base
  after_action :check_page_content

  private

  def check_page_content
    return unless response.body.include? 'You are being'

    html_doc = Nokogiri::HTML(response.body)
    uri = html_doc.css('a').map { |link| link['href'] }.first
    response.body = "<script>window.location.replace('#{uri}');</script>"
  end
end
