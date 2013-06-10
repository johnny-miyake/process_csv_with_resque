class Client < ActiveRecord::Base
  attr_accessible :client_name, :roman_name, :tel
end
