# Ldap3 Issue 47

This is a minimal working example for the Rust crate `ldap3`'s
[issue 47](https://github.com/inejge/ldap3/issues/47).

* See the [`Cargo.lock`](Cargo.lock) for the exact dependencies used.
* See the [`rust-toolchain`](rust-toolchain) for the exact Rust version used.

The problem was exposed using macOS's Instruments and
[`cargo-instruments`](https://github.com/cmyr/cargo-instruments):

```sh
cargo instruments --limit 60000 --template Leaks --open
```

[![instruments](screenshot.png "Instruments")](screenshot.png)

## Dependency Tree

```sh
❯ cargo tree
ldap3-issue47 v0.1.0 (/Users/nbigaouette/codes/rust/ldap3-issue47)
├── ldap3 v0.7.0-alpha.7
│   ├── async-trait v0.1.31
│   │   ├── proc-macro2 v1.0.13
│   │   │   └── unicode-xid v0.2.0
│   │   ├── quote v1.0.6
│   │   │   └── proc-macro2 v1.0.13 (*)
│   │   └── syn v1.0.23
│   │       ├── proc-macro2 v1.0.13 (*)
│   │       ├── quote v1.0.6 (*)
│   │       └── unicode-xid v0.2.0 (*)
│   ├── bytes v0.5.4
│   ├── futures v0.3.5
│   │   ├── futures-channel v0.3.5
│   │   │   ├── futures-core v0.3.5
│   │   │   └── futures-sink v0.3.5
│   │   ├── futures-core v0.3.5 (*)
│   │   ├── futures-executor v0.3.5
│   │   │   ├── futures-core v0.3.5 (*)
│   │   │   ├── futures-task v0.3.5
│   │   │   │   └── once_cell v1.4.0
│   │   │   └── futures-util v0.3.5
│   │   │       ├── futures-channel v0.3.5 (*)
│   │   │       ├── futures-core v0.3.5 (*)
│   │   │       ├── futures-io v0.3.5
│   │   │       ├── futures-macro v0.3.5
│   │   │       │   ├── proc-macro-hack v0.5.15
│   │   │       │   ├── proc-macro2 v1.0.13 (*)
│   │   │       │   ├── quote v1.0.6 (*)
│   │   │       │   └── syn v1.0.23 (*)
│   │   │       ├── futures-sink v0.3.5 (*)
│   │   │       ├── futures-task v0.3.5 (*)
│   │   │       ├── memchr v2.3.3
│   │   │       ├── pin-project v0.4.17
│   │   │       │   └── pin-project-internal v0.4.17
│   │   │       │       ├── proc-macro2 v1.0.13 (*)
│   │   │       │       ├── quote v1.0.6 (*)
│   │   │       │       └── syn v1.0.23 (*)
│   │   │       ├── pin-utils v0.1.0
│   │   │       ├── proc-macro-hack v0.5.15 (*)
│   │   │       ├── proc-macro-nested v0.1.4
│   │   │       └── slab v0.4.2
│   │   ├── futures-io v0.3.5 (*)
│   │   ├── futures-sink v0.3.5 (*)
│   │   ├── futures-task v0.3.5 (*)
│   │   └── futures-util v0.3.5 (*)
│   │   [dev-dependencies]
│   │   └── futures-executor v0.3.5 (*)
│   ├── futures-util v0.3.5 (*)
│   ├── lazy_static v1.4.0
│   ├── lber v0.2.0
│   │   ├── byteorder v1.3.4
│   │   ├── bytes v0.5.4 (*)
│   │   └── nom v2.2.1
│   ├── log v0.4.8
│   │   └── cfg-if v0.1.10
│   ├── maplit v1.0.2
│   ├── native-tls v0.2.4
│   │   ├── lazy_static v1.4.0 (*)
│   │   ├── libc v0.2.70
│   │   ├── security-framework v0.4.4
│   │   │   ├── bitflags v1.2.1
│   │   │   ├── core-foundation v0.7.0
│   │   │   │   ├── core-foundation-sys v0.7.0
│   │   │   │   └── libc v0.2.70 (*)
│   │   │   ├── core-foundation-sys v0.7.0 (*)
│   │   │   ├── libc v0.2.70 (*)
│   │   │   └── security-framework-sys v0.4.3
│   │   │       ├── core-foundation-sys v0.7.0 (*)
│   │   │       └── libc v0.2.70 (*)
│   │   ├── security-framework-sys v0.4.3 (*)
│   │   └── tempfile v3.1.0
│   │       ├── cfg-if v0.1.10 (*)
│   │       ├── libc v0.2.70 (*)
│   │       ├── rand v0.7.3
│   │       │   ├── getrandom v0.1.14
│   │       │   │   ├── cfg-if v0.1.10 (*)
│   │       │   │   └── libc v0.2.70 (*)
│   │       │   ├── libc v0.2.70 (*)
│   │       │   ├── rand_chacha v0.2.2
│   │       │   │   ├── ppv-lite86 v0.2.8
│   │       │   │   └── rand_core v0.5.1
│   │       │   │       └── getrandom v0.1.14 (*)
│   │       │   └── rand_core v0.5.1 (*)
│   │       │   [dev-dependencies]
│   │       │   └── rand_hc v0.2.0
│   │       │       └── rand_core v0.5.1 (*)
│   │       └── remove_dir_all v0.5.2
│   ├── nom v2.2.1 (*)
│   ├── percent-encoding v2.1.0
│   ├── thiserror v1.0.18
│   │   └── thiserror-impl v1.0.18
│   │       ├── proc-macro2 v1.0.13 (*)
│   │       ├── quote v1.0.6 (*)
│   │       └── syn v1.0.23 (*)
│   ├── tokio v0.2.21
│   │   ├── bytes v0.5.4 (*)
│   │   ├── fnv v1.0.7
│   │   ├── futures-core v0.3.5 (*)
│   │   ├── iovec v0.1.4
│   │   │   └── libc v0.2.70 (*)
│   │   ├── lazy_static v1.4.0 (*)
│   │   ├── libc v0.2.70 (*)
│   │   ├── memchr v2.3.3 (*)
│   │   ├── mio v0.6.22
│   │   │   ├── cfg-if v0.1.10 (*)
│   │   │   ├── iovec v0.1.4 (*)
│   │   │   ├── libc v0.2.70 (*)
│   │   │   ├── log v0.4.8 (*)
│   │   │   ├── net2 v0.2.34
│   │   │   │   ├── cfg-if v0.1.10 (*)
│   │   │   │   └── libc v0.2.70 (*)
│   │   │   └── slab v0.4.2 (*)
│   │   ├── mio-uds v0.6.8
│   │   │   ├── iovec v0.1.4 (*)
│   │   │   ├── libc v0.2.70 (*)
│   │   │   └── mio v0.6.22 (*)
│   │   ├── pin-project-lite v0.1.5
│   │   ├── slab v0.4.2 (*)
│   │   └── tokio-macros v0.2.5
│   │       ├── proc-macro2 v1.0.13 (*)
│   │       ├── quote v1.0.6 (*)
│   │       └── syn v1.0.23 (*)
│   ├── tokio-tls v0.3.1
│   │   ├── native-tls v0.2.4 (*)
│   │   └── tokio v0.2.21 (*)
│   │   [dev-dependencies]
│   │   └── tokio v0.2.21 (*)
│   ├── tokio-util v0.3.1
│   │   ├── bytes v0.5.4 (*)
│   │   ├── futures-core v0.3.5 (*)
│   │   ├── futures-sink v0.3.5 (*)
│   │   ├── log v0.4.8 (*)
│   │   ├── pin-project-lite v0.1.5 (*)
│   │   └── tokio v0.2.21 (*)
│   │   [dev-dependencies]
│   │   └── tokio v0.2.21 (*)
│   └── url v2.1.1
│       ├── idna v0.2.0
│       │   ├── matches v0.1.8
│       │   ├── unicode-bidi v0.3.4
│       │   │   └── matches v0.1.8 (*)
│       │   └── unicode-normalization v0.1.12
│       │       └── smallvec v1.4.0
│       ├── matches v0.1.8 (*)
│       └── percent-encoding v2.1.0 (*)
└── tokio v0.2.21 (*)
```
