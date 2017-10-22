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
    # res = Amazon::Ecs.item_lookup(params[:id], {:response_group => 'Large', id_type: 'upc', search_index: 'All'})
    # item = res.get_element("Item").to_s
    # @item = Crack::XML.parse(item).to_json    
    @data = File.read("#{Rails.root}/public/data.json")
    render json: @data
    
  end
end
