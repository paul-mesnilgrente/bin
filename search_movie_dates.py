#!/usr/bin/env python3

import sys
from os.path import splitext
import os

import time
import http.client
import json
from pprint import pprint
from urllib.parse import quote

# Print iterations progress
def progress_bar(iteration, total, prefix='', suffix='', decimals=1, length=100, fill='█'):
    """
    Call in a loop to create terminal progress bar
    @params:
    iteration   - Required  : current iteration (Int)
    total       - Required  : total iterations (Int)
    prefix      - Optional  : prefix string (Str)
    suffix      - Optional  : suffix string (Str)
    decimals    - Optional  : positive number of decimals in percent complete (Int)
    length      - Optional  : character length of bar (Int)
    fill        - Optional  : bar fill character (Str)
    """
    percent = ("{0:." + str(decimals) + "f}").format(100 * (iteration / float(total)))
    filledLength = int(length * iteration // total)
    bar = fill * filledLength + '-' * (length - filledLength)
    print('\r%s |%s| %s%% %s' % (prefix, bar, percent, suffix), end = '\r')
    # Print New Line on Complete
    if iteration == total: 
        print()

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
    """
    Search for movies with title @param movie
    @return dict[id] = (title, date)
    """
    url = construct_movie_search_url(api_key, movie)
    json_data = get_json_data(conn, url)
    while "status_code" in json_data and json_data["status_code"] == 25:
        time.sleep(0.5)
        json_data = get_json_data(conn, url)
    res = {}
    for id, result in enumerate(json_data["results"]):
        res[id] = (result["title"], result["release_date"])
    return res

def choose_date(movie, results):
    """
    Return the chosen date
    @param movie the folder name
    @param results of the movie search
    @return the chosen year
    """
    # os.system('clear')
    print(movie, ":", sep="")
    if len(results) == 1:
        return results[0][1].split("-")[0]
    for key in results:
        print("    ", key, ". ", results[key][0], " (", results[key][1], ")", sep="")
    print("    n.", "None")
    answer = input('--> ')
    if answer == "n":
        return None
    return results[int(answer)][1].split("-")[0]

def rename_file(filename, date):
    if date == None:
        new_filename = filename
    else:
        new_filename = filename + "_(" + date + ")"
    print("    ------>", new_filename)
    os.rename(filename, new_filename)

if __name__ == '__main__':
    api_key = "aa898267ad6c91cf89ae0c2afaf167c2"
    conn = init_connection()

    file = open(sys.argv[1])
    lines = file.read().splitlines()
    l = len(lines)
    movies = {}
    progress_bar(0, l, prefix = 'Searching:', length = 50)
    for num, line in enumerate(lines):
        progress_bar(num + 1, l, prefix = 'Searching:', length = 50)
        movie = splitext(line.rstrip())[0].replace("_", " ")
        movies[line] = search_movie(conn, api_key, movie)

    for movie in movies:
        if len(movies[movie]) == 0:
            print("No results")
        else:
            date = choose_date(movie, movies[movie])
            rename_file(movie, date)
