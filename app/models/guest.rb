class Guest
  include UserBehavior
  attr_accessor :uuid, :id

  def initialize(*args)
    if args && args[0].is_a?(Hash)
      args[0].each_pair do |key, value|
        self.instance_variable_set("@#{key}", value)
      end
    else
      self.uuid = SecureRandom.uuid
    end
    self.id = Guest.id
  end

  def self.id
    "Guest"
  end

  def to_param
    "#{self.id}"
  end

  def translations
    Translation.where(guest_uuid: self.uuid)
  end

  def last_used_lang
  end
end