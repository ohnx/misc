/* 
 * udpserver.c - A simple UDP echo server 
 * usage: udpserver <port>
 */

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <netdb.h>
#include <sys/types.h> 
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <stdint.h>

#define BUFSIZE 65535

struct __attribute__((__packed__)) dns_header {
    // transaction id 2 bytes
    unsigned short transaction_id;
    
    // flags
    //x....... ........ = Response
    //.xxxx... ........ = Opcode
    //......x. ........ = Truncated
    //.......x ........ = Recursion desired
    //........ .x...... = Z: reserved (0)
    //........ ...x.... = Non-authenticated data OK
    unsigned short flags;
    
    // # of questions
    unsigned short num_questions;
    
    // # of answers
    unsigned short num_answers;
    
    // # authorities
    unsigned short num_authority;
    
    // # additional stuff
    unsigned short num_additional;
    
    // questions/answers/etc. follow...
};

enum dns_record_type {
    DNS_RECORD_A = 1,
    DNS_RECORD_NS = 2,
    DNS_RECORD_CNAME = 5,
    DNS_RECORD_SOA = 6,
    DNS_RECORD_PTR = 12,
    DNS_RECORD_MX = 15,
    DNS_RECORD_TXT = 16,
    DNS_RECORD_AAAA = 28,
    DNS_RECORD_SRV = 33,
    DNS_RECORD_RRSIG = 46,
    DNS_RECORD_ANY = 255,
};

const char *code_to_str(enum dns_record_type in) {
    switch(in) {
    case DNS_RECORD_A: return "A";
    case DNS_RECORD_NS: return "NS";
    case DNS_RECORD_CNAME: return "CNAME";
    case DNS_RECORD_SOA: return "SOA";
    case DNS_RECORD_PTR: return "PTR";
    case DNS_RECORD_MX: return "MX";
    case DNS_RECORD_TXT: return "TXT";
    case DNS_RECORD_AAAA: return "AAAA";
    case DNS_RECORD_SRV: return "SRV";
    case DNS_RECORD_RRSIG: return "RRSIG";
    case DNS_RECORD_ANY: return "ANY";
    default: return "UNKNOWN";
    }
}

struct __attribute__((__packed__)) dns_request {
    struct dns_header header;
    unsigned char data;
};

struct __attribute__((__packed__)) dns_answer {
    // query in C-string format
    // need to use str_dns_convert() b4 sending
    //char *query;
    
    // type of record
    // see enum dns_record_type
    unsigned short type;
    
    // probably INternet
	unsigned short class;
    
    // TTL
	unsigned int ttl;
    
    // data length
	unsigned short data_len;
    // * data here *
};

// convert DNS-style string to c-string
char *dns_str_convert(void *in) {
    unsigned int length = 0;
    char *ptr = (char *)in;
    char *ret, *tmp;
    
    while (*ptr != 0) {
        length += *ptr + 1;
        ptr += *ptr + 1;
    }

    tmp = ret = calloc(length+1, sizeof(char));
    ptr = (unsigned char *)in;

    while (*ptr != 0) {
        memcpy(tmp, ptr+1, *ptr);
        tmp += *ptr;
        *(tmp++) = '.';
        ptr += *ptr + 1;
    }
    return ret;
}

// convert c-style string to dns-style string
void *str_dns_convert(unsigned char *in) {
    unsigned int length = strlen(in) + 1;
    unsigned char *ret, *tmp, *ptr, *dlo;

    tmp = ret = calloc(length, sizeof(char));
    ptr = (unsigned char *)in;

    while (*ptr != 0) {
        dlo = strchr(ptr, '.');

        if (dlo == NULL) {
            // does not end with a . (root)
            break;
        }

        *tmp = dlo-ptr;
        memcpy(++tmp, ptr, dlo-ptr);
        tmp += dlo-ptr;
        ptr += dlo-ptr+1;
    }

    return ret;
}

struct __attribute__((__packed__)) a_response {
    unsigned short name;
    unsigned short type;
    unsigned short class;
    unsigned int ttl;
    unsigned short dlen;
    unsigned int address;
};

#define endian_swap_32bit(num) ((num>>24)&0xff) | \
                    ((num<<8)&0xff0000) | \
                    ((num>>8)&0xff00) | \
                    ((num<<24)&0xff000000)

#define endian_swap_16bit(num) (num>>8) | (num<<8)

