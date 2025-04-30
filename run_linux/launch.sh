#!/bin/bash

gzdoom="../../gzdoom/gzdoom.exe"

wine $gzdoom -file ../nacht -config ../config.ini $@
