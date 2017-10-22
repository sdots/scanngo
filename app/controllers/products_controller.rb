class ProductsController < ApplicationController
  require 'amazon/ecs'
  require 'crack'


  def index
    # Amazon::Ecs.configure do |options|
    #   options[:AWS_access_key_id] = 'AKIAJUCJ6YE2NQVJIAAA'
    #   options[:AWS_secret_key] = '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'
    #   options[:associate_tag] = 'gruupie2017-20'
    # end

    # # Search Amazon US
    # # res = Amazon::Ecs.item_lookup(params[:id], {:response_group => 'Large', id_type: 'upc', search_index: 'All'})
    # # item = res.get_element("Item").to_s
    # # @item = Crack::XML.parse(item).to_json    
    # @data = File.read("#{Rails.root}/public/data.json")
    # render json: @data

    require 'time'
    require 'uri'
    require 'openssl'
    require 'base64'
    require 'open-uri'
    
    # Your Access Key ID, as taken from the Your Account page
    access_key_id = "AKIAJUCJ6YE2NQVJIAAA"
    
    # Your Secret Key corresponding to the above ID, as taken from the Your Account page
    secret_key = "isnH2VpU4RypQSjLeSHDDe202BAioDEyYV7KmBxh"
    
    # The region you are interested in
    endpoint = "webservices.amazon.com"
    
    request_uri = "/onca/xml"
    productId = params[:id]
    
    params = {
      "Service" => "AWSECommerceService",
      "Operation" => "ItemLookup",
      "AWSAccessKeyId" => "AKIAJUCJ6YE2NQVJIAAA",
      "AssociateTag" => "gruupie2017-20",
      "ItemId" => productId,
      "SearchIndex" => "All",
      "IdType" => "UPC",
      "ResponseGroup" => "Images,ItemAttributes"
    }
    
    # Set current timestamp if not set
    params["Timestamp"] = Time.now.gmtime.iso8601 if !params.key?("Timestamp")
    
    # Generate the canonical query
    canonical_query_string = params.sort.collect do |key, value|
      [URI.escape(key.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")), URI.escape(value.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))].join('=')
    end.join('&')
    
    # Generate the string to be signed
    string_to_sign = "GET\n" + endpoint + "\n" + request_uri + "\n#{canonical_query_string}"
    
    # Generate the signature required by the Product Advertising API
    signature = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), secret_key, string_to_sign)).strip()
    
    # Generate the signed URL
    data = "http://" + endpoint + "" + request_uri + "?#{canonical_query_string}&Signature=#{URI.escape(signature, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))}"
    d = Nokogiri::XML(open(data)).to_s
    @res = Hash.from_xml(d).to_json
    #@response = res.get_element("Item")
    render json: @res
  end
end
