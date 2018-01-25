#!/usr/bin/env python3

import requests
import shutil
import os
import argparse

def get_args():
    parser = argparse.ArgumentParser(description='Log with colors in a console')
    parser.add_argument('-m', '--manga',
        nargs=1,
        type=str,
        help='the manga to download the episode from')
    parser.add_argument('-e', '--episode',
        nargs=1,
        type=int,
        help='The episode to download')
    parser.add_argument('-n', '--number-of-pages',
        nargs=1,
        type=int,
        help='The number of pages there is in the episode')
    parser.add_argument('-f', '--folder',
        nargs='?',
        type=str,
        help='The folder where to put the pages')
    return parser.parse_args()

def get_urls(args):
    res = []
    name = args.manga[0].replace(' ', '-').lower()
    episode = args.episode[0]
    folder = '{}_-_{:03d}'.format(name, episode) if (args.folder == None) else args.folder
    if not os.path.exists(folder):
        os.makedirs(folder)
    base_url = 'http://lelscanz.com/mangas/'
    base_url += '{}/{}/'.format(name, episode)
    for i in range(args.number_of_pages[0] + 1):
        url_n = '{}{}.jpg'.format(base_url, i)
        url_a = '{}{:02}.jpg'.format(base_url, i)
        filename = '{}/{:03d}.jpg'.format(folder, i)
        res.append((url_n, url_a, filename))
    return res

def save_episode(response, filename):
    with open(filename, 'wb') as f:
        response.raw.decode_content = True
        shutil.copyfileobj(response.raw, f)
    
def download_episodes(urls):
    """
    urlretrieve does not work because lelscanz.com does not accept it
    it answers a 403 forbidden
    """
    for url, url_a, filename in urls:
        print('{} -> {}'.format(url, filename))
        r = requests.get(url, stream=True)
        if r.status_code == 200:
            save_episode(r, filename)
        else:
            r = requests.get(url_a, stream=True)
            if r.status_code == 200:
                save_episode(r, filename)
            else:
                print('ERROR: request returned {}'.format(r.status_code))

if __name__ == '__main__':
    args = get_args()
    print(args)
    urls = get_urls(args)
    download_episodes(urls)