void make_response_bytes_for_ip(void *inptr, unsigned int ipaddr) {
    struct a_response *resp = (struct a_response *)inptr;
    resp->name = htons((unsigned short)0xc00c); // endian swapped already
    resp->type = htons((unsigned short)0x0001); // endian swapped already
    resp->class = htons((unsigned short)0x0001); // endian swapped already
    resp->ttl = htonl(0x0000012b); // not sure how to endian swap
    resp->dlen = htons((unsigned short)0x0004); // endian swapped
    resp->address = htonl(ipaddr); //
}

void hexDump (char *desc, void *addr, int len) {
    int i;
    unsigned char buff[17];
    unsigned char *pc = (unsigned char*)addr;

    // Output description if given.
    if (desc != NULL)
        printf ("%s:\n", desc);

    if (len == 0) {
        printf("  ZERO LENGTH\n");
        return;
    }
    if (len < 0) {
        printf("  NEGATIVE LENGTH: %i\n",len);
        return;
    }

    // Process every byte in the data.
    for (i = 0; i < len; i++) {
        // Multiple of 16 means new line (with line offset).

        if ((i % 16) == 0) {
            // Just don't print ASCII for the zeroth line.
            if (i != 0)
                printf ("  %s\n", buff);

            // Output the offset.
            printf ("  %04x ", i);
        }

        // Now the hex code for the specific character.
        printf (" %02x", pc[i]);

        // And store a printable ASCII character for later.
        if ((pc[i] < 0x20) || (pc[i] > 0x7e))
            buff[i % 16] = '.';
        else
            buff[i % 16] = pc[i];
        buff[(i % 16) + 1] = '\0';
    }

    // Pad out last line if not exactly 16 characters.
    while ((i % 16) != 0) {
        printf ("   ");
        i++;
    }

    // And print the final ASCII bit.
    printf ("  %s\n", buff);
}

/*
 * error - wrapper for perror
 */
void error(char *msg) {
  perror(msg);
  exit(1);
}

