#!/bin/bash 
DIR="/mnt/d/FileHistory/tyran/General/Overleaf_backs"
NOTEBOOK="/mnt/c/Users/tyran/Documents/OneNote Notebooks/Honours"
LOCAL_STORE="/mnt/c/Users/tyran/Documents/Backs"
if [ -d "$DIR" ]; then
    for file in /mnt/c/Users/tyran/Downloads/*; do 
        back=$(echo $file | cut -d'/' -f 7)
        if [[ $back == Overleaf* ]]; then 
            echo "Found backup match $back at $file"
            dname=$(date -r "$file" "+%d-%m-%Y" | tr [:space:] - | sed 's/.$//')
            new_dir="$DIR/$dname"
            new_local="$LOCAL_STORE/$dname"
            echo "Copying to $new_dir..." 
            mkdir $new_dir
            echo "Moving to $new_local..."
            mkdir $new_local
            cp "$file" "$new_dir/"
            mv "$file" "$new_local/" 
        fi
    done 
    if [ -d "$NOTEBOOK" ]; then
        if [ -d "/mnt/d/Notes" ]; then 
            ls "$NOTEBOOK"
            rdir="/mnt/d/Notes/$(date +%d-%m-%Y)"
            mkdir "$rdir"
            zip -r "$rdir/Honours_Backup.zip" "$NOTEBOOK/" 
        fi
    fi
fi