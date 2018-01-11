require 'yaml'
require 'pp'

provides :deploy_configuration
resource_name :deploy_configuration

# Define any 'additional' data to be merged into the source document.
property :additions, Hash, required: true
# Define the file to write the destination document to (YAML).
property :destination, String, name_attribute: true

# A few additional helpers are required to load the source file, deep merge
# the data, and write the destination file.
action_class do 
  # Opens the given destination file for writing, and writes out the provided
  # Ruby structure as YAML.
  def write_yaml(destination, struct)
    ::File.open(destination, 'w') { |f| f.write(struct.to_yaml) }
  end
end

action :run do
  # Write out the destination document.
  write_yaml(destination, additions.to_hash)
end
