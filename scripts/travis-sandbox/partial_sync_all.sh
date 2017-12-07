#!/bin/bash

rsync -av --delete W1KG4884/archive/W1KG4884-I1KG4890/ /Volumes/Archive/W1KG4884/archive/W1KG4884-I1KG4890
rsync -av --delete W1KG4884/images/W1KG4884-I1KG4890/ /Volumes/Archive/W1KG4884/images/W1KG4884-I1KG4890

rsync -av --delete W1KG4884/archive/W1KG4884-I1KG4890/ /Volumes/WebArchive/W1KG4884/archive/W1KG4884-I1KG4890
rsync -av --delete W1KG4884/images/W1KG4884-I1KG4890/ /Volumes/WebArchive/W1KG4884/images/W1KG4884-I1KG4890

aws s3 sync --only-show-errors W1KG4884/images s3://archive.tbrc.org/Works/9f/W1KG4884/images
