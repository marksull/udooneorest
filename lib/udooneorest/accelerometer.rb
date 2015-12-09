module UdooNeoRest

  class Accelerometer < Sinatra::Application

    #############################################################################
    # Routes
    #
    put '/accelerometer/enable' do
      enable '1'
    end

    put '/accelerometer/disable' do
      enable '0'
    end

    get '/accelerometer/value' do
      data
    end

    get '/lazyrest/accelerometer/enable' do
      enable '1'
    end

    get '/lazyrest/accelerometer/disable' do
      enable '0'
    end

    get '/lazyrest/accelerometer/value' do
      data
    end

    #############################################################################
    # Enable/Disable the Accelerometer
    #
    # value         : 0 = Disable, 1 = Enable
    #
    def enable(value)
      UdooNeoRest::Base.change_state UdooNeoRest::Base.axis_path_enable('Accelerometer'), value
    end

    #############################################################################
    # Get the value for the Accelerometer
    #
    def data
      UdooNeoRest::Base.cat_and_status UdooNeoRest::Base.axis_path_data('Accelerometer')
    end

  end

end