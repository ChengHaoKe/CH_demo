# import pathlib
from selenium import webdriver
from selenium.common.exceptions import StaleElementReferenceException, WebDriverException, NoSuchElementException
import time
import pandas as pd
from tabulate import tabulate

# https://github.com/pyronlaboratory/heroku-integrated-firefox-geckodriver
# https://github.com/mozilla/geckodriver/releases
# https://elements.heroku.com/buildpacks/buitron/firefox-buildpack


class webcrawler:
    def __init__(self, url='https://chenghaoke.shinyapps.io/rshiny/'):
        # self.dr = webdriver.Firefox()
        self.url = url

        profile = webdriver.FirefoxProfile()
        profile.set_preference("browser.privatebrowsing.autostart", True)
        profile.set_preference("browser.download.folderList", 2)
        profile.set_preference("browser.download.manager.showWhenStarting", False)
        profile.update_preferences()

        options = webdriver.FirefoxOptions()
        options.headless = True
        driver = webdriver.Firefox(firefox_profile=profile, options=options, log_path='/dev/null')
        # driver.set_window_size(1390, 850)
        driver.maximize_window()

        self.driver = driver

    def waitf(self, func0, **scripts):
        res0 = ''
        while True:
            time.sleep(0.1)
            try:
                res0 = func0(**scripts)
                break
            except (StaleElementReferenceException, WebDriverException, NoSuchElementException):
                continue
        return res0

    def findcss(self, css, what=''):
        if what == 'class':
            css1 = self.driver.find_element_by_class_name(css)
        else:
            css1 = self.driver.find_element_by_css_selector(css)
        return css1

    def executejs(self, js0):
        js1 = self.driver.execute_script(js0)
        return js1

    def crawler(self):
        driver = self.driver
        driver.get(self.url)
        time.sleep(0.2)

        radio0 = self.waitf(self.findcss,
                            css=("#select1 > div:nth-child(2) > div:nth-child(2) > label:nth-child(1) > "
                                 "input:nth-child(1)"))
        radio0.click()
        time.sleep(0.1)

        choice = ''
        while choice != "NYS schools":
            choice = self.waitf(self.executejs, js0="return document.querySelectorAll('#ds1')[0].textContent")
            time.sleep(0.1)

        button0 = self.waitf(self.findcss, css="#sub1")
        button0.click()

        row1 = "Whenever you select a different dataset, please click the submit button again to render the results!"
        rval = "Whenever you select a different dataset, please click the submit button again to render the results!"
        while row1 == rval:
            row1 = self.waitf(self.executejs, js0=("return document.querySelectorAll('tr.odd:nth-child(1) > "
                                                   "td:nth-child(2)')[0].textContent"))
            time.sleep(0.1)

        # max rows
        pnumb = self.waitf(self.findcss, css='dataTables_info', what='class')
        pstr0 = pnumb.get_attribute('textContent')
        pstr1 = [int(s) for s in pstr0.split() if s.isdigit()]
        rmax = max(pstr1)

        dflist = []
        while True:
            time.sleep(0.1)

            # get table
            table = self.waitf(self.findcss, css="[id^=DataTables_Table_]")
            table_html = table.get_attribute('outerHTML')
            df = pd.read_html(table_html)[0]
            dflist.append(df)

            # break condition
            pnumb = self.waitf(self.findcss, css='dataTables_info', what='class')
            pstr0 = pnumb.get_attribute('textContent')
            pstr1 = [int(s) for s in pstr0.split() if s.isdigit()]
            rnow = pstr1[1]
            if rnow >= rmax:
                break

            # click next page
            cont0 = self.waitf(self.findcss, css="a[class='paginate_button next']")
            cont0.click()

        df1 = pd.concat(dflist)
        df1 = df1.reset_index(drop=True).drop(df1.columns[0], axis=1)

        print(tabulate(df1, headers='keys', tablefmt='psql'))

        driver.quit()
        return df1


if __name__ == '__main__':
    # x = webcrawler().crawler()
    pass
