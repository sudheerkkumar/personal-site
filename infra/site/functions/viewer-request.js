// Runs at CloudFront edge locations on every incoming request.
function handler(event) {
  var request = event.request;
  var host = request.headers.host ? request.headers.host.value : '';

  // 1. www → apex: permanent redirect, keeping the path
  if (host === 'www.sudheerkancharla.dev') {
    return {
      statusCode: 301,
      statusDescription: 'Moved Permanently',
      headers: {
        location: { value: 'https://sudheerkancharla.dev' + request.uri }
      }
    };
  }

  // 2. Clean URLs: map folder paths to their index.html in S3
  var uri = request.uri;
  if (uri.endsWith('/')) {
    request.uri = uri + 'index.html';             // /about/  → /about/index.html
  } else if (uri.lastIndexOf('.') < uri.lastIndexOf('/') + 1) {
    request.uri = uri + '/index.html';            // /about   → /about/index.html
  }                                               // /logo.png stays as is

  return request;
}