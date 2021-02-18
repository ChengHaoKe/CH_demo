from flask import Flask, render_template, request, jsonify
from app import apiclass as apic
from app import crawlerclass as crawl
from os.path import join, dirname, realpath
import pandas as pd

# https://medium.com/@shalandy/deploy-git-subdirectory-to-heroku-ea05e95fce1f
# https://medium.com/@gitaumoses4/deploying-a-flask-application-on-heroku-e509e5c76524
# https://elements.heroku.com/buildpacks/pyronlaboratory/heroku-integrated-firefox-geckodriver


app = Flask(__name__)
# don't cache css so we can see updates
app.config['SEND_FILE_MAX_AGE_DEFAULT'] = 0


@app.route("/")
def home():
    return render_template("home.html")


@app.route("/api/", methods=['GET', 'POST'])
def api():
    key0 = request.form.get('key0')
    where0 = request.form.get('where0')
    start0 = request.form.get('start0')
    end0 = request.form.get('end0')
    plt0 = request.form.get('plt0')

    if (key0 is not None) & (where0 is not None) & (start0 is not None) & (end0 is not None):
        # remove white space
        key0 = key0.strip()
        where0 = where0.strip()
        start0 = start0.strip()
        end0 = end0.strip()

        if key0 and where0 and start0 and end0:
            sb64 = apic.apidemo(key=key0, where=where0, start=start0, end=end0, plt=plt0).getall()
        else:
            image0 = join(dirname(realpath(__file__)), 'static/images/ch_tw_temp.png')
            sb64 = apic.default(image0)
    else:
        image0 = join(dirname(realpath(__file__)), 'static/images/ch_tw_temp.png')
        sb64 = apic.default(image0)
    return render_template("api.html", image0=sb64)


@app.route("/crawler/", methods=['GET', 'POST'])
def crawler():
    # https://stackoverflow.com/questions/52644035/how-to-show-a-pandas-dataframe-into-a-existing-flask-html-table
    if request.method == 'POST':
        df1 = crawl.webcrawler().crawler()
        df2 = df1.to_html(classes='dataframe', header="true", index=False)
    else:
        df1 = pd.DataFrame(['Click button to crawl!'], columns=['Click button to crawl!'])
        df2 = df1.to_html(classes='dataframe', header="true", index=False)
    return render_template("crawler.html", tables=[df2])


@app.route("/d3viz/")
def d3viz():
    return render_template("d3viz.html")


@app.route("/data")
def data():
    # # https://realpython.com/web-development-with-flask-fetching-data-with-requests/#d3
    # if request.method == 'POST':
    #     # https://stackoverflow.com/questions/35729693/create-a-json-file-from-a-flask-view-to-be-used-with-d3
    #     df1 = pd.read_csv('static/data/ch_vsgdata.csv')
    # else:
    #     df1 = pd.DataFrame(['Click button to render image!'], columns=['Click button to render image!'])
    df1 = pd.read_csv(join(dirname(realpath(__file__)), 'static/data/ch_vsgraw.csv'))
    df2 = df1.groupby(['Topic', 'CharityName', 'CharityCountry', 'ProjDate', 'VolunteerCountry'],
                      as_index=False).agg({'Volunteer': 'nunique', 'VolunteerCity': 'nunique'})
    df2.columns = ['Topic', 'CharityName', 'CharityCountry', 'ProjDate', 'VolunteerCountry', 'Volunteers',
                   'VolunteerCity']

    df2 = df2.to_json(orient="records")

    return jsonify(df2)


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
