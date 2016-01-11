module Cluster
  module Discovery
    class EmptyTagsError < RuntimeError
      def message
        'Tags cannot be empty'
      end
    end

    class MalformedTagsError < RuntimeError
      def message
        'Missing or invald keys'
      end
    end

    class EmptyASGError < RuntimeError
      def message
        'Must be a vaild AutoScaling Group'
      end
    end
  end
end
