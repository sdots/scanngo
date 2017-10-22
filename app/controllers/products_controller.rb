class ProductsController < ApplicationController
  require 'amazon/ecs'
  require 'crack'


  def index
    Amazon::Ecs.configure do |options|
      options[:AWS_access_key_id] = 'AKIAJUCJ6YE2NQVJIAAA'
      options[:AWS_secret_key] = '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'
      options[:associate_tag] = 'gruupie2017-20'
    end

    # Search Amazon US
    res = Amazon::Ecs.item_lookup(params[:id], {:response_group => 'Medium'})
    item = res.get_element("Item").to_s
    @item = Crack::XML.parse(item).to_json    

    render json: @item
    
  end
end
