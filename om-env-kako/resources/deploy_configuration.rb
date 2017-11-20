require 'yaml'
require 'pp'

provides :deploy_configuration
resource_name :deploy_configuration

# Define the file to load the source document from (YAML)
property :source, String, name_attribute: true
# Define any 'additional' data to be merged into the source document.
property :additions, Hash, required: true
# Define the file to write the destination document to (YAML).
property :destination, String, required: true

# A few additional helpers are required to load the source file, deep merge
# the data, and write the destination file.
action_class do
  include Chef::Mixin::DeepMerge

  # Loads the specified YAML document.
  def load_yaml(src)
    ::YAML.load_file(src)
  end

  # Opens the given destination file for writing, and writes out the provided
  # Ruby structure as YAML.
  def write_yaml(destination, struct)
    ::File.open(destination, 'w') { |f| f.write(struct.to_yaml) }
  end
end

action :run do
  # Load the source document.
  struct = load_yaml(source)

  # Merge with 'additional' data to create the configuration.
  deep_merge!(additions.to_hash, struct)

  # Write out the destination document.
  write_yaml(destination, struct)
end
