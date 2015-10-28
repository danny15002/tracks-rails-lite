require 'uri'
require 'byebug'


class Params
  attr_reader :params
  # use your initialize to merge params from
  # 1. query string
  # 2. post body
  # 3. route params
  #
  # You haven't done routing yet; but assume route params will be
  # passed in as a hash to `Params.new` as below:
  def initialize(req, route_params = {})
    @params = {}
    parse_www_encoded_form(req.query_string) #query params
    unless req.body.nil?
      process_body(req.body)
    end
    @params.merge! route_params
  end

  def [](key)
    val = @params[key.to_s]
    val = @params[key.to_sym] if val.nil?
    val
  end

  # this will be useful if we want to `puts params` in the server log
  def to_s
    @params.to_s
  end

  class AttributeNotFoundError < ArgumentError; end;

  private
  # this should return deeply nested hash
  # argument format
  # user[address][street]=main&user[address][zip]=89436
  # should return
  # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }

  #DRY out
  def process_body(body_hash)
    body_hash = body_hash.split('&')
    body_hash.map! {|a| a.split '='}
    body_hash.each do |key, value|
      key_array = parse_key(key)
      first_key = key_array.shift
      if key_array.length >= 1
        if @params[first_key].nil?
          @params[first_key] = {}
        end
        nested = nest_hash(key_array, value)
        @params[first_key].merge! nested
      else
        @params[first_key] = value
      end
    end
  end

  def parse_www_encoded_form(www_encoded_form)
    return {} if www_encoded_form.nil?
    decoded = URI::decode_www_form(www_encoded_form)
    print "decoded"
    p decoded
    decoded.each do |key, value|
      key_array = parse_key(key)
      first_key = key_array.shift
      if key_array.length >= 1
        if @params[first_key].nil?
          @params[first_key] = {}
        end
        nested = nest_hash(key_array, value)
        @params[first_key].merge! nested
      else
        @params[first_key] = value
      end
    end
  end

  def nest_hash(key_arr, val)
    return {key_arr.first => val} if key_arr.length == 1

    {key_arr.first => nest_hash(key_arr[1..(key_arr.length - 1)], val)}
  end

  # this should return an array
  # user[address][street] should return ['user', 'address', 'street']
  def parse_key(key)
    key.split(/\]\[|\[|\]/)
  end
end
