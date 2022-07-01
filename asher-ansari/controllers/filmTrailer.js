const nameToImdb = require("name-to-imdb");
const { AppHelpers } = require("../common/helpers/app");
const { ResponseHandler } = require("../common/helpers/response");
const { TheMovieDBService } = require("../services");
const { MovieServices } = require("../services/");
const AppController = {
    handleFetchTrailer: async (req, res, next) => {
        try {
            const { film_name } = req.params;
            const movieResponse = await MovieServices.getMovieInfo(film_name);
            // const imdb = AppHelpers.getImdbIdFromViaPlayResponse(movieResponse);
            const trailers = await TheMovieDBService.getTrailer(movieResponse);
            return ResponseHandler.send(res,{
                data: trailers
            })
        } catch (err) {
            return ResponseHandler.error(res, {
                data: err.message
            });
        }
    }
}
module.exports = {
    AppController
}