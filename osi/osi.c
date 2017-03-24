#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <fcntl.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/sysinfo.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <linux/unistd.h>
#include <linux/kernel.h>

#define VERSION "1.0.2"

const char *header = "HTTP/1.1 200 OK\r\n"
"Date: Fri, 31 Dec 1999 23:59:59 GMT\r\n"
"Server: osi/"VERSION" (linux)\r\n"
"Content-Length: %d\r\n"
"Last-Modified: Sat, 20 Nov 2004 07:16:26 GMT\r\n"
"Accept-Ranges: bytes\r\n"
"Content-Type: application/json\r\n"
"Connection: close\r\n\r\n";

#define load_to_float(x) (((float)x) / (float)(1 << SI_LOAD_SHIFT))

/* this is a child web server process, so we can exit on errors */
void web(int fd) {
    char headerbuf[256], buffer[512];
    
    struct sysinfo si;
    int error = sysinfo(&si);
    if (error != 0)
        sprintf(buffer, "{\"msg\":\"Error querying sysinfo\"}");
    else
        sprintf(buffer, "{\"uptime\":%ld,\"totalram\":%ld,"
                        "\"freeram\":%ld,\"totalswap\":%ld,"
                        "\"freeswap\":%ld,\"loads\":"
                        "[%f, %f, %f]}",
                si.uptime, si.totalram,
                si.freeram, si.totalswap,
                si.freeswap, load_to_float(si.loads[0]),
                load_to_float(si.loads[1]), load_to_float(si.loads[2]));
    
    sprintf(headerbuf, header, strlen(buffer));
    (void)write(fd, headerbuf, strlen(headerbuf));
    (void)write(fd, buffer, strlen(buffer));

    sleep(1);    /* allow socket to drain before signalling the socket is closed */
}

int main(int argc, char *argv[]) {
    int enable = 1, port, pid, listenfd, socketfd;
    socklen_t length;
    char str[INET_ADDRSTRLEN];
    static struct sockaddr_in cli_addr; /* static = initialised to zeros */
    static struct sockaddr_in serv_addr; /* static = initialised to zeros */
    
    if (argc < 2) {
        printf("please give a port :)\n");
        return -1;
    }
    
    /* setup the network socket */
    if((listenfd = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
        printf("socket create error\n");
        return -1;
    }
    
    if (setsockopt(listenfd, SOL_SOCKET, SO_REUSEADDR, &enable, sizeof(int)) < 0) {
        printf("set reuseaddr failed");
        return -1;
    }
    
    port = atoi(argv[1]);
    
    if (port < 0 || port > 65535) {
        printf("invalid port :(\n");
        return -1;
    }
    
    printf("Listening on %s:%d\n", (argc >= 3) ? argv[2] : "*", port);
    
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_addr.s_addr = (argc >= 3) ? inet_addr(argv[2]) : htonl(INADDR_ANY);
    serv_addr.sin_port = htons(port);
    
    if (bind(listenfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0) {
        printf("bind error\n");
        return -1;
    }
    
    if (listen(listenfd, 64) < 0) {
        printf("listen error\n");
        return -1;
    }
    
    // probably terrible practice to just casually clobber this... lol
    sprintf(argv[0], "ohnx's system information HTTP server v"VERSION);
    
    while (1) {
        length = sizeof(cli_addr);
        if ((socketfd = accept(listenfd, (struct sockaddr *)&cli_addr, &length)) < 0) {
            printf("accept error\n");
        }
        /* get ip */
        inet_ntop(AF_INET, &cli_addr.sin_addr.s_addr, str, INET_ADDRSTRLEN);
        printf("request from: %s\n", str);
        web(socketfd);
        (void)close(socketfd);
    }
    
    return 0;
}
