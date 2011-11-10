module Admin
  class ResourceError < ::Stache::View

    # TODO: i18n?
    def resource_name
      resource.class.to_s.titleize
    end

    def number_of_errors
      pluralize( resource.errors.size, "error" )
    end

    def errors
      resource.errors.full_messages
    end

  end
end