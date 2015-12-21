require "yaml"

config = YAML.load_file "spec/connection.yml"

Beslist::API::Config.personal_key = config['personal_key']
Beslist::Spec.personal_key = Beslist::API::Config.personal_key
Beslist::Spec.client_id = '99999'
Beslist::Spec.shop_id   = '88888'
Beslist::Spec.instance  = Beslist::API::Client.new(:client_id => Beslist::Spec.client_id,
                                                   :shop_id   => Beslist::Spec.shop_id)

Beslist::Spec.date_from = '2015-09-01'
Beslist::Spec.date_to = '2015-09-03'
Beslist::Spec.shop_orders = File.read(File.join('spec', 'fixtures', 'shop_orders.xml'))
Beslist::Spec.shop_orders_invalid_checksum = File.read(File.join('spec', 'fixtures', 'shop_orders_invalid_checksum.xml'))
