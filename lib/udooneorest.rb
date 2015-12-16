require 'sinatra/base'

require_relative 'udooneorest/validators'
require_relative 'udooneorest/export'
require_relative 'udooneorest/value'
require_relative 'udooneorest/direction'
require_relative 'udooneorest/gyroscope'
require_relative 'udooneorest/accelerometer'
require_relative 'udooneorest/magnetometer'
require_relative 'udooneorest/barometer'
require_relative 'udooneorest/temperature'


GPIOS             =  %w(178 179 104 143 142 141 140 149 105 148 146 147 100 102 NA NA 106 107 180 181 172 173 182 124 25 22 14 15 16 17 18 19 20 21 203 202 177 176 175 174 119 124 127 116 7 6 5 4)
HELP_URL          = 'http://github.com/marksull/udooneorest'
BASE_PATH         = '/sys/class/gpio/'
VALUE_LOW         = '0'
VALUE_HIGH        = '1'
DIRECTION_IN      = 'in'
DIRECTION_OUT     = 'out'
FAILED_MESSAGE    = 'failed'
SUCCESS_MESSAGE   = 'success'

module UdooNeoRest

  class Base < Sinatra::Application

    # Have Sinatra listen on all interfaces
    set :bind, '0.0.0.0'

    #############################################################################
    # Message constructor
    #
    # status       : the status of the operation
    # message      : the message to be displayed
    #
    def self.status_message(status, message)
      "{'status' : '#{status}', 'message' : '#{message}'}"
    end

    #############################################################################
    # Construct the status message when no errors occurred
    #
    # message      : the message to be displayed
    #
    def self.status_ok(message = '')
      status_message(SUCCESS_MESSAGE, message)
    end

    #############################################################################
    # Construct the status message when an error occurred
    #
    # message      : the message to be displayed
    #
    def self.status_error(message)
      status_message(FAILED_MESSAGE, message)
    end

    #############################################################################
    # Echo a value to a file
    #
    # value      : the value to echo to the file
    # file       : the file to echo the value too
    #
    def self.echo(value, file)
      begin
        File.write(file, value)
      rescue Errno::EINVAL
        # close always error on the udoo gpios - cause unknown
      rescue Exception => e
        return e.message
      end
      ''
    end

    #############################################################################
    # Cat a file
    #
    # file       : the file to cat
    #
    def self.cat(file)
      File.read(file).chomp
    end

    #############################################################################
    # Calculate the Barometer/Temp value from raw and scale values
    #
    def self.sensor_calc(sensor)
      raw   = UdooNeoRest::Base.cat(UdooNeoRest::Base.sensor_path(sensor) + '_raw').to_i
      scale = UdooNeoRest::Base.cat(UdooNeoRest::Base.sensor_path(sensor) + '_scale').to_f
      UdooNeoRest::Base.status_ok(raw * scale)
    end

    #############################################################################
    # Build the path to common sensors
    #
    # sensor       : the sensor name
    #
    def self.sensor_path(sensor)
      "/sys/class/i2c-dev/i2c-1/device/1-0060/iio:device0/in_#{sensor}"
    end

    #############################################################################
    # Build the path to common axis sensors
    #
    # sensor       : the sensor name
    #
    def self.axis_path(sensor)
      "/sys/class/misc/Freescale#{sensor}"
    end

    #############################################################################
    # Build the path to common axis sensors to enable/disable
    #
    # sensor       : the sensor name
    #
    def self.axis_path_enable(sensor)
      UdooNeoRest::Base.axis_path(sensor) + '/enable'
    end

    #############################################################################
    # Build the path to common axis sensors to retrieve data
    #
    # sensor       : the sensor name
    #
    def self.axis_path_data(sensor)
      UdooNeoRest::Base.axis_path(sensor) + '/data'
    end

    #############################################################################
    # Cat a file contents and return the status
    #
    # file       : the file to cat
    #
    def self.cat_and_status(file)
      UdooNeoRest::Base.status_ok(UdooNeoRest::Base.cat file)
    end

    #############################################################################
    # Enable or disable one of the axis sensors
    #
    # Value       : 0 disables the axis, 1 enables it
    #
    def self.change_state(file, value)
      result        = UdooNeoRest::Base.echo value, file
      result.empty? ? UdooNeoRest::Base.status_ok : UdooNeoRest::Base.status_error(result)
    end

    #############################################################################
    # Import all the Sinatra routes
    #
    use UdooNeoRest::Value
    use UdooNeoRest::Accelerometer
    use UdooNeoRest::Barometer
    use UdooNeoRest::Gyroscope
    use UdooNeoRest::Magnetometer
    use UdooNeoRest::Temperature
    use UdooNeoRest::Export
    use UdooNeoRest::Direction

    #############################################################################
    # Show the help documentation
    #
    get '/help' do
      UdooNeoRest::Base.status_ok("Help documentation can be found here: #{HELP_URL}")
    end

    #############################################################################
    # Default route to catch incorrect API calls
    #
    not_found do
      UdooNeoRest::Base.status_error("This API call is not know. Please refer to the documentation #{HELP_URL}")
    end
  end

end

UdooNeoRest::Base.run!





