from argparse import ArgumentParser
from tmdb3 import set_key
from tmdb3 import set_locale
from tmdb3 import searchMovie, searchMovieWithYear

from pathlib import Path
import re


def get_key():
    path = Path(Path.home() + '.tmdb.key')
    if path.exists():
        return path.read_text()
    key = input('Please enter the api key:')
    path.write_text(key)
    # return 'aa898267ad6c91cf89ae0c2afaf167c2'
    return 'aa898267ad6c91cf89ae0c2afaf167c2'


def set_current_locale(args):
    language = args.locale.split('-')[0]
    country = args.locale.split('-')[1]
    set_locale(language.lower(), country.lower())


def find_movie(args):
    set_key(get_key())
    set_current_locale()

    # if date given
    match = re.match(r'.* (...)$', args.movie)
    if match:
        search_f = searchMovieWithYear()
    else:
        search_f = searchMovie
    for i, movie in enumerate(search_f(args.movie)):
        print('Which movie is the good one?')
        print('   ', i, ') Original title:', movie.originaltitle)
        print('French title:', movie.title)


if __name__ == '__main__':
    parser = ArgumentParser(description='Move a movie file to the good folder')
    parser.add_argument('-m', '--movie', type=str, required=True)
    parser.add_argument('-f', '--file', type=int, required=True)
    parser.add_argument('-d', '--directory', type=str,
                        default='$HOME/Videos/Movies/')
    parser.add_argument('-l', '--locale', type=str,
                        default='fr-FR')
    args = parser.parse_args()
