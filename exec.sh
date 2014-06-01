#!/bin/sh

cd spec/fixtures/FixtureProject
exec ../../../bin/may $*
cd ../../..
