class Customer < ActiveRecord::Base
  def self.for_cucumber(options)
    Customer.find_by(options)
  end

  def not_tested
    'not tested'
  end

  def for_rspec
    'success'
  end
end
