#!/bin/sh -e

# Install ChefDK.
if [ ! -f /var/tmp/chefdk_2.3.4-1_amd64.deb ]; then
    curl -L -s https://packages.chef.io/files/stable/chefdk/2.3.4/ubuntu/16.04/chefdk_2.3.4-1_amd64.deb -o /var/tmp/chefdk_2.3.4-1_amd64.deb
    dpkg -i /var/tmp/chefdk_2.3.4-1_amd64.deb
fi

# Create the Chef zero repository.
cd /var/tmp/provisioning
berks vendor
mkdir -p /var/tmp/chef

if [ -d /var/tmp/chef/cookbooks ]; then
    rm -rf /var/tmp/chef/cookbooks
fi
mv ./berks-cookbooks /var/tmp/chef/cookbooks
cd /var/tmp/chef/cookbooks

# Enable password authentication for ssh and kick off Chef.
cat > /var/tmp/chef/chef.json <<-ENDOFJSON
{
  "om-env-kako": {
    "aws": {
      "access_key_id": "X",
      "secret_access_key": "Y"
    }
  }
}
ENDOFJSON


chmod 600 /var/tmp/chef/chef.json
chef-client -z -o 'om-env-kako::default' -j /var/tmp/chef/chef.json
