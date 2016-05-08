class KeyStore < ActiveRecord::Base

  def [](key)
    to_return = ::KeyStore.where(key: key).first
    if !to_return.nil?
      to_return.value
    end
  end

  def []=(key, value)
    to_save = ::KeyStore.where(key: key).first_or_initialize
    to_save.value = value
    to_save.save
    true
  end

  def del(key)
    to_return = ::KeyStore.where(key: key).first
    if !to_return.nil?
      to_return.destroy
      true
    else
      false
    end
  end


end
