module Cluster
  module Discovery
    class EmptyTagsError < RuntimeError
      def message
        'Tags cannot be empty'
      end
    end
  end
end
