/* ping flooder for use with https://jinglepings.com */
/* ohnx was here (2018) */
/* compile with gcc -Wall -Werror color-flood.c -o color-flood */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <stdint.h>
#include <sys/types.h>
#include <arpa/inet.h>
#include <ifaddrs.h>

void color2ip(char *rgb_hex, struct in6_addr *addr) {
    /* this is the ip to use for 2018 - see https://jinglepings.com */
    char ip[] = {'2','0','0','1',':','4','c','0','8',':','2','0','2','8',':','2','0','1','9',':',':','0','0',':','0','0',':','0','0',0x0};
    char buf[INET6_ADDRSTRLEN];
    size_t len = strlen(rgb_hex);
    int rc;

    /* check if length valid */
    switch (len) {
    case 3:
        ip[21] = rgb_hex[0];
        ip[22] = rgb_hex[0];
        ip[24] = rgb_hex[1];
        ip[25] = rgb_hex[1];
        ip[27] = rgb_hex[2];
        ip[28] = rgb_hex[2];
        break;
    case 6:
        ip[21] = rgb_hex[0];
        ip[22] = rgb_hex[1];
        ip[24] = rgb_hex[2];
        ip[25] = rgb_hex[3];
        ip[27] = rgb_hex[4];
        ip[28] = rgb_hex[5];
        break;
    default:
        goto die;
    }

    /* ensure all valid characters */
    if (strspn(rgb_hex, "0123456789abcdefABCDEF") != len) goto die;

    /* convert string to ipv6 */
    rc = inet_pton(AF_INET6, ip, addr);
    if (rc != 1) goto die;
    inet_ntop(AF_INET6, addr, buf, INET6_ADDRSTRLEN);
    fprintf(stderr, "sending data to `%s`\n", buf);
    return;

die:
    fprintf(stderr, "Invalid hex color given!\n");
    exit(__LINE__);
}

void get_own_ip(struct in6_addr *ip) {
    struct ifaddrs *ifa, *tmp;
    struct sockaddr_in6 *addr = NULL;
    char buf[INET6_ADDRSTRLEN];

    /* get if addresses first */
    if (getifaddrs(&ifa)) {
        perror("failed to find local ipv6 address");
        exit(__LINE__);
    }

    /* loop through all if addresses */
    tmp = ifa;
    while (tmp) {
        if ((tmp->ifa_addr) && (tmp->ifa_addr->sa_family == AF_INET6)) {
            addr = (struct sockaddr_in6 *) tmp->ifa_addr;
            /* check if this is a valid ip address */
            switch (addr->sin6_addr.s6_addr[0]) {
            case 0x00:
            case 0xFC:
            case 0xFD:
            case 0xFE:
            case 0xFF:
                /* invalid ipv6 address */
                addr = NULL;
                goto loop_continue;
            default:
                /* i know there are other cases, but the above covers most */
                *ip = addr->sin6_addr;
                inet_ntop(AF_INET6, ip, buf, INET6_ADDRSTRLEN);
                fprintf(stderr, "sending from ip address %s from %s\n", buf, tmp->ifa_name);
                goto done;
            }
        }
    loop_continue:
        tmp = tmp->ifa_next;
    }

done:
    freeifaddrs(ifa);

    if (!addr) {
        fprintf(stderr, "no valid external ipv6 addresses found on this system.\n");
        exit(__LINE__);
    }
}

#define die(x) do {err_msg = x; goto die;} while(0);
int open_raw_socket() {
    int fd, flg, rc;
    const char *err_msg = NULL;

    /* initial values */
    flg = 1;

    /* create socket */
    fd = socket(AF_INET6, SOCK_RAW, IPPROTO_RAW);
    if (fd < 0) die("failed to create socket");

    /* set option "we will provide IP headers" */
    rc = setsockopt(fd, IPPROTO_IPV6, IP_HDRINCL, (const char *)&flg, sizeof(flg));
	if (rc < 0) die("failed to use raw ip headers");

    /* allow us to broadcast things *//*
    rc = setsockopt(fd, SOL_SOCKET, SO_BROADCAST, (const char *)&flg, sizeof(flg));
	if (rc < 0) die("failed to allow broadcasting");*/

    return fd;

die:
    if (err_msg)
        perror(err_msg);
    if (geteuid() != 0) {
        fprintf(stderr, "Hint: you probably need root to run this program.\n");
    }

    exit(__LINE__);
}
#undef die

void print_usage(char *prgrm) {
    fprintf(stderr, "Usage: %s [x?] [y?] [color in hex form]\n", prgrm);
    fprintf(stderr, "e.g. %s FFFFFF\n", prgrm);
    fprintf(stderr, "     %s 10 10 FFFFFF\n", prgrm);
}

/* yes, i know netinet exists... it's just easier to do it this way. */
struct ipv6_header {
    uint32_t combined;/*
    unsigned int
        version : 4,
        traffic_class_ds : 6,
        traffic_class_ecn : 2,
        flow_label : 20;*/
    uint16_t length;
    uint8_t next_header;
    uint8_t hop_limit;
    struct in6_addr src;
    struct in6_addr dst;
} __attribute__((packed));

/* used for checksum calculation */
struct ipv6_pseudoheader {
    struct in6_addr src;
    struct in6_addr dst;
    uint16_t length;
    unsigned int zeroes :24;
    uint8_t next_header;
} __attribute__((packed));

struct icmpv6_header {
    uint8_t type;
    uint8_t code;
    uint16_t checksum;
} __attribute__((packed));

struct icmpv6_echo_request {
    uint16_t identifier;
    uint16_t seqnum;
} __attribute__((packed));

