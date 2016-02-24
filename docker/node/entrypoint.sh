#!/bin/bash
PARAMS=$@
export NODE_PATH=/app/node_modules
gulp $PARAMS
