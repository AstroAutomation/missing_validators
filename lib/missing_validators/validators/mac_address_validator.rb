# Allows to check if the value of a specific attribute is a valid MAC address.
#
# @example Validate that the device MAC address is valid.
#   class Device << ActiveRecord::Base
#     attr_accessor :mac
#     validates :mac, mac_address: true
#   end
class MacAddressValidator < ActiveModel::EachValidator
  # Checks if an attribute value is a valid MAC address.
  #
  # @param [Object] record object to validate
  # @param [String] attribute name of the object attribute to validate
  # @param [Object] value attribute value
  def validate_each(record, attribute, value)
    allow_blank = options[:allow_blank] || false
    return if allow_blank && value.blank?

    unless self.class.valid?(value, options)
      record.errors[attribute] << (options[:message] || I18n.t('errors.messages.mac_address'))
    end
  end

  def self.validate_format(mac_address)
    !!(mac_address =~ /^([A-Fa-f0-9]{2}[:]){5}[A-Fa-f0-9]{2}?$/i) ||    # 08:00:2b:01:02:03
      !!(mac_address =~ /^([A-Fa-f0-9]{2}[-]){5}[A-Fa-f0-9]{2}?$/i) ||  # 08-00-2b-01-02-03
      !!(mac_address =~ /^([A-Fa-f0-9]{6}):[A-Fa-f0-9]{6}?$/i) ||       # 08002b:010203
      !!(mac_address =~ /^([A-Fa-f0-9]{6})-[A-Fa-f0-9]{6}?$/i) ||       # 08002b-010203
      !!(mac_address =~ /^([A-Fa-f0-9]{4}[\.]){2}[A-Fa-f0-9]{4}?$/i) || # 0800.2b01.0203
      !!(mac_address =~ /^[A-Fa-f0-9]{12}?$/i)                          # 08002b010203
  end

  private

  def self.valid?(mac_address, options)
    validate_format(mac_address)
  end

end