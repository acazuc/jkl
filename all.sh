modes="static"
targets="linux_32 linux_64 windows_32 windows_64"
for mode in $modes
do
	for target in $targets
	do
		sh build.sh -lxb -t $target -m $mode -o "$PWD/build_${target}_${mode}" -j 6
		if [ $? != 0 ]
		then
			exit 1
		fi
	done
done
