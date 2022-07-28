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

out_zip="cellranger-7.0.0.tar.gz"
# Update curl with this download page: https://support.10xgenomics.com/single-cell-gene-expression/software/downloads/latest
curl -o "$out_zip" "https://cf.10xgenomics.com/releases/cell-exp/cellranger-7.0.0.tar.gz?Expires=1658289638&Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9jZi4xMHhnZW5vbWljcy5jb20vcmVsZWFzZXMvY2VsbC1leHAvY2VsbHJhbmdlci03LjAuMC50YXIuZ3oiLCJDb25kaXRpb24iOnsiRGF0ZUxlc3NUaGFuIjp7IkFXUzpFcG9jaFRpbWUiOjE2NTgyODk2Mzh9fX1dfQ__&Signature=WnNTN1Jk2ue-sxCuW~M7WjbMv6HCV5OnTl9Nd0HtoJG~St~~ss~d1ybinHs~Cf6YotkUR0LU9gr2dFJXYc6jWDeXNPU4VsamrSNS3svG98C~6hHH55rwdshn7umdxZgm~DaoOq1aXGPx2gdXZD7aTqmvYkrS5RNtYky6KJA6VIs2Xnh1lYOTxpHWYqKvQ66xQOkm2X8ADI7rilLpeeTMFRYBoj7aQVLVGXaBDfe5wH0iFHwxeWIqdCDzf3pzIN14tD-YJQVLNrf~x4D8760givNUZ8elf7gfKMxRaEK~mFc9yJB7Wo0cqeWrmTDa2X08edKlvFVra69dpMWfqEQSgw__&Key-Pair-Id=APKAI7S6A5RYOXBWRPDA"
tar -xf "$out_zip"
mv cellranger-7.0.0 "$USER_HOME/bin"