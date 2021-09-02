from flask import Flask, render_template
import os

app = Flask(__name__)


@app.route('/')
def home():

  return render_template('index.html')

'''
gcloud builds submit --tag gcr.io/PROJECT-ID/test-run

to test locally 

sudo docker build . --tag gcr.io/PROJECT-ID/test-run

PORT=8080 && sudo docker run -p 9090:${PORT} -e PORT=${PORT} gcr.io/PROJECT-ID/test-run
'''

if __name__ == "__main__":
    app.run(debug=True,host='0.0.0.0',port=int(os.environ.get('PORT', 8080)))
