# import pathlib
from selenium import webdriver
from selenium.common.exceptions import StaleElementReferenceException, WebDriverException, NoSuchElementException
import time
import pandas as pd
from tabulate import tabulate

# https://github.com/pyronlaboratory/heroku-integrated-firefox-geckodriver
# https://github.com/mozilla/geckodriver/releases


class webcrawler:
    def __init__(self, url='https://chenghaoke.shinyapps.io/rshiny/'):
        # self.dr = webdriver.Firefox()
        self.url = url

        profile = webdriver.FirefoxProfile()
        profile.set_preference("browser.privatebrowsing.autostart", True)
        profile.set_preference("browser.download.folderList", 2)
        profile.set_preference("browser.download.manager.showWhenStarting", False)
        profile.update_preferences()
        driver = webdriver.Firefox(firefox_profile=profile)
        # driver.set_window_size(1390, 850)
        driver.maximize_window()

        self.driver = driver

    def crawler(self):
        driver = self.driver
        driver.get(self.url)
        time.sleep(0.2)

        while True:
            time.sleep(0.1)
            try:
                driver.find_element_by_css_selector("#select1 > div:nth-child(2) > div:nth-child(2) > "
                                                    "label:nth-child(1) > input:nth-child(1)").click()
                break
            except (StaleElementReferenceException, WebDriverException, NoSuchElementException):
                continue
        print('radiobutton')

        while True:
            time.sleep(0.1)
            try:
                choice = driver.execute_script("return document.querySelectorAll('#ds1')[0].textContent")
                if choice == "NYS schools":
                    break
            except (StaleElementReferenceException, WebDriverException, NoSuchElementException):
                continue
        print('check')

        while True:
            time.sleep(0.1)
            try:
                driver.find_element_by_css_selector("#sub1").click()
                break
            except (StaleElementReferenceException, WebDriverException, NoSuchElementException):
                continue
        print('button')

        while True:
            time.sleep(0.1)
            try:
                row1 = driver.execute_script("return document.querySelectorAll('tr.odd:nth-child(1) > "
                                             "td:nth-child(2)')[0].textContent")
                if row1 != ("Whenever you select a different dataset, please click the submit button again to "
                            "render the results!"):
                    break
            except (StaleElementReferenceException, WebDriverException, NoSuchElementException):
                continue
        print('check')

        df = pd.DataFrame()
        while True:
            time.sleep(0.1)
            try:
                table = driver.find_element_by_css_selector("[id^=DataTables_Table_]")
                table_html = table.get_attribute('outerHTML')
                df = pd.read_html(table_html)[0]
                break
            except (StaleElementReferenceException, WebDriverException, NoSuchElementException):
                continue
        print('dataframe')
        # <a class="paginate_button next" aria-controls="DataTables_Table_5" data-dt-idx="7" tabindex="0" id="DataTables_Table_5_next">Next</a>
        # <a class="paginate_button next disabled" aria-controls="DataTables_Table_5" data-dt-idx="7" tabindex="-1" id="DataTables_Table_5_next">Next</a>
        driver.find_element_by_class_name("paginate_button next").get_attribute("tabIndex")

        print(tabulate(df, headers='keys', tablefmt='psql'))

        # time.sleep(7)
        # driver.quit()
        return df


if __name__ == '__main__':
    x = webcrawler().crawler()
    pass
