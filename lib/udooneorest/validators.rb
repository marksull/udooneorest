module UdooNeoRest

  #############################################################################
  # Base validation class. Override the valid? method
  #
  # value       : the value to be validated
  #
  class Validate

    attr_reader :error_message
    attr_accessor :value

    def initialize(value)
      @value          = value
      @error_message  = nil
      valid?
    end

    def valid?
      raise 'SubclassShouldOverrideValid'
    end

  end

  #############################################################################
  # Validate the Direction parameter
  #
  # value       : the direction value to be validated
  #
  class ValidateDirection < Validate

    def valid?
      if (@value != DIRECTION_IN ) && (@value != DIRECTION_OUT)
        @error_message = UdooNeoRest::Base.status_error("Direction value of '#{@value}' is invalid. Should only be 'in' or 'out'.")
        return false
      end

      @error_message  = nil
      true
    end

  end

  #############################################################################
  # Validate the GPIO parameter
  #
  # value       : the gpio value to be validated
  #
  class ValidateGpio < Validate

    def valid?
      unless GPIOS.include?(@value) && (@value != 'NA')
        @error_message = UdooNeoRest::Base.status_error("GPIO value of '#{@value}' is invalid. Should be one of #{(GPIOS - ['NA']).sort.join(',')}.")
        return false
      end

      @error_message  = nil
      true
    end

  end

  #############################################################################
  # Validate the Value parameter
  #
  # value       : the value to be validated
  #
  class ValidateValue < Validate

    def valid?
      if (@value != VALUE_LOW ) && (@value != VALUE_HIGH)
        @error_message = UdooNeoRest::Base.status_error("Value of '#{@value}' is invalid. Should be one of #{VALUE_LOW} or #{VALUE_HIGH}.")
        return false
      end

      @error_message  = nil
      true
    end

  end

  #############################################################################
  # Validate the Pin parameter
  #
  # value       : the pin value to be validated
  #
  class ValidatePin < Validate

    def initialize(value)
      @value          = value.to_i
      @error_message  = nil
      valid?
    end

    def valid?
      if (@value > 47) || (GPIOS[@value] == 'NA')
        @error_message = UdooNeoRest::Base.status_error("Pin value of #{@value} is invalid. Please refer to UDOO Neo documentation.")
        return false
      end

      @error_message  = nil
      true
    end

    ###########################################################################
    # Convert a PIN reference to a GPIO reference as all the commands use GPIO
    #
    def to_gpio
      return nil unless valid?
      GPIOS[@value]
    end

  end
  
end




