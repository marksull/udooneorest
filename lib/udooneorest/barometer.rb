module UdooNeoRest

  class Barometer  < Sinatra::Application

    #############################################################################
    # Routes
    #
    get '/barometer/value' do
      UdooNeoRest::Base.sensor_calc 'pressure'
    end

    get '/lazyrest/barometer/value' do
      UdooNeoRest::Base.sensor_calc 'pressure'
    end

  end

end
