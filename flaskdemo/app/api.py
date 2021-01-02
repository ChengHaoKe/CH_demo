import requests
import json
import gzip
from datetime import datetime, timedelta
# import matplotlib.pyplot as plt
from matplotlib.backends.backend_agg import FigureCanvasAgg as FigureCanvas
from matplotlib.figure import Figure
import io
import base64


class apidemo:
    # https://gitlab.com/snippets/1924163
    def __init__(self, key, where='TW', start='2020-10-01', end='2020-10-31', plt='mean', limit=10):
        self.key = key
        self.header = {'x-api-key': key}
        self.where = where
        self.limit = limit
        self.plt = plt

        st0 = datetime.strptime(start, '%Y-%m-%d')
        ed0 = datetime.strptime(end, '%Y-%m-%d')
        if (ed0 - st0).days > 30:
            ed0 = st0 + timedelta(days=30)
        if ed0 > datetime.today():
            ed0 = datetime.today() - timedelta(days=1)
            st0 = ed0 - timedelta(days=30)

        self.sturl = 'https://bulk.meteostat.net/stations/stations.json.gz'
        self.start = st0.strftime('%Y-%m-%d')
        self.end = ed0.strftime('%Y-%m-%d')

    def stations(self):
        stat0 = json.loads(gzip.decompress(requests.get(self.sturl).content))
        # only stations for chosen country
        st1 = [s for s in stat0 if s['country'] == self.where]

        # check if location actually has values
        st11 = [i for i in st1 if (i['inventory']['hourly']['end'] is not None and
                                   i['inventory']['hourly']['end'] >= '2020-01-01')]

        # limit to first x locations: default 10
        st11 = st11[:round(self.limit)]

        # get station ids
        st2 = [s['id'] for s in st11]
        st3 = [s['name']['en'] for s in st11]

        return st2, st3

    def getall(self):
        st2, st3 = self.stations()
        print('\nSummary table for temperature between:', self.start, '-', self.end)
        url0 = 'https://api.meteostat.net/v2/stations/daily?station={0}&start={1}&end={2}'.format('{station}',
                                                                                                  self.start, self.end)

        d0 = dict()
        for s, n in zip(st2, st3):
            url1 = url0.format(station=s)
            r0 = requests.get(url1, headers=self.header)
            if r0.status_code == 429:
                print('Daily requests have exceeded 2,000! Please try again tomorrow.')
                break
            else:
                try:
                    r1 = r0.json()
                    r2 = r1['data']

                    d0[n] = r2
                except (TypeError, json.decoder.JSONDecodeError):
                    # if there are no values or if the json is empty then just skip
                    continue

        fig = Figure()
        ax = fig.add_subplot(1, 1, 1)
        for s1 in d0.keys():
            if self.plt in ['min', 'MIN', 'Min', 'minimum']:
                yvar = [j['tmin'] for j in d0[s1]]
            elif self.plt in ['max', 'MAX', 'Max', 'maximum']:
                yvar = [j['tmax'] for j in d0[s1]]
            else:
                yvar = [j['tavg'] for j in d0[s1]]
            # plt.plot([j['date'] for j in d0[s1]], yvar, label=s1)
            # plt.xticks(rotation=45)
            ax.plot([j['date'] for j in d0[s1]], yvar, label=s1)
            ax.tick_params(axis='x', rotation=45)
        ax.set_title("title")
        ax.set_xlabel("x-axis")
        ax.set_ylabel("y-axis")
        ax.legend()
        # plt.title('Daily temperature for locations in ' + self.where)
        # plt.legend()

        # Convert plot to PNG image
        png0 = io.BytesIO()
        FigureCanvas(fig).print_png(png0)

        # Encode PNG image to base64 string
        sb64 = "data:image/png;base64,"
        sb64 += base64.b64encode(png0.getvalue()).decode('utf8')

        return sb64

