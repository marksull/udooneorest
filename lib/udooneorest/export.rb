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

    post '/gpio/:gpio/unexport' do
      export_gpio params[:gpio], :unexport
    end

    post '/pin/:pin/unexport' do
      export_pin params[:pin], :unexport
    end

    get '/lazyrest/gpio/:gpio/unexport' do
      export_gpio params[:gpio], :unexport
    end

    get '/lazyrest/pin/:pin/unexport' do
      export_pin params[:pin], :unexport
    end

    #############################################################################
    # Export using the pin
    #
    # pin     : the pin to be exported
    #
    def export_pin(pin, mode = :export)

      # Validate the pin
      pin_ = ValidatePin.new pin
      return pin_.error_message unless pin_.valid?

      # Export the value after translating to gpio
      export_gpio pin_.to_gpio, mode
    end

    #############################################################################
    # Export using the gpio
    #
    # gpio     : the gpio to be exported
    #
    def export_gpio(gpio, mode = :export)

      # lets make sure the gpio is good
      gpio_          = ValidateGpio.new gpio
      return gpio_.error_message unless gpio_.valid?

      # send the command
      result         = UdooNeoRest::Base.echo gpio, "#{BASE_PATH}#{'un' if mode == :unexport}export"

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