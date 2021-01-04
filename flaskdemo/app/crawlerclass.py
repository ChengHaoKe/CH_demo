# import pathlib
from selenium import webdriver
from os.path import expanduser as ep
# import requests

# https://github.com/pyronlaboratory/heroku-integrated-firefox-geckodriver
# https://github.com/mozilla/geckodriver/releases


class webcrawler:
    def __init__(self, driver):
        self.dr = ep('~') + driver

    def firefox(self):
        firefox_driver = self.dr

        profile = webdriver.FirefoxProfile()
        profile.set_preference("browser.privatebrowsing.autostart", True)
        profile.set_preference("browser.download.folderList", 2)
        profile.set_preference("browser.download.manager.showWhenStarting", False)
        profile.update_preferences()
        driver = webdriver.Firefox(executable_path=firefox_driver, firefox_profile=profile)
        # driver.set_window_size(1390, 850)
        driver.maximize_window()

        return driver

    def crawler(self):
        driver = self.firefox()
        driver.get('https://chenghaoke.shinyapps.io/rshiny/')


if __name__ == '__main__':

    pass
