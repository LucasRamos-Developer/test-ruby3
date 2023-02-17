class Address < ApplicationRecord
  has_and_belongs_to_many :users

  validates_presence_of :zipcode, :result

  after_create :send_webhooks

  def send_webhooks
    WebhookService.new.send("teste")
  end
end
