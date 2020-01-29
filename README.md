
From Vixie's 2005 paper "Federated Domain Name Service Using DNS Metazones".

I couldn't find an implementation, and I've got a feeling the example zone is
missing the prefix.

The included `example.zone` (fetched over AXFR to localhost), should generate:

```
zone "vix.com" {
        type slave;
        file "sec/fh-sa.mz.vix.com/vix.com";
        masters {
                204.152.188.234;
                2001:4f8:2:0:0:0:0:9;
        };
        also-notify {
                204.152.184.64;
                2001:4f8:0:2:0:0:0:13;
        };
        allow-transfer {
                key fh-sa.tsig.vix.com;
                key ns-ext;
        };
};

zone "anog.net" {
        type slave;
        file "sec/fh-sa.mz.vix.com/anog.net";
        masters {
                204.152.188.234;
                2001:4f8:2:0:0:0:0:9;
        };
        also-notify {
                204.152.184.64;
                2001:4f8:0:2:0:0:0:13;
        };
        allow-transfer {
                key fh-sa.tsig.vix.com;
                key ns-ext;
        };
};

zone "anog.org" {
        type slave;
        file "sec/fh-sa.mz.vix.com/anog.org";
        masters {
                204.152.188.234;
                2001:4f8:2:0:0:0:0:9;
        };
        also-notify {
                204.152.184.64;
                2001:4f8:0:2:0:0:0:13;
        };
        allow-transfer {
                key fh-sa.tsig.vix.com;
                key ns-ext;
        };
};
```

