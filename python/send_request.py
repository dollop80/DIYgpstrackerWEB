import requests
import random
import time
import math
from datetime import datetime

upload_script = 'http://vhost3800.cpsite.ru/updatelocation.php'
username = 'python'
session_id = str(int(random.random()*1000))+'-'+str(int(random.random()*1000))+'-'+str(int(random.random()*1000))
nmea = 12345678900987654321
center_lat = 48.747789+0.06
center_lon = 39.189316
for num in range(0,31):
    lat = center_lat + 0.001 * math.cos(num/5.0)
    lon = center_lon + 0.002 * math.sin(num/5.0)
    date_and_time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    payload = {'latitude': str(lat), 'longitude': str(lon), 'speed': '11.1',
               'direction': '230', 'distance': '0', 'date': date_and_time,
               'locationmetod': 'test', 'username': username, 'phonenumber': nmea,
               'sessionid': session_id, 'accuracy': '14', 'extrainfo': '', 'eventtype': 'test' }
    r = requests.get(upload_script, params=payload)
    time.sleep(0.1)
    print(r.url)
