from argparse import ArgumentParser
from tmdb3 import set_key
from tmdb3 import set_locale
from tmdb3 import searchMovie, searchMovieWithYear

if __name__ == '__main__':
    parser = ArgumentParser(description='retrieve information\
                                         from themoviedb.org')
    parser.add_argument('-t', '--title', type=str, required=True)
    parser.add_argument('-y', '--year', type=int)
    parser.add_argument('-l', '--locale', type=str,
                        default='fr-FR')
    args = parser.parse_args()

    set_key('aa898267ad6c91cf89ae0c2afaf167c2')
    set_locale('fr', 'fr')

    if args.year is None:
        for movie in searchMovie(args.title):
            print(movie.title)
    else:
        search_term = '{} ({})'.format(args.title, args.year)
        for movie in searchMovieWithYear(search_term):
            print('Original title:', movie.originaltitle)
            print('French title:', movie.title)
