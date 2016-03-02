require 'trello'

Trello.configure do |config|
  # API key generated by visiting https://trello.com/1/appKey/generate
  config.developer_public_key = ENV['TRELLO_PUBLIC_KEY']

  # Member token
  # larry-price.com/blog/2014/03/18/connecting-to-the-trello-api/
  config.member_token = ENV['TRELLO_MEMBER_TOKEN']
end