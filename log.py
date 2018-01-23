#!/usr/bin/env python3

import argparse
import logging
import sys
import shutil

# Custom formatter
class my_formatter(logging.Formatter):
    debug_format  = "\033[1m\033[34m%(msg)s\033[0m"
    info_format = "\033[1m\033[32m%(msg)s\033[0m"
    warn_format = "\033[1m\033[35m%(msg)s\033[0m"
    error_format  = "\033[1m\033[31m%(msg)s\033[0m"
    critical_format  = "\033[1m\033[107m\033[31m%(msg)s\033[0m"

    def __init__(self):
        super().__init__(fmt="%(levelno)d: %(msg)s", datefmt=None, style='%')  

    def format(self, record):

        # Save the original format configured by the user
        # when the logger formatter was instantiated
        format_orig = self._style._fmt

        # Replace the original format with one customized by logging level
        if record.levelno == logging.DEBUG:
            self._style._fmt = my_formatter.debug_format
        elif record.levelno == logging.INFO:
            self._style._fmt = my_formatter.info_format
        elif record.levelno == logging.WARN:
            self._style._fmt = my_formatter.warn_format
        elif record.levelno == logging.ERROR:
            self._style._fmt = my_formatter.error_format
        elif record.levelno == logging.CRITICAL:
            self._style._fmt = my_formatter.critical_format

        # Call the original formatter class to do the grunt work
        result = logging.Formatter.format(self, record)

        # Restore the original format configured by the user
        self._style._fmt = format_orig

        return result

def get_args():
    parser = argparse.ArgumentParser(description='Log with colors in a console')
    parser.add_argument('-b', '--big',
        action='store_true',
        help='if specified, surround the message by hashes')
    parser.add_argument('-l', '--level',
        nargs='?',
        type=str,
        choices=['DEBUG', 'INFO', 'WARN', 'ERROR', 'CRITICAL'],
        default='INFO',
        help='5 different levels available: DEBUG, INFO, WARN, ERROR, CRITICAL')
    parser.add_argument('log',
        nargs='+',
        type=str,
        help='Logs to print, a line return is done after each argument')
    return parser.parse_args()

def configure_logs():
    ch = logging.StreamHandler()
    ch.setFormatter(my_formatter())

    logging.root.addHandler(ch)
    logging.root.setLevel(logging.DEBUG)

def get_log(args):
    if not args.big:
        return '\n'.join(args.log)
    width = len(max(args.log, key=len)) + 4
    lines = [ '#' * width ]
    logs = [ '# {}{} #'.format(s, ' ' * (width - len(s) - 4)) for s in args.log ]
    lines += logs
    lines.append('#' * width)
    
    return '\n'.join(lines)

def print_log(logs, args):
    if args.level == 'DEBUG':
        logging.debug(logs)
    elif args.level == 'INFO':
        logging.info(logs)
    elif args.level == 'WARN':
        logging.warn(logs)
    elif args.level == 'ERROR':
        logging.error(logs)
    elif args.level == 'CRITICAL':
        logging.critical(logs)

if __name__ == '__main__':
    args = get_args()
    configure_logs()
    log = get_log(args)
    print_log(log, args)
