#!/usr/bin/env python

from argparse import ArgumentParser
import os

if __name__ == '__main__':
    parser = ArgumentParser(description='Download a file')
    parser.add_argument('-u', '--url',   type=str, required=True)
    parser.add_argument('-t', '--title', type=str, required=True)
    parser.add_argument('-y', '--year',  type=int, required=True)
    args = parser.parse_args()

    source_command = 'source "$HOME/.transmission.auth"'
    folder = '/home/Videos/Movies/{}_({})'.format(
        args.title.replace(' ', '_'), args.year)
    mkdir = 'mkdir "{}"'.format(folder)
    chown = 'chown debian-transmission:debian-transmission "{}"'.format(folder)
    transmission_command = 'transmission-remote -ne -a "{}" -w "{}"'.format(
        args.url, folder)
    command = '{} && {} && {} && {}'.format(
        source_command,
        mkdir,
        chown,
        transmission_command)
    print(command)
    os.system("ssh paul-mesnilgrente.com '{}'".format(command))