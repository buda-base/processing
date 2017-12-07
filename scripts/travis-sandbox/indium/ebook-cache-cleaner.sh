#!/bin/bash

find /indium/eBooks -ctime +1 -exec rm -f {} \;
