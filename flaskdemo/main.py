from flask import Flask, render_template, request
from app import api


app = Flask(__name__)
# don't cache css so we can see updates
app.config['SEND_FILE_MAX_AGE_DEFAULT'] = 0


@app.route("/")
def home():
    return render_template("home.html")


@app.route("/api/", methods=['GET', 'POST'])
def api():
    key0 = request.form.get('key0')
    where = request.form.get('where')
    end0 = request.form.get('end0')
    if key0 is not None:
        apihdr = {'x-api-key': key0}
        apiurl = 'https://api.meteostat.net/v2/stations/daily?station={0}&start={1}&end={2}'
    else:
        apihdr = ''
        apiurl = ''
    return render_template("api.html", apihdr=apihdr, apiurl=apiurl)


# @app.route('/api/', methods=['POST'])
# def api_post():
#     text = request.form['text']
#     processed_text = text.upper()
#     return processed_text


@app.route("/crawler/")
def crawler():
    return render_template("crawler.html")


@app.route("/puzzle/")
def puzzle():
    return render_template("puzzle.html")


@app.route("/ml/")
def ml():
    return render_template("ml.html")


@app.route('/<name>')
def hello_name(name):
    return "Hello {}!".format(name)


if __name__ == "__main__":
    app.run(debug=True)
    # host='localhost',
# app.run(debug=True)
# https://blog.miguelgrinberg.com/post/the-flask-mega-tutorial-part-xi-facelift
