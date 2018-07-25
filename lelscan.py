#!/usr/bin/env python3

from pyquery import PyQuery as pq
from urllib.parse import urlparse
from pathlib import Path
import os
import requests
import shutil
import argparse


def get_args():
    parser = argparse.ArgumentParser(description='Download pictures from a \
                                     scan on lelscan')
    parser.add_argument('-u', '--url',
                        type=str,
                        help='the url of the scan')
    parser.add_argument('-f', '--folder',
                        type=str,
                        default='tmp',
                        help='the folder where to store the images')
    return parser.parse_args()


def check_folder(folder):
    p = Path(folder)
    if p.exists():
        p = 'The folder {} already exists,'.format(folder)
        p += ' do you want to delete its content (y/n)? '
        i = input(p)
        if i == 'y':
            shutil.rmtree(folder)
        else:
            return False
    os.mkdir(folder)
    return True


def get_base_url(url):
    o = urlparse(url)
    return '{}://{}'.format(o[0], o[1])


def get_pages(url):
    d = pq(url=url)
    pages = [link.attr('href') for link in d.items('#navigation a')]
    pages.pop(0)
    pages.pop(len(pages) - 1)
    return pages


def get_images(base_url, pages):
    print('Download pages')
    images = []
    for page in pages:
        print('    {}'.format(page))
        d = pq(url=page)
        src = d('#image img').attr('src')
        if src[0] == '/':
            images.append(base_url + src)
        else:
            images.append(src)
    return images


def save_image(folder, i, response):
    filename = '{}/{:03d}.jpg'.format(folder, i)
    with open(filename, 'wb') as f:
        response.raw.decode_content = True
        shutil.copyfileobj(response.raw, f)


def download_images(folder, images):
    print('Downloading images')
    for i, image in enumerate(images):
        print('    {}'.format(image))
        r = requests.get(image, stream=True)
        if r.status_code != 200:
            print('ERROR: downloading image {}.'.format(image))
            continue
        save_image(folder, i, r)


if __name__ == '__main__':
    args = get_args()
    url = args.url
    folder = args.folder
    print(url, folder)
    if check_folder(folder):
        pages = get_pages(url)
        images = get_images(get_base_url(url), pages)
        download_images(folder, images)
