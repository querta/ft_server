if [[ $# -eq 0 ]] ; then
    printf "1. В docker quickstart вводим \"docker ps\"\n"
	printf "Если ругается на отключенный демон, запускай скрипт с аргументом '2'"
	printf "Основной скрипт работает по аргументу 1"
    exit 1
fi

if [ "$1" = 1 ];
then
	GOINFRE="/goinfre/$USER";
	echo $GOINFRE
	mkdir $GOINFRE/Caches
	mkdir $GOINFRE/Caches/com.docker.docker
	rm -rf ~/Library/Caches/com.docker.docker
	ln -s $GOINFRE/Caches/com.docker.docker ~/Library/Caches/com.docker.docker
	mkdir $GOINFRE/Containers
	mkdir $GOINFRE/.docker
	rm -rf ~/.docker
	ln -s $GOINFRE/.docker ~/.docker
	mkdir $GOINFRE/Containers/com.docker.docker
	rm -rf ~/Library/Containers/com.docker.docker
	ln -s $GOINFRE/Containers/com.docker.docker ~/Library/Containers/com.docker.docker
fi

if [ "$1" = 2 ];
then
	docker-machine restart
	docker-machine regenerate-certs default
	eval "$(docker-machine env default)"
	docker-machine restart
fi