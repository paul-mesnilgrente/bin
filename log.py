#!/usr/bin/env python3

import logging
import sys

# Custom formatter
class my_formatter(logging.Formatter):
    debug_format  = "DEBUG: %(msg)s"
    info_format = "INFO: %(msg)s"
    warn_format = "WARN: %(msg)s"
    error_format  = "ERROR: %(msg)s"
    critical_format  = "CRITICAL: %(msg)s"

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

if __name__ == '__main__':
    ch = logging.StreamHandler()
    ch.setFormatter(my_formatter())

    logging.root.addHandler(ch)
    logging.root.setLevel(logging.DEBUG)

    logging.debug('debug message')
    logging.info('info message')
    logging.warn('warning message')
    logging.error('error message')
    logging.critical('critical message')
