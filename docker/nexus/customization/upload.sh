#!/bin/bash

curl --upload-file artifacts.zip -u admin:admin123 -v 127.0.0.1:8081/nexus/service/local/repositories/releases/content-compressed
