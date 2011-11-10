require 'fleakr'

module Behaviors
  module Photo
    extend ActiveSupport::Concern

    included do |base|
      base::SIZES.each do |size|
        # Allows a single size to reference its other sizes.
        define_method size do
          base.send(size).where(:flickr_id => flickr_id).first
        end
      end
    end

    module ClassMethods
      def fetch( sku_as_tag )
        flickr_user.search(:tags => sku_as_tag)
      end

      def flickr_user
        @@flickr_user ||= Fleakr.user( ENV['FLICKR_USERNAME'] )
p @@flickr_user
@@flickr_user
      end
    end

  end
end