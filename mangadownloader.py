#!/usr/bin/env python3

from pyquery import PyQuery as pq
from urllib.parse import urlparse, urljoin
from pathlib import Path
from os.path import splitext, isdir
from os import mkdir
import requests
import shutil
import argparse


def get_args():
    parser = argparse.ArgumentParser(description='Download pictures from a \
                                     scan on lelscan')
    parser.add_argument('-i', '--interactive',
                        type=bool,
                        required=False,
                        help='choose this option to select from choices')
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
        self.pages = []

    def __eq__(self, other):
        if isinstance(other, int):
            return other == self.number

    def __repr__(self):
        return '({}) {}'.format(self.number, self.url)


class Manga:
    def __init__(self, name, url):
        self.name = name
        self.url = url
        self.chapters = {}

    def __eq__(self, other):
        if isinstance(other, str):
            return other == self.name

    def __repr__(self):
        return '({}) {}'.format(self.name, self.url)

class Source:
    def __init__(self, url):
        self.url = urlparse(url)
        self.mangas = {}

    def base_url(self):
        return self.url.scheme + '://' + self.url.netloc

    def load_mangas(self):
        raise NotImplementedError('please implement this function')

    def load_manga_chapters(self, manga):
        raise NotImplementedError('please implement this function')

    def load_chapter(self, chapter):
        raise NotImplementedError('please implement this function')

    def save_chapter(self, chapter, folder):
        if isdir(folder):
            shutils.rmtree(folder)
        mkdir(folder)
        for page in chapter.pages:
            src = page.image.url
            path = '{}/{:02d}{}'.format(folder, page.number, splitext(urlparse(src).path)[1])
            page.image.save(path)


class Lelscan(Source):
    def __init__(self):
        super().__init__('http://lelscanv.com') 

    def load_mangas(self):
        d = pq(url=self.base_url() + '/lecture-en-ligne-one-piece.php')
        options = d('form[action="/lecture-en-ligne.php"] select:nth-child(2) option')
        for option in options.items():
            title = option.text()
            url = option.attr.value
            self.mangas[title] = Manga(title, url)
        
    def load_manga_chapters(self, manga):
        d = pq(url=manga.url)
        options = d('form[action="/lecture-en-ligne.php"] select:nth-child(1) option')
        for option in options.items():
            url = option.attr.value
            chapter_number = int(option.text())
            manga.chapters[chapter_number] = Chapter(chapter_number, url)

    def load_chapter(self, chapter):
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


class Scantrad(Source):
    def __init__(self):
        super().__init__('https://scantrad.fr') 

    def load_mangas(self):
        d = pq(url=self.base_url() + '/mangas')
        links = d('ul#projects-list li a')
        for link in links.items():
            title = link('span.project-name').text()
            url = link.attr.href
            self.mangas[title] = Manga(title, url)
 
    def load_manga_chapters(self, manga):
        d = pq(url=manga.url)
        item_list = d('#project-chapters-list li')
        for item in item_list.items():
            url = item('.buttons a:nth-child(1)').attr.href
            chapter_number = int(item('.chapter-number').text().replace('#', ''))
            manga.chapters[chapter_number] = Chapter(chapter_number, url)

    def load_chapter(self, chapter):
        d = pq(url=chapter.url)
        # get the pages links containing the pictures and remove prev/next links
        options = d.items('select.mobile[name="chapter-page"] option')
        chapter.pages = [Page(i + 1, option.attr.value) for i, option in enumerate(options)]
        # get the images
        for page in chapter.pages:
            # download page
            d = pq(url=page.url)
            # download image
            src = d('div.image a img').attr.src
            page.image = Image(page.number, urljoin(self.base_url(), src))
            page.image.download()


class MangaReader(Source):
    def __init__(self):
        super().__init__('http://www.manga.reader.net')

    def load_mangas(self):
        d = pq(url=self.base_url() + '/alphabetical')
        links = d('ul.series_alpha li a')
        for link in links.items():
            title = link.text()
            url = link.attr.href
            self.mangas[title] = Manga(title, url)

    def load_manga_chapters(self, manga):
        raise NotImplementedError('please implement this function')

    def load_chapter(self, chapter):
        raise NotImplementedError('please implement this function')


if __name__ == '__main__':
    args = get_args()
    sources = {
        'lelscan': Lelscan(),
        'scantrad': Scantrad(),
        'mangareader': MangaReader()
    }
    source = sources[args.source]
    # load mangas
    print('Loading mangas from {}...'.format(args.source))
    source.load_mangas()

    # load manga chapters
    print('Loading "{}" chapters...'.format(args.manga))
    manga = source.mangas[args.manga]
    source.load_manga_chapters(manga)

    # load chapter
    print('Loading chapter {} of "{}"...'.format(args.chapter, args.manga))
    chapter = manga.chapters[args.chapter]
    source.load_chapter(chapter)

    # save chapter
    print('Saving "{}" - {:03d}...'.format(args.manga, args.chapter))
    folder = '{} - {:03d}'.format(manga.name, args.chapter).replace(' ', '_')
    if isdir(folder):
        shutil.rmtree(folder)
    source.save_chapter(chapter, folder)
