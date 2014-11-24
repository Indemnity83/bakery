name             'php-mods'
maintainer       'Kyle Klaus'
maintainer_email 'indemnity83@gmail.com'
license          'Apache 2.0'
description      'Installs and enables PHP modules'

recipe 'mcrypt', 'installs and enabled php5-mcrypt'

%w(ubuntu).each do |os|
  supports os
end
