import requests
import json

def get_cities(country_code):
    url = f"http://api.geonames.org/searchJSON"
    params = {
        "featureCode": "PPLA",
        "country": country_code,
        "username": "qwertypbd",
        "orderby": "population",
        "maxRows": "3",
    }
    response = requests.get(url, params=params)
    if response.status_code == 200:
        data = response.json()
        print(data)
        return [{
            "city_name": city["name"],
        } for city in data.get('geonames', [])]
    else:
        print(f"Błąd przy pobieraniu danych: {response.status_code}")
        return []

def get_countries():
    url = f"http://api.geonames.org/countryInfoJSON"
    params = {
        "username": "qwertypbd"
    }
    response = requests.get(url, params=params)
    if response.status_code == 200:
        data = response.json()
        return [{
            "country_name": country["countryName"],
            "code": country["countryCode"],
            "cities": get_cities(country["countryCode"])
        } for country in data.get('geonames', [])]
    else:
        print(f"Błąd przy pobieraniu danych: {response.status_code}")
        return []

# Lista krajów (możesz użyć wcześniejszej listy 'countries')

# Pobieranie miast dla każdego kraju
countries = get_countries()
all_cities = []
for country in countries:
    print(country)

with open("cities.json", "w", encoding="utf-8") as file:
    json.dump(countries, file, ensure_ascii=False, indent=4)


