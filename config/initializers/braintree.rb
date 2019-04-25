Braintree::Configuration.environment = :sandbox
Braintree::Configuration.logger = Logger.new('log/braintree.log')
Braintree::Configuration.merchant_id = Rails.application.secrets[:braintree][:merchant_id]
Braintree::Configuration.public_key = Rails.application.secrets[:braintree][:public_key]
Braintree::Configuration.private_key = Rails.application.secrets[:braintree][:private_key]
