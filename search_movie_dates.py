#!/usr/bin/env python3

import sys
from os.path import splitext

import time
import http.client
import json
from pprint import pprint
from urllib.parse import quote

def init_connection():
    conn = http.client.HTTPSConnection("api.themoviedb.org")
    return conn

def get_json_data(conn, url):
    payload = "{}"
    conn.request("GET", url, payload)

    res = conn.getresponse()
    data = res.read().decode("utf-8")
    if (data == ""):
        return json.loads("{}")
    return json.loads(data)

def get_token(conn, api_key):
    url = "/3/authentication/token/new"
    url += "?api_key=" + api_key
    json_data = get_json_data(conn, url)

def construct_movie_search_url(api_key, movie):
    url = "/3/search/movie?"
    url += "api_key=" + api_key
    url += "&include_adult=false"
    url += "&language=fr-FR"
    url += "&page=1&query=" + movie
    url = quote(url, safe="%/:=&?~#+!$,;'@()*[]")
    return url

def search_movie(conn, api_key, movie):
    print("searching:", movie)
    url = construct_movie_search_url(api_key, movie)
    json_data = get_json_data(conn, url)
    while "status_code" in json_data and json_data["status_code"] == 25:
        time.sleep(0.5)
        json_data = get_json_data(conn, url)
    for result in json_data["results"]:
        print("    found:", result["title"], result["release_date"])
    return conn

if __name__ == '__main__':
    api_key = "aa898267ad6c91cf89ae0c2afaf167c2"
    conn = init_connection()

    file = open(sys.argv[1])
    for line in file.readlines():
        movie = splitext(line.rstrip())[0].replace("_", " ")
        search_movie(conn, api_key, movie)
