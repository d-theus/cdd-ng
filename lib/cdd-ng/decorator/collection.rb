module Decorator
  class Collection
    include ActionView::Helpers
    include Rails.application.routes.url_helpers

    def initialize(obj, ctx)
      @object = obj
      @collection =
        if obj.any?
          dec = self.class.const_get "#{obj.first.class}Decorator"
          obj.map { |item| dec.new(item, ctx) }
        else
          []
        end
      @context = ctx
    end

    def method_missing(meth, *args, &blk)
      o = if Array.instance_methods.include?(meth)
            @collection
          else
            @object
          end
      o.send(meth, *args, &blk)
    end

    def respond_to_missing?(meth, include_private = false)
      @object.respond_to? meth
    end
  end
end
