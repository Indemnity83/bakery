name             'bakery'
maintainer       'Kyle Klaus'
maintainer_email 'indemnity83@gmail.com'
license          'Apache 2.0'
description      'Sets up Bakery sites and databases'

recipe 'configure', 'Configures Bakery'

depends 'database'

%w(ubuntu).each do |os|
  supports os
end
