module UdooNeoRest

  class Export  < Sinatra::Application

    #############################################################################
    # Routes
    #
    post '/gpio/:gpio/export' do
      export_gpio params[:gpio]
    end

    post '/pin/:pin/export' do
      export_pin params[:pin]
    end

    get '/lazyrest/gpio/:gpio/export' do
      export_gpio params[:gpio]
    end

    get '/lazyrest/pin/:pin/export' do
      export_pin params[:pin]
    end

    #############################################################################
    # Export using the pin
    #
    # pin     : the pin to be exported
    #
    def export_pin(pin)

      # Validate the pin
      pin_ = ValidatePin.new pin
      return pin_.error_message unless pin_.valid?

      # Export the value after translating to gpio
      export_gpio pin_.to_gpio
    end

    #############################################################################
    # Export using the gpio
    #
    # gpio     : the gpio to be exported
    #
    def export_gpio(gpio)

      # lets make sure the gpio is good
      gpio_          = ValidateGpio.new gpio
      return gpio_.error_message unless gpio_.valid?

      # send the command
      result         = UdooNeoRest::Base.echo gpio, "#{BASE_PATH}export"

      # return ok if all is well
      return UdooNeoRest::Base.status_ok if result.empty?

      # provide some constructive feedback on the root cause of this specific error
      if result =~ /resource busy/
        return UdooNeoRest::Base.status_error('Resource Busy error occurred. Maybe the gpio has already been exported. It only needs to be exported once.')
      end

      # otherwise just return the error
      UdooNeoRest::Base.status_error(result)
    end

  end

end