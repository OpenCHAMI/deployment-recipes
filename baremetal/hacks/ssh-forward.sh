ssh \
	-N \
	-L 27779:localhost:27779 \
	-L 3000:localhost:3000 \
	-L 28007:localhost:28007 \
	-L 8443:localhost:8443 \
	-L 5432:localhost:5432 \
	admin &
