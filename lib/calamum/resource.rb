# This class represents a single resource.
# It contains attributes from parsed definition.
# So anywhere in view template we can use this object.
class Calamum::Resource
  attr_accessor :uri, :action, :headers,
    :auth, :params, :status_codes, :description, :request_body, :request_description, :response_body, :tryit, :example_id

  # Initialize object from attributes.
  #
  # @param attrs [Hash] attributes to set
  def initialize(attrs)
    @uri = attrs['uri']
    @action = attrs['action'].upcase
    @headers = attrs['headers'] || {}
    @auth = !!attrs['authentication']
    @params = attrs['params'] || {}
    @status_codes = attrs['status_codes'] || {}
    @description = attrs['description']
    @example_id = attrs['example_id'] || ''
    @response_body = attrs['response_body']
    @request_body = attrs['request_body']
    @request_description = attrs['request_description'] || {}
    @tryit = attrs['tryit']
  end

  def curl_example(url)
    header_opts = @headers.collect { | key, c | "-H \"#{key}: #{c['value']}\"" } * ' '
    req_body = @request_body.nil? ? '' : "-d '#{@request_body}' "
    "curl -i -k #{header_opts} -X #{@action} #{req_body}#{url}#{@uri.gsub(':id', @example_id)}"
  end
  
  # @override
  # Returns a string representing a label css class.
  #
  # @return [String] css class
  def action_label
    case @action
    when 'GET'
      'label-info'
    when 'POST'
      'label-success'
    when 'PUT'
      'label-warning'
    when 'DELETE'
      'label-important'
    end
  end

  # @override
  # Returns a string representing a resource.
  #
  # @return [String] resource in a form (action: uri)
  def to_s
    "#{action}: #{uri}"
  end

end
