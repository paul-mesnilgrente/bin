#!/usr/bin/env python

from argparse import ArgumentParser
import os

if __name__ == '__main__':
    parser = ArgumentParser(description='Download a file')
    parser.add_argument('-u', '--url',      type=str, required=True)
    parser.add_argument('-n', '--name',     type=str, required=True)
    parser.add_argument('-s', '--season',   type=int, required=True)
    parser.add_argument('-e', '--episode',  type=int, required=True)
    args = parser.parse_args()

    source_command = 'source "$HOME/.transmission.auth"'
    tvshow = args.name.replace(' ', '_').title()
    folder = '/home/Videos/Series/{0}/Season_{1:02d}/{0}_-_{1:02d}x{2:02d}'.format(
        tvshow,
        args.season,
        args.episode
    )

    mkdir = 'mkdir -p "{}"'.format(folder)
    chown = 'chown debian-transmission:debian-transmission "{}"'.format(folder)
    transmission_command = 'transmission-remote -ne -a "{}" -w "{}"'.format(
        args.url, folder)
    command = '{} && {} && {} && {}'.format(
        source_command,
        mkdir,
        chown,
        transmission_command)
    print('COMMAND:')
    print(command.replace(' && ', '\n'))
    os.system("ssh paul-mesnilgrente.com '{}'".format(command))