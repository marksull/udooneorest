module UdooNeoRest

  class Direction < Sinatra::Application

    #############################################################################
    # Routes
    #
    put '/gpio/:gpio/direction/:direction' do
      direction_set_gpio params[:gpio], params[:direction]
    end

    put '/pin/:pin/direction/:direction' do
      direction_set_pin params[:pin], params[:direction]
    end

    get '/gpio/:gpio/direction' do
      direction_get_gpio params[:gpio]
    end

    get '/pin/:pin/direction' do
      direction_get_pin params[:pin]
    end

    get '/lazyrest/gpio/:gpio/direction/:direction' do
      direction_set_gpio params[:gpio], params[:direction]
    end

    get '/lazyrest/pin/:pin/direction/:direction' do
      direction_set_pin params[:pin], params[:direction]
    end

    get '/lazyrest/gpio/:gpio/direction' do
      direction_get_gpio params[:gpio]
    end

    get '/lazyrest/pin/:pin/direction' do
      direction_get_pin params[:pin]
    end

    #############################################################################
    # Get the value for a specific pin
    #
    # pin         : the pin to be set (will be translated to GPIO)
    #
    def direction_get_pin(pin)

      # Validate the pin
      pin_ = ValidatePin.new pin
      return pin_.error_message unless pin_.valid?

      # Get the value after translating to gpio
      direction_get_gpio pin_.to_gpio
    end

    #############################################################################
    # Get the direction for a specific gpio
    #
    # gpio         : the gpio to get
    #
    def direction_get_gpio(gpio)

      # validate the gpio
      gpio_          = ValidateGpio.new gpio
      return gpio_.error_message unless gpio_.valid?

      # get the direction
      UdooNeoRest::Base.status_ok(UdooNeoRest::Base.cat "#{BASE_PATH}gpio#{gpio}/direction")
    end

    #############################################################################
    # Set a specific pin to the nominated direction
    #
    # pin         : the pin to be set (will be translated to GPIO)
    # direction   : the direction to be used
    #
    def direction_set_pin(pin, direction)

      # valide the pin
      pin_ = ValidatePin.new pin
      return pin_.error_message unless pin_.valid?

      # Set the direction after translating to gpio
      direction_set_gpio pin_.to_gpio, direction
    end

    #############################################################################
    # Set a specific gpio to the nominated direction
    #
    # gpio        : the gpio to be set
    # direction   : the direction to be used
    #
    def direction_set_gpio(gpio, direction)

      # validate the gpio
      gpio_          = ValidateGpio.new gpio
      return gpio_.error_message unless gpio_.valid?

      # validate the direction
      direction_     = ValidateDirection.new direction
      return direction_.error_message unless direction_.valid?

      # Send the command and if no error return an OK result else return the error
      result         = UdooNeoRest::Base.echo direction, "#{BASE_PATH}gpio#{gpio}/direction"
      result.empty? ? UdooNeoRest::Base.status_ok : UdooNeoRest::Base.status_error(result)
    end

  end

end