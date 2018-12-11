#! /bin/bash

submission_dir=$(pwd)

if [ -f ${submission_dir}/Makefile ]
then
    make -C ${submission_dir}
fi

cd ${submission_dir}

for f in alice bob
do
    if [ ! -x $f ]
    then
        echo "--- No executable $f found ---"
        exit 1
    fi
done

rm -f cipher.txt plain.txt clear.txt
echo "This is a test" > plain.txt
./alice -e "$(cat plain.txt)" > cipher.txt
./bob -d "$(cat cipher.txt)" > clear.txt

diff plain.txt clear.txt
if [ 0 != $? ]
then
    echo "--- plain.txt and clear.txt differ ---"
    exit 1
fi

diff plain.txt cipher.txt
if [ 0 == $? ]
then
    echo "--- cipher.txt is the same as plain.txt ---"
    exit 1
fi

echo "+++ Successfully encrypted and decrypted +++"
exit 0

