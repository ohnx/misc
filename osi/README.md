# ohnx's system information HTTP server

ohnx's system information HTTP server (shortform: osi) is a little program for Linux computers that provides system information via the `sysinfo()` syscall.

when an HTTP request (well, technically, any data) is sent to the server, a (mostly) valid HTTP answer is sent back, with a JSON object as the payload. the JSON object contains the contents of the sysinfo struct (or most of it, at least).

technically, it is a butchered form of nweb, but very few pieces of the original code exist still in `osi`, as a lot was cut away, and much was also added.

it is probably not very secure and is single-threaded (ie, can only handle 1 request at a time), so it is not meant for direct public use and abuse.

I personally use osi by listening on an obscure port, bound only to localhost, and have nginx reverse proxy and cache the result (for ~1 min).

## how to use

1. compile the file
2. run the file

arguments to pass:

1. port to listen on (mandatory)
2. address to bind to (if not specified, will bind to all. otherwise, specify the IP)


enjoy, and I hope this isn't too much resembling swiss cheese when looked at by a security expert.