int main(int argc, char **argv) {
    int sockfd; /* socket */
    int portno; /* port to listen on */
    int clientlen; /* byte size of client's address */
    struct sockaddr_in serveraddr; /* server's addr */
    struct sockaddr_in clientaddr; /* client addr */
    struct hostent *hostp; /* client host info */
    unsigned char buf[BUFSIZE]; /* message buf */
    char *hostaddrp; /* dotted decimal host addr string */
    int optval; /* flag value for setsockopt */
    int n; /* message byte size */
    
    // self dns stuff
    struct dns_request *test;
    unsigned char *tmp;
    char *temp;
    unsigned short *code;
    int i, offset;
    
    /* 
    * check command line arguments 
    */
    if (argc != 2) {
        fprintf(stderr, "usage: %s <port>\n", argv[0]);
        exit(1);
    }
    
    portno = atoi(argv[1]);
    
    /* 
    * socket: create the parent socket 
    */
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0) error("ERROR opening socket");
    
    printf("socket open\n");
    
    /* setsockopt: Handy debugging trick that lets 
    * us rerun the server immediately after we kill it; 
    * otherwise we have to wait about 20 secs. 
    * Eliminates "ERROR on binding: Address already in use" error. 
    */
    optval = 1;
    setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR,
        (const void *)&optval , sizeof(int));
    
    /*
    * build the server's Internet address
    */
    bzero((char *) &serveraddr, sizeof(serveraddr));
    serveraddr.sin_family = AF_INET;
    serveraddr.sin_addr.s_addr = htonl(INADDR_ANY);
    serveraddr.sin_port = htons((unsigned short)portno);
    
    /* 
    * bind: associate the parent socket with a port 
    */
    if (bind(sockfd, (struct sockaddr *) &serveraddr, 
        sizeof(serveraddr)) < 0) 
        error("ERROR on binding");
    
    printf("bound socket to port\n");
    
    /* 
    * main loop: wait for a datagram, then echo it
    */
    printf("started listening!\n");
    clientlen = sizeof(clientaddr);
    while (1) {
        /*
        * recvfrom: receive a UDP datagram from a client
        */
        bzero(buf, BUFSIZE);
        n = recvfrom(sockfd, buf, BUFSIZE, 0,
            (struct sockaddr *) &clientaddr, &clientlen);
        printf("------------------\n");
        if (n < 0) error("ERROR in recvfrom");
        
        /* 
        * gethostbyaddr: determine who sent the datagram
        */
        hostp = gethostbyaddr((const char *)&clientaddr.sin_addr.s_addr, 
                sizeof(clientaddr.sin_addr.s_addr), AF_INET);
        
        hostaddrp = inet_ntoa(clientaddr.sin_addr);
        if (hostaddrp == NULL) error("ERROR on inet_ntoa\n");
        
        printf("server received %d byte datagram from %s\n", n, hostaddrp);
        hexDump("recv data", buf, n);
        
        test = (struct dns_request *)buf;
        (test->header).num_questions = ntohs((test->header).num_questions);
        (test->header).num_answers = ntohs((test->header).num_answers);
        
        printf("\tExtracted data: \n");
        printf("\t\tTransaction ID: %hu\n", (test->header).transaction_id);
        printf("\t\tNumber of questions: %hu\n", (test->header).num_questions);
        
        temp = NULL;
        tmp = &(test->data);
        
        for (i = 0; i < (test->header).num_questions; i++) {
            free(temp);
            
            if (tmp - buf > BUFSIZE) { // prevent buffer overflow
                printf("Advanced too much! Malformed packet or possible attack attempt.\n");
                break;
            }
            
            temp = dns_str_convert(tmp);
            printf("\t\tQuery #%d:\n", i+1);
            printf("\t\t\t%s\n", temp);
            offset = strlen(temp) + 1;
            
            code = (unsigned short *)((unsigned char *)tmp + offset);
            *code = ntohs(*code);
            
            printf("\t\t\tType: %s", code_to_str(*code));
            if (*code_to_str(*code) == 'U') printf(" (code %hu)", *code);
            
            tmp += offset + 2 + 2;
            
            puts("");
        }
        
        if (buf[2] & 0x80 || (test->header).num_answers > 0) {
            printf("Weirdly enough, this packet contains an answer.\nJumping out.");
            goto nextOne;
        }
        
        if ((*code == DNS_RECORD_A || *code == DNS_RECORD_ANY) && (test->header).num_questions == 1) {
            printf("Replying!\n");
            n = 16 + strlen(temp) + 1;
            
            // copy memory + response stub for A
            unsigned char *myNewBytes = calloc(n+sizeof(struct a_response), sizeof(unsigned char));
            test = (struct dns_request *)myNewBytes;
            
            // switch back to endian-swapped code
            *code = endian_swap_16bit(*code);
            
            // copy old stuff
            memcpy(myNewBytes, buf, n);
            
            // format the header
            (test->header).flags = htons(0x8000); // standard response, no error (endian-swapped) - don't recursively query
            // questions # is the same
            (test->header).num_answers = htons(0x0001);
            (test->header).num_questions = htons(0x0001);
            (test->header).num_authority = 0;
            (test->header).num_additional = 0;
            
            // throwin the ip response at the right spot
            make_response_bytes_for_ip(myNewBytes+n, 3111756784);
            
            // for ip response
            n += sizeof(struct a_response);
            
            // make_response_bytes_for_ip
            hexDump("send data", myNewBytes, n);
            
            n = sendto(sockfd, myNewBytes, n, 0, (struct sockaddr *) &clientaddr, clientlen);
            if (n < 0) printf("Failed to reply.\n");
            free(myNewBytes);
        } else {
            // send no answers
            printf("Replying Error!\n");
            
            // switch back to endian-swapped code
            *code = htons(*code); // 6. 33. 35. 38
            
            // format the header
            (test->header).flags = htons(0x8003); // standard response, not found error (endian-swapped) - don't recursively query
            // questions # is the same
            (test->header).num_answers = 0;
            (test->header).num_questions = htons(0x0001);
            (test->header).num_authority = 0;
            (test->header).num_additional = 0;
            
            // make_response_bytes_for_ip
            hexDump("send data", buf, n);
            
            n = sendto(sockfd, buf, n, 0, (struct sockaddr *) &clientaddr, clientlen);
            if (n < 0) printf("Failed to reply.\n");
        }
        
        nextOne:
        free(temp);
        temp = NULL;
        
        //n = sendto(sockfd, buf, strlen(buf), 0, (struct sockaddr *) &clientaddr, clientlen);
        // if (n < 0) error("ERROR in sendto");
    }
}
