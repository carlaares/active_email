require 'active_support/core_ext'
require 'active_email/transactional/requires_parameter'
require 'active_email/transactional'
require 'active_email/form_helpers'

ActionView::Base.send(:include, ActiveEmail::FormHelpers)
