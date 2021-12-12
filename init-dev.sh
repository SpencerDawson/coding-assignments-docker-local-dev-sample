#!/bin/sh

sample_dir='../sample_app/'
init=false

print_usage() {
    printf ""
}

while getopts 'd:i' flag; do
  case "${flag}" in
    d) sample_dir="${OPTARG}" ;;
    i) init=true ;;
    *) print_usage
       exit 1 ;;
  esac
done


### Symlink the sample project
# Create link if none exist.
if ! [ -L ./src ]; then
    # Check if path is valid directory.
    if [ -d $sample_dir ]; then
        echo "Creating symlink for $sample_dir"
        ln -s $sample_dir ./src
    else
        echo "\"$sample_dir\" must be a valid directory. Check if the project is in your projects folder or pass the path to the script."
        exit 1
    fi
fi

## Launch environment in detatched mode, pass output to console
docker-compose up -d | tee /dev/null

## If initializing environment for the first time, run init commands w/ artisan
if [ $init = true ]; then
    # Must wait atleast 30 seconds for mssql to initialize.
    sleep 30s
    docker exec -it mp_php "php artisan laravel:cmd1" | tee /dev/null
    docker exec -it mp_php "php artisan laravel:cmd2" | tee /dev/null
fi
