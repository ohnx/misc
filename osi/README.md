# ohnx's system information HTTP server

ohnx's system information HTTP server (shortform: osi) is a little program for Linux computers that provides system information via the `sysinfo()` syscall.

it is probably not very secure and forks for every request, so it is not meant for direct public use and abuse.

I personally use osi by listening on an obscure port, bound only to localhost, and have nginx reverse proxy and cache the result (for ~1 min).

## how to use

1. compile the file
2. run the file

arguments to pass:

1. port to listen on (mandatory)
2. address to bind to (if not specified, will bind to all. otherwise, specify the IP)


enjoy, and I hope this isn't too much resembling swiss cheese.
