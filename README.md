# lod.opentransportdata.swiss-site

This provides a server for the domain [lod.opentransportdata.swiss](lod.opentransportdata.swiss). By default the serve listens to port 80.

## Requirements

You need to have [docker](https://docker.com/) installed.

## Building

    docker build -t  zazuko/lod.opentransportdata.swiss .
    
## Running

    docker run --rm -p 80:80  zazuko/lod.opentransportdata.swiss
    
