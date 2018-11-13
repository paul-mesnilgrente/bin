#!/usr/bin/env python3

from pyquery import PyQuery as pq
from urllib.parse import urlparse, urljoin
from pathlib import Path
from os.path import splitext
from os import mkdir
import requests
import shutil
import argparse


def get_args():
    parser = argparse.ArgumentParser(description='Download pictures from a \
                                     scan on lelscan')
    parser.add_argument('-s', '--source',
                        type=str,
                        required=True,
                        help='the source to download the manga from')
    parser.add_argument('-m', '--manga',
                        type=str,
                        required=True,
                        help='the manga to download')
    parser.add_argument('-c', '--chapter',
                        type=int,
                        required=True,
                        help='the chapters to download')
    return parser.parse_args()


class Image:
    def __init__(self, number, url):
        self.number = number
        self.url = url
        self.response = None

    def download(self):
        self.response = requests.get(self.url, stream=True)
        if self.response.status_code != 200:
            print('ERROR: downloading image {}.'.format(image))

    def save(self, path):
        with open(path, 'wb') as f:
            self.response.raw.decode_content = True
            shutil.copyfileobj(self.response.raw, f)
 

class Page:
    def __init__(self, number, url):
        self.number = number;
        self.url = url
        self.image = None
 

class Chapter:
    def __init__(self, number, url):
        self.url = url
        self.number = int(number)

    def __eq__(self, other):
        if isinstance(other, int):
            return other == self.number

    def __repr__(self):
        return '({}) {}'.format(self.number, self.url)


class Manga:
    def __init__(self, name, url):
        self.name = name
        self.url = url
        self.chapters = []

    def find_chapter(self, chapter_number):
        index = self.chapters.index(int(chapter_number))
        return self.chapters[index]

    def __eq__(self, other):
        if isinstance(other, str):
            return other == self.name

    def __repr__(self):
        return '({}) {}'.format(self.name, self.url)

class Source:
    def __init__(self, url):
        self.url = urlparse(url)
        self.mangas = []

    def base_url(self):
        return self.url.scheme + '://' + self.url.netloc

    def find_manga(self, manga_title):
        if self.mangas == []:
            self.download_manga_list()
        index = self.mangas.index(manga_title)
        self.download_chapter_list(self.mangas[index])
        return self.mangas[index]

    def download_manga_list(self):
        raise NotImplementedError('please implement this function')

    def download_chapter_list(self, manga):
        raise NotImplementedError('please implement this function')

    def download_chapter_images(self, manga, chapter, folder):
        try:
            mkdir(folder)
        except:
            pass


class Lelscan(Source):
    def __init__(self):
        super().__init__('http://lelscanv.com') 

    def download_manga_list(self):
        d = pq(url=self.base_url() + '/lecture-en-ligne-one-piece.php')
        options = d('form[action="/lecture-en-ligne.php"] select:nth-child(2) option')
        for option in options.items():
            self.mangas.append(Manga(option.text(), option.attr.value))
        
    def download_chapter_list(self, manga):
        d = pq(url=manga.url)
        options = d('form[action="/lecture-en-ligne.php"] select:nth-child(1) option')
        for option in options.items():
            manga.chapters.append(Chapter(option.text(), option.attr.value))

    def download_chapter_images(self, manga, chapter, folder):
        super().download_chapter_images(manga, chapter, folder)
        d = pq(url=chapter.url)
        # get the pages links containing the pictures and remove prev/next links
        chapter.pages = [Page(i, link.attr.href) for i, link in enumerate(d.items('#navigation a'))]
        chapter.pages.pop(0)
        chapter.pages.pop(len(chapter.pages) - 1)
        # get the images
        for page in chapter.pages:
            # download page
            d = pq(url=page.url)
            # download image
            src = d('#image img').attr.src
            page.image = Image(page.number, urljoin(self.base_url(), src))
            page.image.download()
            # save image
            path = '{}/{:02d}{}'.format(folder, page.number, splitext(urlparse(src).path)[1])
            page.image.save(path)


class Scantrad(Source):
    def __init__(self):
        super().__init__('https://scantrad.fr') 

    def download_manga_list(self):
        d = pq(url=self.base_url() + '/mangas')
        links = d('ul#projects-list li a')
        for link in links.items():
            self.mangas.append(Manga(link('span.project-name').text(), link.attr.href))
 
    def download_chapter_list(self, manga):
        raise NotImplementedError('please implement this function')


class MangaReader(Source):
    def __init__(self):
        super().__init__('http://www.manga.reader.net')

    def download_manga_list(self):
        d = pq(url=self.base_url() + '/alphabetical')
        links = d('ul.series_alpha li a')
        for link in links.items():
            self.mangas.append(Manga(link.text(), link.attr.href))

    def download_chapter_list(self, manga):
        raise NotImplementedError('please implement this function')


if __name__ == '__main__':
    args = get_args()
    sources = [
        (Lelscan(), 'lelscan'),
        (Scantrad(), 'scantrad'),
        (MangaReader(), 'mangareader')
    ]
    for source in sources:
        if args.source == source[1]:
            # find the manga asked for
            print('Searching manga...')
            manga = source[0].find_manga(args.manga)
            # check the chapters
            print('Searching chapter...')
            chapter = manga.find_chapter(args.chapter)
            # download the chapter
            print('Downloading "{}" - {:03d}...'.format(manga.name, chapter.number))
            source[0].download_chapter_images(manga, chapter, 'tmp')
