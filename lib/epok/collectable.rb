require "forwardable"

module Epok
  module Collectable
    def self.included(base)
      base.class_eval do
        extend Forwardable

        def_delegators :results, :entries, :first
      end
    end

    def collection(object)
      Collection.new object
    end
  end
end
