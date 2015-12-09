module UdooNeoRest

  class Temperature  < Sinatra::Application

    #############################################################################
    # Routes
    #
    get '/temperature/value' do
      UdooNeoRest::Base.sensor_calc 'temp'
    end

    get '/lazyrest/temperature/value' do
      UdooNeoRest::Base.sensor_calc 'temp'
    end

  end

end
