class ApplicationController < ActionController::API
  serialization_scope nil # disable ams current_user call
  include Secured
end
