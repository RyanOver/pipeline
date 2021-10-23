from flask import Flask, render_template
import json
import requests
import os

app = Flask(__name__)


@app.route('/')
def home():

  OPENWEATHER_API_KEY = os.environ.get('OPENWEATHER_API_KEY')

  weather_url = f'https://api.openweathermap.org/data/2.5/weather?q=Montreal&appid={OPENWEATHER_API_KEY}&units=metric'
  weather = requests.get(weather_url)
  w = json.dumps(weather.json())
  x = json.loads(w)
  f = x['weather']
  temp = x['main']['temp']
  condition = f[0]['description']

  data = [
    {
    'temp': round(temp),
    'condition': condition
    }
  ]

  return render_template('index.html', data=data)

'''
gcloud builds submit --tag gcr.io/PROJECT-ID/test-run

to test locally 

sudo docker build . --tag gcr.io/PROJECT-ID/test-run

PORT=8080 && sudo docker run -p 9090:${PORT} -e PORT=${PORT} gcr.io/PROJECT-ID/test-run
'''

if __name__ == "__main__":
    app.run(debug=True,host='0.0.0.0',port=int(os.environ.get('PORT', 8080)))
