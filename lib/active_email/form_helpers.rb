module ActiveEmail
  module FormHelpers
    # TODO: improve these forms. They should be loaded dynamically
    def mandrill_configuration(object_name, options = {})
      # TODO: agregar popover $('#example').popover(options) para explicar de donde sacar el api_key
      content_tag(:input, nil, options.merge({ id: 'api_key', name: object_name.to_s+'[metadata][api_key]', type: 'text', placeholder: 'Mandrill Api Key' }))
    end

    def action_mailer_configuration(object_name, options = {})
      content_tag(:input, nil, options.merge({ id: 'username', name: object_name.to_s+'[metadata][username]', type: 'text', placeholder: 'Gmail username' })) + 
      content_tag(:input, nil, options.merge({ id: 'password', name: object_name.to_s+'[metadata][password]', type: 'password', placeholder: 'Gmail password' })) +
      content_tag(:input, nil, options.merge({ id: 'account_type', name: object_name.to_s+'[metadata][account_type]', type: 'hidden', value: 'gmail' }))
    end
  end
end