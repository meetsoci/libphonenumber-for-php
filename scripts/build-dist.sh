#!/usr/bin/env bash

export BASE_DIR=$(dirname $(readlink -f $0))
export BUILD_DIR=$BASE_DIR/dist/build
export TAG=$(git tag --points-at HEAD)
export DIST_FILE=$TAG-dist.zip

if [ -z $TAG ]; then
    echo "Tag release before building distribution"
    exit -1
fi

if [ ! -d $BUILD_DIR ]; then
    echo "Creating build directory $BUILD_DIR..."
    mkdir -p $BUILD_DIR
else
    echo "Clearing build directory $BUILD_DIR..."
    shopt -s dotglob
    rm -rf $BUILD_DIR/*
fi

echo "Copying files..."
cp -r $BASE_DIR/../composer.json $BUILD_DIR/
cp -r $BASE_DIR/../composer.lock $BUILD_DIR/
cp -r $BASE_DIR/../LICENSE $BUILD_DIR/
cp -r $BASE_DIR/../README.md $BUILD_DIR/
cp -r $BASE_DIR/../src $BUILD_DIR/src

echo "Archiving..."
(cd $BUILD_DIR && zip -r $DIST_FILE ./* && mv $DIST_FILE $BASE_DIR/dist/$DIST_FILE)

echo "Cleaning up $BUILD_DIR..."
rm -rf $BUILD_DIR
