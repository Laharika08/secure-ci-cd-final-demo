import express from 'express';
import config from "config";
import routes from './routes';
import cors from 'cors';

const host = config.get("host") as string;
const port = config.get("port") as number;

const app = express();

const allowedOrigins = config.get("cors_allowed_origins") as string[];

const options: cors.CorsOptions = {
  origin: allowedOrigins
};

app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cors(options));

app.listen(port, host, () => {
    routes(app);
});
