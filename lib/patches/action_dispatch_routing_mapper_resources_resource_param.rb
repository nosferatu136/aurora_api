# From https://stackoverflow.com/questions/6592038/change-the-name-of-the-id-parameter-in-routing-resources-for-rails3/13427336#13427336
#
# Adding feature already present in Rails 4
#
module ActionDispatch::Routing::Mapper::Resources
  RESOURCE_OPTIONS = [:as, :controller, :path, :only, :except, :param]

  class Resource
    # overridden:

    def member_scope
      "#{path}/:#{param}"
    end

    def nested_scope
      "#{path}/:#{nested_param}"
    end

    # backported:

    def param
      @param ||= (@options[:param] || :id).to_sym
    end

    def nested_param
      :"#{singular}_#{param}"
    end
  end
end
