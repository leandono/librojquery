var Hapi = require('hapi');
var port = (Number(process.env.PORT) || 8000);

var server = new Hapi.Server(port, 'localhost');

server.route({
	method: 'GET',
	path: '/{path*}',
	handler: {
		directory: {
			path: './libro/html',
			listing: false,
			index: true
		}
	}
});

// Start the server
server.start();