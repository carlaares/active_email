module ActiveEmail
  module FormHelpers
    # TODO: improve these forms. They should be loaded dynamically
    def mandrill_configuration(object_name, options = {})
      content_tag(:input, nil, options.merge({ id: 'api_key', name: object_name.to_s+'[metadata][api_key]', type: 'text', placeholder: 'Mandrill Api Key' }))
    end
  end
end