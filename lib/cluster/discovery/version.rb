module Cluster
  module Discovery
    PATH = File.expand_path('../../../../VERSION', __FILE__)
    VERSION = IO.read(PATH) rescue '0.0.1'
  end
end
