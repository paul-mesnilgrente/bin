#!/usr/bin/env python3

from argparse import ArgumentParser
import os

def get_args():
    parser = ArgumentParser(description="Calculate the number of \
                            charge for a power bank")
    parser.add_argument('-b', '--battery-capacity',
                        type=float, help=
                        "capacity of the device in mAh")
    parser.add_argument('-p', '--powerbank-capacity',
                        type=float, help=
                        "the powerbank capacity mAh")
    parser.add_argument('-o', '--powerbank-output-voltage',
                        type=float, default=5, help=
                        "output voltage of powerbank in V")
    parser.add_argument('-e', '--efficiency',
                        type=float, default=0.85, help=
                        "")
    parser.add_argument('-v', '--battery-cell-voltage',
                        type=float, default=3.7, help=
                        "output voltage of powerbank in V")
    
    return parser.parse_args()

# Source: http://blog.ravpower.com/2017/10/many-times-can-power-bank-recharge-smartphone/
if __name__ == '__main__':
    args = get_args()
    print("(powerbank_capacity * battery_cell_voltage / powerbank_output_voltage) * efficiency / battery_capacity")
    print(
        "({} * {} / {}) * {} / {}".format(
            args.powerbank_capacity,
            args.battery_cell_voltage,
            args.powerbank_output_voltage,
            args.efficiency,
            args.battery_capacity
    ))
    print(
        (
            args.powerbank_capacity *
            args.battery_cell_voltage /
            args.powerbank_output_voltage
        ) * args.efficiency / 
        args.battery_capacity
    )
