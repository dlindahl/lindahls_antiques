module Behaviors
  module EbayAuction

    include EbayApiWrapper

    # TODO: Add verified flag?
    def verify_item!
      # p "Verifying item..."
      response = with_ebay_api { |ebay_api| ebay_api.verify_add_item(:item => to_ebay_item) }

      if response.successful?
        # p "Item ID: #{response.item_id}"
        # p "Fee summary: "

        # TODO: Figure out how to report listing errors back to the user. ListingError? SubmissionError?
        response.fees.select{ |f| !f.fee.zero? }.each do |f|
          # puts "  #{f.name}: #{f.fee.format(:with_currency)}"
        end
      else
        response.errors.full_messages.each { |msg| self.errors.add(:base, msg) }
      end
    end

    def submit_to_ebay!
    end

  private

    def to_ebay_item
      Ebay::Types::Item.new(
        :primary_category =>  Ebay::Types::Category.new(:category_id => 57882), # TODO: Don't hardcode this
        :title =>             self.title,
        :description =>       self.description,
        :location =>          'Sterling, VA',
        :start_price =>       Money.new( self.start_price * 100, 'USD' ),
        :quantity =>          1,
        :listing_duration =>  'Days_7', # TODO: Don't hardcode this
        :country =>           'US',
        :currency =>          'USD',
        :payment_methods =>   [ 'VisaMC' ], # TODO: Don't hardcode this

        # TODO: Don't hardcode this
        :shipping_details => Ebay::Types::ShippingDetails.new({
          :shipping_type => 'Flat',
          :shipping_service_options => [
            Ebay::Types::ShippingServiceOptions.new({
              :shipping_service =>      'UPSGround',
              :shipping_service_cost => Money.new( ((shipping_price || 0) * 100).to_i, 'USD' )
            })
          ]
        }),

        # TODO: Don't hardcode this
        :dispatch_time_max => 5, #days

        # TODO: Don't hardcode this
        # This value needs to be selectable based on the Item's chosen category (the human readable versions differ depending on the category)
        # http://developer.ebay.com/DevZone/XML/docs/WebHelp/wwhelp/wwhimpl/common/html/wwhelp.htm?context=eBay_XML_API&file=DescribingListing-Specifying_an_Items_Condition.html
        :condition_id => 1000,

        # TODO: Don't hardcode this?
        :return_policy => Ebay::Types::ReturnPolicy.new({
          :returns_accepted_option =>       Ebay::Types::ReturnsAcceptedOptionsCode::ReturnsAccepted,
          :returns_within_option =>         Ebay::Types::ReturnsWithinOptionsCode::Days14,
          :shipping_cost_paid_by_option =>  Ebay::Types::ShippingCostPaidByOptionsCode::Buyer
        })

      )
    end

  end
end