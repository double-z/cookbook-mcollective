maintainer       "Zachary Stevens"
maintainer_email "zts@cryptocracy.com"
license          "All rights reserved"
description      "Installs/Configures mcollective"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.4"

supports 'ubuntu'

depends "chef_handler", ">= 1.0.4"
depends "apt"

recipe "mcollective::server", "Installs and configures mcollective server"
recipe "mcollective::client", "Installs and configures mcollective client"
recipe "mcollective::default", "Installs and configures mcollective client and server"

