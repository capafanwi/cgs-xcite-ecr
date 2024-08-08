#!/bin/bash -x

IMAGE_REPO="$(aws ecr describe-repositories --repository-name osm-osmosis | jq '.repositories[] | .repositoryUri' |  tr -d '"' |  cut -f1 -d '/' )"
IMAGE_VERSION="2.0.2"

AWS_SOURCE_BUCKET="bda-global-world-osmpds66843a94-noseqboyxown"
BDA_WORLD_BUCKET="bda-osm-planet-ingest5e5b2b02-ixov5x7dbjiu"

BDA_WORLD_NAME=Nürnberg
BDA_TRAVERSAL=wiki

# Nürnberg
# top=49.5138 left=10.9351 bottom=49.3866 right=11.201

BDA_WORLD_NAME=waxhaw
BDA_TRAVERSAL=GS010046

# Waxhaw
# top="34.9259494" left="-80.7493379" bottom="34.9223485" right="-80.7399812" \
BB_TOP="34.93"
BB_LEFT="-80.76"
BB_BOTTOM="34.91"
BB_RIGHT="-80.72" 


argo submit --watch -n argo argo-artifacts/osmosis-extract.yaml \
     -p aws-bucket="${AWS_SOURCE_BUCKET}" \
     -p aws-key-prefix="osm-pds" \
     -p aws-read-file="planet-latest.osm.pbf" \
     -p data-storage-bucket="${BDA_WORLD_BUCKET}" \
     -p osm-write-file="${BDA_WORLD_NAME}-${BDA_TRAVERSAL}-planet-extract.osm.pbf" \
     -p bounding-box-max-lat="${BB_TOP}" \
     -p bounding-box-max-lon="${BB_LEFT}" \
     -p bounding-box-min-lat="${BB_BOTTOM}" \
     -p bounding-box-min-lon="${BB_RIGHT}" \
     -p data-storage-key="extracts" \
     -p version="${IMAGE_VERSION}" \
     -p imageRepo="${IMAGE_REPO}"
