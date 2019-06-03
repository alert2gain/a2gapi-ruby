require 'time'
require 'rest-client'
require 'json'

class Sensor
    def initialize(name, temperature, humidity, lastupdate)
        @name = name
        @temperature = temperature
        @humidity = humidity
        @lastupdate = lastupdate
    end

    def setTemperature=(value)
        @temperature = value
    end

    def setHumidity=(value)
        @humidity = value
    end

    def setLastupdate=(value)
        @lastupdate = value
    end

    def getTemperature
        @temperature
    end

    def getName
        @name
    end

    def getHumidity
        @humidity
    end

    def getLastUpdate
        @lastupdate
    end
end

def sendData(sensor)
    # We create a data object that will represent the information of the sensor
    data = {
        "station": sensor.getName,
        "data": {
            "temperature": sensor.getTemperature,
            "humidity": sensor.getHumidity,
            "lastupdate": sensor.getLastUpdate
        }
    }

    # We set a variable to contain the URL to A2G API
    url = 'https://listen.a2g.io/v1/testing/inputstream'

    # We create the payload, that will include our Input Stream Key and the data object serialized as a JSON
    payload = {
        "IKEY": "[YOUR_INPUTSTREAM_KEY]",
        "Data": data.to_json
    }   

    # We run the POST request, handling in case a code different from 200 is received
    begin        
        response = RestClient::Request.execute(url: url, payload: payload.to_json, method: :post, headers: { 'x-api-key' => '[YOUR_API_KEY]', 'Content-Type': 'application/json'})        
        if response.code == 200
            puts 'Data successfully sent: ', response.body
        elsif
            puts 'The API could not process the request:', response.body
        end        
    rescue RestClient::ExceptionWithResponse => e
        puts 'An error ocurred while connecting with the API: ' + e.message, e.response    
    end    
end


def runSensors()
    sensors = []
    station1 = Sensor.new("Station 1", 0, 0, Time.now.utc.iso8601)
    sensors.push(station1)

    while(true)
        for sensor in sensors
            sensor.setTemperature = rand(10..42)
            sensor.setHumidity = rand(0..100)
            sensor.setLastupdate = Time.now.utc.iso8601

            sendData(sensor)
            sleep(5)
        end
    end
end

runSensors()