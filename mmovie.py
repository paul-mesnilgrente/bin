#!/usr/bin/env python

from argparse import ArgumentParser
from argparse import FileType
import os

if __name__ == '__main__':
    parser = ArgumentParser(description='Download a file')
    parser.add_argument('--torrent',     type=FileType('r'), required=False)
    parser.add_argument('-u', '--url',   type=str,           required=False)
    parser.add_argument('-t', '--title', type=str,           required=True)
    parser.add_argument('-y', '--year',  type=int,           required=True)
    args = parser.parse_args()

    if args.url is None and args.torrent is None:
        raise Exception('Please provide a torrent file or a url')

    if args.url is not None and args.torrent is not None:
        raise Exception('Please provide a URL or a torrent, not both')

    if args.torrent is not None:
        os.system('scp "{}" paul-mesnilgrente.com:/tmp/my.torrent'.format(
            args.torrent.name))
        args.torrent = '/tmp/my.torrent'

    source_command = 'source "$HOME/.transmission.auth"'
    folder = '/home/Videos/Movies/{}_({})'.format(
        args.title.replace(' ', '_'), args.year)
    rm = 'rm -rf "{}"'.format(folder)
    mkdir = 'mkdir "{}"'.format(folder)
    chown = 'chown debian-transmission:debian-transmission "{}"'.format(folder)
    transmission_command = 'transmission-remote -ne -a "{}" -w "{}"'.format(
        args.url or args.torrent, folder)
    command = ' && '.join([source_command, rm, mkdir, chown, transmission_command])
    print(command)
    os.system("ssh paul-mesnilgrente.com '{}'".format(command))
