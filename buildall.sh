#!/bin/bash

prefix="src/"
suffix=".adoc"
for file in src/*
do
    file=${file#"$prefix"}
    file=${file%"$suffix"}
	asciidoctor --trace -b html5 -r ./asciidoctor-extensions/Builder.rb -o "out/html/${file}.html" "src/${file}.adoc"
	asciidoctor --trace -T jupyter-backend -o "out/jupyter/${file}.ipynb" "src/${file}.adoc"
done
