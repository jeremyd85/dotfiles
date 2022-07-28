#!/usr/bin/env bash

USER_HOME=$(eval echo ~${SUDO_USER})
CURRENT_DIR=`pwd`
work_dir=`mktemp -d`
cd "$work_dir"

cleanup() {
    rm -rf $work_dir
    cd "$CURRENT_DIR"
}

trap cleanup EXIT

out_zip=cellranger-atac-2.1.0.tar.gz

curl -o "$out_zip" "https://cf.10xgenomics.com/releases/cell-atac/cellranger-atac-2.1.0.tar.gz?Expires=1657901345&Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9jZi4xMHhnZW5vbWljcy5jb20vcmVsZWFzZXMvY2VsbC1hdGFjL2NlbGxyYW5nZXItYXRhYy0yLjEuMC50YXIuZ3oiLCJDb25kaXRpb24iOnsiRGF0ZUxlc3NUaGFuIjp7IkFXUzpFcG9jaFRpbWUiOjE2NTc5MDEzNDV9fX1dfQ__&Signature=EDycHa-naYOAm7Wy6-gilua-0fOq8nZgahNoDe7Ti5ZfeTbVok2VRYBK8a9bGpq9Lg~fTYHCL1z4NJ-uv~vx32mIN7cveOWXALeTk4a9b0XAlD-ml1xmiusJlZdQKbpYOCoC4XRB4Bvyp7S8966Qk950SIOhGOxNz81aBFi43QXlG~CFikWJj~FoRDOFXvsGN7CZC4S7rAxns5zWZeV2Whb6lR3G7PZzUUD3jCuf7gzHRoEAKsCxLoAzqOGLZfdiamHF~VhSJS8bjCpD1LkvQHDZa3pGqFAGEJ6KwRlG-mthI5mXEVWAO3X6YFcYxMeg0uyrC117GvYeLtK3PvPHCg__&Key-Pair-Id=APKAI7S6A5RYOXBWRPDA"
tar -xf "$out_zip"
mv cellranger-atac-2.1.0 $USER_HOME/bin