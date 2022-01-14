#!/bin/bash


prepare_destiny_folder() {
  rm -rf ./$destiny_folder
  mkdir ./$destiny_folder
}

create_watermark() {
  convert -size 400x200 xc:none -pointsize 25 -kerning 1 \
    -gravity center -fill black \
    -annotate 330x330+0+0 $1 -fill white \
    -annotate 330x330+2+2 $1 $watermark_file
}

add_watermark() {
  for file in $@; do
    composite -dissolve 20% -tile $watermark_file \
      $file "$destiny_folder/$file"
  done
}

remove_watermark() {
  rm $watermark_file
}

apply_watermark_all_files() {
  files=$@
  prepare_destiny_folder
  #create_watermark $2
  #files=$(ls $1 | egrep $permit_extensions)
  add_watermark $files
  remove_watermark
}

show_help() {
  echo -e "Usage: wmaker -p PATH -m MARK [-i] [-h]\n"
  echo "-h | --help: this help"
  echo "-p | --path path to image folder to convert"
  echo "-m | --mark water mark text"
  echo "-i | --interactive interactive selection mode"
}

main() {
  COUNTER=0
  ARGS=("$@")
  for i in "$@"; do
    arg=${ARGS[$COUNTER]}
    let COUNTER=COUNTER+1
    nextArg=${ARGS[$COUNTER]}
    case $i in
    -h | --help)
      show_help
      exit 0
      ;;
    -p | --path)
      IMAGES_PATH=$nextArg
      ;;
    -i | --interactive)
      INTERACTIVE=1
      ;;
    -m* | --mark*)
      MARK=$nextArg
      ;;
    esac
  done

  if [ -z $IMAGES_PATH ] || [ ! -d $IMAGES_PATH ]; then
    echo "The specified path does not exist"
    exit 1
  fi

  if [ -z $MARK ]; then
    echo "Text water mark is mandatory"
    exit 1
  else
    create_watermark $MARK
  fi

  if [ "$INTERACTIVE" == 1 ]; then
    selected_file=$(ls -d $IMAGES_PATH/* | fzf)
    selected_file=$(echo $selected_file | sed 's:.*/::')
    files=($selected_file)
  else
    files=$(ls $IMAGES_PATH | egrep $permit_extensions)
  fi

  apply_watermark_all_files $files
  echo "done!"
}

watermark_file='/tmp/watermark.png'
destiny_folder='marked'
permit_extensions='\.png$|\.jpg$|\.gif$'

main $@
