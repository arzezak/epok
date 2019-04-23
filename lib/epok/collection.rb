module Epok
  class Collection
    include Enumerable

    attr_reader :data

    def initialize(data, id = "id")
      @data = collection(data, id)
    end

    def each(&block)
      data.each(&block)
    end

    private

    def collection(data, id)
      data.map do |item|
        Object.new(item[id])
      end
    end
  end
end
