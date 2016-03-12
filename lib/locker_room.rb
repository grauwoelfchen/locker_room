require 'locker_room/engine'

require 'locker_room/concerns/scoped_to'
require 'locker_room/models/team'
require 'locker_room/models/user'
require 'locker_room/models/mateship'
require 'locker_room/models/type'

require 'locker_room/testing/helpers'

module LockerRoom
  class << self
    attr_accessor :app_name

    def configure
      yield self if block_given?
    end
  end
end
