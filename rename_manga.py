#!/usr/bin/env python

from argparse import ArgumentParser
from os.path import splitext
from os import rename
import fileinput

def get_args():
    parser = ArgumentParser(description='Rename manga filenames \
                            before to input them into Calibre')
    parser.add_argument('-n', '--name', type=str, required=True)
    parser.add_argument('-p', '--publisher', type=str, required=True)
    parser.add_argument('-a', '--author', type=str, required=True)
    parser.add_argument('-e', '--episode-names', type=str, required=True)
    parser.add_argument('-r', '--rename', type=bool)

    return parser.parse_args()

if __name__ == '__main__':
    args = get_args()
    print(args)

    episode_number = 0
    episode_names = []
    f = fileinput.input(files=(args.episode_names))
    for episode_name in f:
        episode_names.append(episode_name.rstrip())
    f = fileinput.input(files=('-'))
    print('Please enter the file list you wish to rename')
    for filename in f:
        episode_number += 1
        filename = filename.rstrip()
        extension = splitext(filename)[1]
        new_filename = '{0} - {1} - {2} {3:03d} - {2} {3:03d} - {4}{5}'.format(
            args.author,
            args.publisher,
            args.name,
            episode_number,
            episode_names[episode_number - 1],
            extension)

        print(filename)
        print(new_filename)
        print('')
        if args.rename:
            try:
                rename(filename, new_filename)
            except:
                print('{} is not a valid filename'.format(new_filename))
