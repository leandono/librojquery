var Hapi = require('hapi');

var server = new Hapi.Server(~~process.env.PORT || 8000, '0.0.0.0');

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
server.start(function () {
	console.log('Server started at [' + server.info.uri + ']');
});