uint32_t icmpv6_calc_checksum(unsigned char *x, size_t n) {
   uint32_t   sum;
   uint16_t * ptr;
   int        words;

   sum = 0;
   ptr   = (uint16_t *) x;
   words = (n + 1) / 2; // +1 & truncation on / handles any odd byte at end

   /*
    *   As we're using a 32 bit int to calculate 16 bit checksum
    *   we can accumulate carries in top half of DWORD and fold them in later
    */
   while (words--) sum += *ptr++;

   /*
    *   Fold in any carries
    *   - the addition may cause another carry so we loop
    */
   while (sum & 0xffff0000) sum = (sum >> 16) + (sum & 0xffff);

   return ~((uint16_t)sum);
}

int main(int argc, char **argv) {
    struct in6_addr src_addr;
    struct sockaddr_in6 dest_addr;
    int fd, rc;
    size_t packet_len, checksum_len, n;
    unsigned char *packet, *checksum;
    struct ipv6_header *ip_header;
    struct ipv6_pseudoheader *ip_pseudoheader;
    struct icmpv6_header *icmp_header, *icmp_pseudoheader;
    struct icmpv6_echo_request *icmp_payload, *icmp_pseudopayload;

    /* clear initial value */
    memset(&dest_addr, 0, sizeof(dest_addr));

    /* check usage */
    switch (argc) {
    case 2:
        /* convert the hex color to the correct ip */
        color2ip(argv[1], &(dest_addr.sin6_addr));
        break;
    case 4:
        fprintf(stderr, "nyi\n");
        exit(__LINE__);
        break;
    default:
        print_usage(argv[0]);
        exit(__LINE__);
    }

    /* fetch own IP */
    get_own_ip(&src_addr);

    /* create the socket */
    fd = open_raw_socket();

    /* allocate space for the packet */
    packet_len = sizeof(struct ipv6_header) + sizeof(struct icmpv6_header) + sizeof(struct icmpv6_echo_request);
    packet = malloc(packet_len);
    checksum_len = sizeof(struct ipv6_pseudoheader) + sizeof(struct icmpv6_header) + sizeof(struct icmpv6_echo_request);
    checksum = malloc(checksum_len);
    if (!packet || !checksum) {
        fprintf(stderr, "out of memory error");
        close(fd);
        free(packet);
        free(checksum);
        exit(__LINE__);
    }
    memset(packet, 0, packet_len);
    memset(checksum, 0, checksum_len);

    /* set the correct struct pointers */
    ip_header = (struct ipv6_header *)packet;
    ip_pseudoheader = (struct ipv6_pseudoheader *)checksum;
    icmp_header = (struct icmpv6_header *)(ip_header + 1);
    icmp_pseudoheader = (struct icmpv6_header *)(ip_pseudoheader + 1);
    icmp_payload = (struct icmpv6_echo_request *)(icmp_header + 1);
    icmp_pseudopayload = (struct icmpv6_echo_request *)(icmp_pseudoheader + 1);

    /* set the values for the ipv6 header */
#if 0
    ip_header->version = 0b0110; /* 6 */
    ip_header->traffic_class_ds = 0b000000; /* best effort */
    ip_header->traffic_class_ecn = 0b00; /* Non-ECN */
    ip_header->flow_label = 0xbeef4; /* idk, it's random */
#else
    /* TODO: fix this */
    ip_header->combined = htonl(0x600beef4);
#endif
    ip_header->length = htons(sizeof(struct icmpv6_header) + sizeof(struct icmpv6_echo_request)); /* need to convert to network byte order of icmpv6 header */
    ip_header->next_header = 0x3A; /* 0x3A = 58 = ICMPv6 */
    ip_header->hop_limit = 0xFF; /* 0xFF = max hop length (TTL) */
    ip_header->src = src_addr;
    ip_header->dst = dest_addr.sin6_addr;

    /* set values for the ipv6 pseudoheader */
    ip_pseudoheader->src = ip_header->src;
    ip_pseudoheader->dst = ip_header->dst;
    ip_pseudoheader->length = htons(sizeof(struct ipv6_header)); /* Upper-Layer Packet Length */
    /* (leave zeroes the way they are) */
    ip_pseudoheader->next_header = ip_header->next_header;

    /* set values for the icmpv6 header */
    /* see https://tools.ietf.org/html/rfc4443#section-4.1 */
    icmp_header->type = 128; /* type = 128 */
    icmp_header->code = 0; /* code = 0 */
    /* hold off on checksum calculation for now */

    /* set values for icmpv6 ping data */
    icmp_payload->identifier = 0xefbe; /* idk, it's random */

    n = 0;
    do {
        /* set values for icmpv6 ping data */
        icmp_payload->seqnum = htons(n & 0xFFFF); /* idk, it's random */

        /* ok, now calculate checksum */
        icmp_header->checksum = 0;
        *icmp_pseudoheader = *icmp_header;
        *icmp_pseudopayload = *icmp_payload;
        icmp_header->checksum = icmpv6_calc_checksum(checksum, checksum_len); /* htons is not necessary since the checksum function does it already */

        /* done, we have a fully formed packet! time to send it... */
        rc = sendto(fd, packet, packet_len, 0, (struct sockaddr *)(&dest_addr), sizeof(dest_addr));
        if (rc != packet_len) {
            perror("error sending packet");
        }

        /* don't spam too much */
        usleep(100000);
        if (!(n++ % 100)) fprintf(stderr, "%lu pings sent!\n", n-1);
    } while (1);

    /* done */
    close(fd);
    free(packet);
    free(checksum);

    return 0;
}
