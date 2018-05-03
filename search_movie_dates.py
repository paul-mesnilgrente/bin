#!/usr/bin/env python3

import sys
from os.path import splitext
import os

import time
import http.client
import json
from urllib.parse import quote


# Print iterations progress
def progress_bar(iteration, total, prefix='', suffix='', decimals=1,
                 length=100, fill='█'):
    """
    Call in a loop to create terminal progress bar
    @params:
    iteration   - Required  : current iteration (Int)
    total       - Required  : total iterations (Int)
    prefix      - Optional  : prefix string (Str)
    suffix      - Optional  : suffix string (Str)
    decimals    - Optional  : positive number of decimals in percent (Int)
    length      - Optional  : character length of bar (Int)
    fill        - Optional  : bar fill character (Str)
    """
    percent = ("{0:." + str(decimals) + "f}").format(100 * (iteration /
                                                     float(total)))
    filledLength = int(length * iteration // total)
    bar = fill * filledLength + '-' * (length - filledLength)
    print('\r%s |%s| %s%% %s' % (prefix, bar, percent, suffix), end='\r')
    # Print New Line on Complete
    if iteration == total:
        print()


def get_movie_list_by_file(path2file):
    file = open(path2file)
    return file.read().splitlines()


def get_movie_list_by_path(path):
    dirs = os.listdir()
    res = []
    for folder in dirs:
        if folder[len(folder)-1] != ')':
            res.append(folder)
    return res


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
    return get_json_data(conn, url)


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
    @return dict[id] = json_data[]
    """
    url = construct_movie_search_url(api_key, movie)
    json_data = get_json_data(conn, url)
    while "status_code" in json_data and json_data["status_code"] == 25:
        time.sleep(0.5)
        json_data = get_json_data(conn, url)
    res = {}
    for id, result in enumerate(json_data["results"]):
        res[id] = result
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
        return results[0]["release_date"].split("-")[0]
    for key in results:
        print("    ", key, ". ", results[key]["title"], sep="", end="")
        print(" (", results[key]["release_date"], ")", sep="", end="")
        print(" https://www.themoviedb.org/movie/", results[key]["id"], sep="")
    print("    n.", "None")
    answer = input('--> ')
    if answer == "n":
        return None
    return results[int(answer)]["release_date"].split("-")[0]


def rename_file(filename, date):
    if date is None:
        new_filename = filename
    else:
        new_filename = filename + "_(" + date + ")"
    print("    ------>", new_filename)
    os.rename(filename, new_filename)


if __name__ == '__main__':
    api_key = "aa898267ad6c91cf89ae0c2afaf167c2"
    conn = init_connection()

    if len(sys.argv) == 2:
        lines = get_movie_list_by_file(sys.argv[1])
    else:
        lines = get_movie_list_by_path('.')
    nb_line = len(lines)
    movies = {}
    progress_bar(0, nb_line, prefix='Searching:', length=50)
    for num, line in enumerate(lines):
        progress_bar(num + 1, nb_line, prefix='Searching:', length=50)
        movie = splitext(line.rstrip())[0].replace("_", " ")
        movies[line] = search_movie(conn, api_key, movie)

    for movie in movies:
        if len(movies[movie]) == 0:
            print('No results for "', movie, '"', sep='')
        else:
            date = choose_date(movie, movies[movie])
            rename_file(movie, date)
