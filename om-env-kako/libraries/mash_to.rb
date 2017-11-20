# http://stackoverflow.com/questions/14738364/chef-11-any-way-to-turn-attributes-into-a-ruby-hash
class Chef
  class Node
    class ImmutableMash
      def to_hash
        h = {}
        self.each do |k, v|
          if v.respond_to?('to_hash')
            h[k] = v.to_hash
          else
            h[k] = v
          end
        end
        h
      end
    end
  end
end
