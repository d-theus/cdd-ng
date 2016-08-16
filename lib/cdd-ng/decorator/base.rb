module Decorator
  class Base
    include ActionView::Helpers
    include Rails.application.routes.url_helpers

    def initialize(obj, ctx)
      @object = obj
      @context = ctx
    end

    def method_missing(meth, *args, &blk)
      @object.send(meth, *args, &blk)
    end

    def respond_to_missing?(meth, include_private = false)
      @object.respond_to? meth
    end
  end
end
