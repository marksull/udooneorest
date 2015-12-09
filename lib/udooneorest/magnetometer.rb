module UdooNeoRest

  class Magnetometer < Sinatra::Application

    #############################################################################
    # Routes
    #
    put '/magnetometer/enable' do
      enable '1'
    end

    put '/magnetometer/disable' do
      enable '0'
    end

    get '/magnetometer/value' do
      data
    end

    get '/lazyrest/magnetometer/enable' do
      enable '1'
    end

    get '/lazyrest/magnetometer/disable' do
      enable '0'
    end

    get '/lazyrest/magnetometer/value' do
      data
    end

    #############################################################################
    # Enable/Disable the magnetometer
    #
    # value         : 0 = Disable, 1 = Enable
    #
    def enable(value)
      UdooNeoRest::Base.change_state UdooNeoRest::Base.axis_path_enable('Magnetometer'), value
    end

    #############################################################################
    # Get the value for the magnetometer
    #
    def data
      UdooNeoRest::Base.cat_and_status UdooNeoRest::Base.axis_path_data('Magnetometer')
    end

  end

end
