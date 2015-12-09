module UdooNeoRest

  class Gyroscope < Sinatra::Application

    #############################################################################
    # Routes
    #
    put '/gyroscope/enable' do
      enable '1'
    end

    put '/gyroscope/disable' do
      enable '0'
    end

    get '/gyroscope/value' do
      data
    end

    get '/lazyrest/gyroscope/enable' do
      enable '1'
    end

    get '/lazyrest/gyroscope/disable' do
      enable '0'
    end

    get '/lazyrest/gyroscope/value' do
      data
    end

    #############################################################################
    # Enable/Disable the Gyroscope
    #
    # value         : 0 = Disable, 1 = Enable
    #
    def enable(value)
      UdooNeoRest::Base.change_state UdooNeoRest::Base.axis_path_enable('Gyroscope'), value
    end

    #############################################################################
    # Get the value for the Gyroscope
    #
    def data
      UdooNeoRest::Base.cat_and_status UdooNeoRest::Base.axis_path_data('Gyroscope')
    end

  end

end