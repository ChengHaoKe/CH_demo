# import pathlib
from selenium import webdriver
from os.path import expanduser as ep
# import requests


def firefox(dr):
    firefox_driver = ep('~') + dr

    profile = webdriver.FirefoxProfile()
    profile.set_preference("browser.privatebrowsing.autostart", True)
    profile.set_preference("browser.download.folderList", 2)
    profile.set_preference("browser.download.manager.showWhenStarting", False)
    profile.update_preferences()
    driver = webdriver.Firefox(executable_path=firefox_driver, firefox_profile=profile)
    # driver.set_window_size(1390, 850)
    driver.maximize_window()

    return driver


if __name__ == '__main__':
    pass
