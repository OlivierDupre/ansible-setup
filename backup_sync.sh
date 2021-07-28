#!/bin/bash
for dir in Bureau Documents Images
do
	echo "$(date) Backing up synchronizing remote gs://petitscoeurs-bkp/$dir with local ~/$dir" >> ~/backup.log
	gsutil rsync -rd ~/$dir gs://petitscoeurs-bkp/$dir
done
