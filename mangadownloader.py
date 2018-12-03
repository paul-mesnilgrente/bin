#!/usr/bin/env python3

from pyquery import PyQuery as pq
from urllib.parse import urlparse, urljoin
from pathlib import Path
from os.path import splitext, isdir
from os import mkdir
from collections import OrderedDict

import mimetypes
import requests
import shutil
import argparse


def get_args(sources):
    parser = argparse.ArgumentParser(description='Download pictures from a \
                                     scan on lelscan')
    parser.add_argument('-s', '--source',
                        choices=sources,
                        help='the source to download the manga from')
    parser.add_argument('-m', '--manga',
                        type=str,
                        help='the manga to download')
    parser.add_argument('-c', '--chapters',
                        type=str,
                        help='the chapters to download')
    parser.add_argument('-o', '--overwrite',
                        type=bool,
                        help='overwrite the folder')
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

    def save(self, folder):
        mimetypes.init()
        mimetype = self.response.headers['content-type'].split()[0].rstrip(";")
        ext = mimetypes.guess_extension(mimetype)
        ext = '.jpg' if ext == '.jpe' else ext
        path = '{}/{:02d}{}'.format(folder, self.number, ext)
        with open(path, 'wb') as f:
            self.response.raw.decode_content = True
            shutil.copyfileobj(self.response.raw, f)

    def download_and_save(self, folder):
        self.download()
        self.save(folder)
        del self.response
 

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
        self.chapters = OrderedDict()

    def __eq__(self, other):
        if isinstance(other, str):
            return other == self.name

    def __repr__(self):
        return '({}) {}'.format(self.name, self.url)

class Source:
    def __init__(self, url):
        self.url = urlparse(url)
        self.mangas = OrderedDict()

    def base_url(self):
        return self.url.scheme + '://' + self.url.netloc

    def load_mangas(self):
        raise NotImplementedError('please implement this function')

    def load_manga_chapters(self, manga):
        raise NotImplementedError('please implement this function')

    def load_and_save_chapter(self, chapter):
        raise NotImplementedError('please implement this function')

    def save_chapter(self, chapter, folder):
        mkdir(folder)
        for page in chapter.pages:
            src = page.image.url
            page.image.save(folder)


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
            try:
                chapter_number = int(option.text())
            except:
                chapter_number = float(option.text())
            manga.chapters[chapter_number] = Chapter(chapter_number, url)

    def load_and_save_chapter(self, chapter, folder):
        mkdir(folder)
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
            page.image.download_and_save(folder)


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

    def load_and_save_chapter(self, chapter, folder):
        mkdir(folder)
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
            page.image.download_and_save(folder)


class MangaReader(Source):
    def __init__(self):
        super().__init__('https://www.mangareader.net')

    def load_mangas(self):
        d = pq(url=urljoin(self.base_url(), '/alphabetical'))
        links = d('ul.series_alpha li a')
        for link in links.items():
            title = link.text()
            url = link.attr.href
            self.mangas[title] = Manga(title, url)

    def load_manga_chapters(self, manga):
        d = pq(url=urljoin(self.base_url(), manga.url))
        links = d('#listing a')
        for link in links.items():
            url = link.attr.href
            chapter_number = int(url.split('/')[-1])
            manga.chapters[chapter_number] = Chapter(chapter_number, url)

    def load_and_save_chapter(self, chapter, folder):
        mkdir(folder)
        d = pq(url=urljoin(self.base_url(), chapter.url))
        # get the pages links containing the pictures and remove prev/next links
        options = d.items('#pageMenu option')
        chapter.pages = [Page(i + 1, option.attr.value) for i, option in enumerate(options)]
        # get the images
        for page in chapter.pages:
            # download page
            d = pq(url=urljoin(self.base_url(), page.url))
            # download image
            src = d('#imgholder img').attr.src
            page.image = Image(page.number, urljoin(self.base_url(), src))
            page.image.download_and_save(folder)


class Input:
    @staticmethod
    def select_from_dict(message, dic, object_str):
        obj = dic.get(object_str)
        while obj is None:
            print(message)
            keys = []
            for i, key in enumerate(dic.keys()):
                keys.append(key)
                print('    ({}) {}'.format(i + 1, key))
            answer = int(input('Please input your choice: '))
            if answer < 1 or answer > len(keys):
                obj = None
                print('Wrong input.')
            else:
                obj = dic[keys[answer - 1]]
        return obj
        
    @staticmethod
    def select_source(sources, source_str):
        return Input.select_from_dict('Available sources: ', sources, source_str)

    @staticmethod
    def select_manga(mangas, manga_str):
        return Input.select_from_dict('Available mangas: ', mangas, manga_str)

    @staticmethod
    def convert_ranges(ranges):
        chapters_str = ranges.lower().replace(' ', '')
        lists_str = ranges.split(',')
        res = set()
        for item in lists_str:
            if item.find('-') != -1:
                begin = int(item.split('-')[0])
                end = int(item.split('-')[1])
                [res.add(i) for i in range(begin, end + 1)]
            else:
                try:
                    res.add(int(item))
                except:
                    res.add(float(item))
        return res
        

    @staticmethod
    def convert_chapters_arg(chapters, chapters_str):
        """
        Convert into a set of float and int corresponding
        to chapter numbers
        """
        res = set()
        # parameter not given
        if chapters_str is None:
            res = None
        # every chapters
        elif chapters_str.lower() == 'all':
            res = res.union(chapters.keys())
        # last chapter
        elif chapters_str.lower() == 'last':
            res.add(max(chapters.keys()))
        # given chapters
        else:
            chapters_inputed = Input.convert_ranges(chapters_str)
            for chapter in chapters_inputed:
                if chapter not in chapters:
                    print('ERROR:', chapter, 'not in the list.')
                    chapters_inputed = None
            res = None if chapters_inputed is None else res.union(chapters_inputed)
            
        return res

    @staticmethod
    def select_chapters(chapters, chapters_str):
        res = None
        while res is None:
            for key in chapters:
                print('    ({}) {}'.format(key, chapters[key]))
            if chapters_str is None:
                chapters_str = input('Please input your choice (all/last/[0-9]*,[0-9]*...): ')
            print('You inputed: ', chapters_str)
            res = Input.convert_chapters_arg(chapters, chapters_str)
        return res


if __name__ == '__main__':
    sources = {
        'lelscan': Lelscan(),
        'scantrad': Scantrad(),
        'mangareader': MangaReader()
    }
    args = get_args(sources.keys())
    source = Input.select_source(sources, args.source)

    # load mangas
    print('Loading manga list...')
    source.load_mangas()
    manga = Input.select_manga(source.mangas, args.manga)

    # load manga chapters
    print('Loading chapters...')
    source.load_manga_chapters(manga)
    chapters_number = Input.select_chapters(manga.chapters, args.chapters)
    print('Chapters', chapters_number, 'will be downloaded')

    # download and save chapters
    for number in chapters_number:
        chapter = manga.chapters[number]

        folder = '{} - {:03d}'.format(manga.name, chapter.number).replace(' ', '_')
        download = True
        if isdir(folder):
            if args.overwrite:
                print('Deleting folder "{}"'.format(folder))
                shutil.rmtree(folder)
            else: 
                print('Chapter already downloaded')
                download = False
        # save chapter
        if download:
            print('Downloading chapter', chapter.number, 'of "{}"'.format(manga.name))
            source.load_and_save_chapter(chapter, folder)
