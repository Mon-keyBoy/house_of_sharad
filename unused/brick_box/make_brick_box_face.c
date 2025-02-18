#include <sys/param.h>
#include <sys/module.h>
#include <sys/kernel.h>
#include <sys/socketvar.h>
#include <sys/protosw.h>
#include <sys/systm.h>
#include <sys/types.h>
#include <sys/mbuf.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/ip.h>
#include <netinet/tcp.h>
#include <sys/proc.h>
#include <sys/sysent.h>
#include <sys/sysproto.h>
#include <sys/exec.h>
#include <net/pfil.h>
#include <netinet/ip_var.h>
#include <net/if.h>
#include <sys/syslog.h>


static pfil_head_t g_ph    = NULL;
static pfil_hook_t g_hook  = NULL;

static pfil_return_t my_packet_filter(struct mbuf **mp, struct ifnet *ifp, int dir, void *arg, struct inpcb *inp) {

    printf("          .- \"\"\"\"\"\"\"\" -.\n");
    printf("       .'                '.\n");
    printf("     .'                    '.\n");
    printf("    /       \\\\      //       \\\n");
    printf("   |         \\\\    //         |\n");
    printf("   |        ( .)   ( .)       |\n");
    printf("   |                          |\n");
    printf("   |                          |\n");
    printf("   |    \\                     |\n");
    printf("   |     \\  /\\  /\\  /\\  /     |\n");
    printf("    \\     \\/  \\/  \\/  \\/     /\n"); 
    printf("     '.                    .'\n");
    printf("       '.                .'\n");
    printf("         '-.__________.-'\n\n");
    printf("ChatGPT iS in yOuR'e WaLLs!!!\n");

    return PFIL_PASS;

}
        

static int get_pfil_head(void) {
    g_ph = V_inet_pfil_head;

    if (g_ph == NULL) {
        printf("[LKM] Failed to get existing IPv4 pfil_head\n");
        return (ENOENT);
    }

    return (0);

}


static int load_hook(void) {

    struct pfil_hook_args ha = {
        .pa_version = PFIL_VERSION,         // Version of the pfil framework
        .pa_flags = 0,                       /* Not specifying PFIL_IN/PFIL_OUT here */
        .pa_type = PFIL_TYPE_IP4,            // Type of filter (address family)
        .pa_mbuf_chk = my_packet_filter,       // Function to process packets
        .pa_mem_chk = NULL,                 // No memory-based checks (set to NULL if unused)
        .pa_ruleset = NULL,                 // No custom ruleset (set to NULL if unused)
        .pa_modname = "apeshit filtering",          // Module name
        .pa_rulname = "apeshit 6969 packet"             // Rule name
    };

    // pfil_hook_t	pfil_add_hook(struct pfil_hook_args *);
    g_hook = pfil_add_hook(&ha);

    if (g_hook == NULL) {
        // Handle error
        printf("mannnn that shit aint work");
        return (ENOMEM);
    }

    printf("[LKM] Packet filter module loaded\n");
    return 0;
}

static int load_link(void) {

    struct pfil_link_args la = {
        .pa_version = PFIL_VERSION,
        .pa_flags   = PFIL_IN | PFIL_OUT | PFIL_HEADPTR | PFIL_HOOKPTR,
        .pa_head    = g_ph,
        .pa_hook    = g_hook,
    };

    int err = pfil_link(&la);
    if (err != 0) {
        printf("[LKM] pfil_link failed: %d\n", err);
        return err;
    }
    printf("[LKM] pfil_link success for inbound packets\n");
    return 0;
}

static void unload(void) {
    if (g_hook) {
        pfil_remove_hook(g_hook);
        g_hook = NULL;
        printf("[LKM] pfil_hook removed\n");
    }
}



static int event_handler(struct module *module, int event, void *arg) {
    switch (event) {
        case MOD_LOAD:
            get_pfil_head();
            load_hook();
            load_link();
            return 0;
        case MOD_UNLOAD:
            unload();
            printf("[LKM] Module unloaded.\n");
            return 0;
        default:
            return EOPNOTSUPP;
    }
}


static moduledata_t module_data = {
    "apekit_rootshit",
    event_handler,
    NULL
};


DECLARE_MODULE(reverse_shell_lkm, module_data, SI_SUB_DRIVERS, SI_ORDER_MIDDLE);