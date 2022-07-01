const RemoteHelpers = require("../common/helpers/remote")
const { InMemoryCache } = require("./inMemoryCache");

const MovieServices = {
    /**
     * @description this service can be used to fetch movie details from viaPlay api and required it can return only specific fields as a response
     */
    getMovieInfo: async (movie_name, keys = []) => {

        if(InMemoryCache.has(movie_name))
            return InMemoryCache.get(movie_name);
        
        const movieResponse = await RemoteHelpers.getMovieInfoFromIMDB(movie_name);
        InMemoryCache.add(movie_name, movieResponse);
        return movieResponse;
    }
}
module.exports = {
    MovieServices
}