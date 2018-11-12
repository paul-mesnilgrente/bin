#!/usr/bin/env python3

from pyquery import PyQuery as pq
from urllib.parse import urlparse
from pathlib import Path
import os
import requests
import shutil
import argparse


class Page:
    def __init__(self, number, url):
        self.number = number;
        self.url = url

    def download(self, url):
        r = requests.get(image, stream=True)
        if r.status_code != 200:
            print('ERROR: downloading image {}.'.format(image))

    def save(self, path):
        with open(path, 'wb') as f:
            response.raw.decode_content = True
            shutil.copyfileobj(response.raw, f)
 

class Chapter:
    def __init__(self, name, number):
        self.name = name
        self.number = number

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

    def get_pages(url):
        d = pq(url=url)
        pages = [option.attr('value') for option in d.items('select.mobile[name="chapter-page"] option')]
        return pages

    def download(url):
        pages = get_pages(url)
        images = get_images(get_base_url(url), pages)
        download_images(folder, images)


class Manga:
    def __init__(self, name, url):
        self.name = name
        self.url = url
        self.chapters = []

    def get_chapters(self):
        pass


class Source:
    def __init__(self, url):
        self.url = url
        self.mangas = []

    def base_url(self):
        return self.url.scheme + '://' + self.url.netloc

    def get_images(self):
        pass

    def download_manga_list(self):
        if self.mangas == []:
            self.download_manga_list()
        return self.mangas

    def download(self):
        pages = get_pages(url)
        images = get_images(get_base_url(url), pages)
        download_images(folder, images)


class Lelscan(Source):
    def download_manga_list(self):
        d = pq(url=self.base_url() + '/lecture-en-ligne-one-piece.php')
        options = d('form[action="/lecture-en-ligne.php"] select:nth-child(2) option')
        for option in options.items():
            self.mangas.append(Manga(option.text(), option.attr('value')))
        

class Scantrad(Source):
    def download_manga_list(self):
        d = pq(url=self.base_url() + '/mangas')
        links = d('ul#projects-list li a')
        for link in links.items():
            self.mangas.append(Manga(link('span.project-name').text(), link.attr('href')))
        

class MangaReader(Source):
    def download_manga_list(self):
        d = pq(url=self.base_url() + '/alphabetical')
        links = d('ul.series_alpha li a')
        for link in links.items():
            self.mangas.append(Manga(link.text(), link.attr('href')))


class SourceFactory:
    @staticmethod
    def get_source(url):
        o = urlparse(url)
        if o.netloc == 'lelscanv.com':
            return Lelscan(o)
        elif o.netloc == 'scantrad.fr':
            return Scantrad(o)
        elif o.netloc == 'www.mangareader.net':
            return MangaReader(o)


def get_args():
    parser = argparse.ArgumentParser(description='Download pictures from a \
                                     scan on lelscan')
    parser.add_argument('-u', '--url',
                        type=str,
                        required=True,
                        help='the url of the scan')
    parser.add_argument('-a', '--action',
                        type=str,
                        default='download',
                        help='the url of the scan')
    return parser.parse_args()


if __name__ == '__main__':
    args = get_args()
    source = SourceFactory.get_source(args.url)
    if args.action == 'download':
        source.download()
    elif args.action == 'list_mangas':
        source.download_manga_list()
        for i, manga in enumerate(source.mangas):
            print('({}) {}'.format(i + 1, manga.name))
