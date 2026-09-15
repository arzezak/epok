module Epok
  class Collection
    include Enumerable

    def initialize(&fetch)
      @fetch = fetch
    end

    def each(&block)
      objects.each(&block)
    end

    private

    def objects
      @objects ||= @fetch.call.map { |item| Object.new(item["id"]) }
    end
  end
end
