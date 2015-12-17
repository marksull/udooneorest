module UdooNeoRest

  class Value  < Sinatra::Application

    #############################################################################
    # Routes
    #
    put '/gpio/:gpio/value/:value' do
      value_set_gpio params[:gpio], params[:value]
    end

    put '/pin/:pin/value/:value' do
      value_set_pin params[:pin], params[:value]
    end

    get '/gpio/:gpio/value' do
      value_get_gpio params[:gpio]
    end

    get '/pin/:pin/value' do
      value_get_pin params[:pin]
    end

    get '/lazyrest/gpio/:gpio/value/:value' do
      value_set_gpio params[:gpio], params[:value]
    end

    get '/lazyrest/pin/:pin/value/:value' do
      value_set_pin params[:pin], params[:value]
    end

    get '/lazyrest/gpio/:gpio/value' do
      value_get_gpio params[:gpio]
    end

    get '/lazyrest/pin/:pin/value' do
      value_get_pin params[:pin]
    end

    #############################################################################
    # Get the value for a specific pin
    #
    # pin         : the pin to be set (will be translated to GPIO)
    #
    def value_get_pin(pin)

      # Validate the pin
      pin_ = ValidatePin.new pin
      return pin_.error_message unless pin_.valid?

      # Get the value after translating to gpio
      value_get_gpio pin_.to_gpio
    end

    #############################################################################
    # Get the value for a specific gpio
    #
    # gpio         : the gpio to get
    #
    def value_get_gpio(gpio)

      # Validate the gpio
      gpio_ = ValidateGpio.new gpio
      return gpio_.error_message unless gpio_.valid?

      # Get the value
      UdooNeoRest::Base.cat_and_status "#{BASE_PATH}gpio#{gpio}/value"
    end

    #############################################################################
    # Set a specific pin to the nominated value
    #
    # pin         : the pin to be set (will be translated to GPIO)
    # value       : the value to be used
    #
    def value_set_pin(pin, value)

      # Validate the pin
      pin_ = ValidatePin.new pin
      return pin_.error_message unless pin_.valid?

      # Set the value after translating to gpio
      value_set_gpio pin_.to_gpio, value
    end

    #############################################################################
    # Set a specific gpio to the nominated value
    #
    # gpio        : the gpio to be set
    # value       : the value to be used
    #
    def value_set_gpio(gpio, value)

      # Validate the gpio
      gpio_          = ValidateGpio.new gpio
      return gpio_.error_message unless gpio_.valid?

      # Validate the value
      value_         = ValidateValue.new value
      return value_.error_message unless value_.valid?

      # Send the command and if no error return an OK result
      result         = UdooNeoRest::Base.echo value, "#{BASE_PATH}gpio#{gpio}/value"
      return UdooNeoRest::Base.status_ok if result.empty?

      # Check for a common error and provide some advice
      if result =~ /not permitted/
        return UdooNeoRest::Base.status_error('Operation not permitted error occurred. Has the gpio been set to output mode?')
      end

      # Otherwise just return the error
      UdooNeoRest::Base.status_error result
    end

  end

end
