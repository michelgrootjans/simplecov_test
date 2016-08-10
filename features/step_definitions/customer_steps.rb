Given(/^a customer "([^"]*)"$/) do |customer_name|
  Customer.create!(name: customer_name)
end


Then(/^the customer "([^"]*)" should exist$/) do |customer_name|
  expect(Customer.for_cucumber(name: customer_name)).not_to be_nil
end