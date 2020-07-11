if [ "$1" == "new" ]
then
	carthage update --use-ssh
else
	carthage bootstrap --use-ssh
fi

xcodegen generate