# echo "building docker......."
# docker build . -t ashifa454/trailer-fetcher
# echo "pushing image to hub....."
# docker push ashifa454/trailer-fetcher:latest

# $1 buildType [prod,dev]
echo "Running build job..."
echo "login into docker"
docker login -u ashifa454 -pbower@9971
echo "building docker image...."
docker build . -t ashifa454/trailer-fetcher
echo "tagging docker......"
docker tag ashifa454/trailer-fetcher ashifa454/trailer-fetcher:latest
echo "pushing image to hub....."
docker push ashifa454/trailer-fetcher:latest