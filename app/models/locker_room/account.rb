module LockerRoom
  class Account < ActiveRecord::Base
    include Concerns::Models::Account
  end
end
