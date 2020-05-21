use std::{env, thread, time::Duration};

use ldap3::{LdapConn, LdapConnSettings};

fn main() {
    let url = env::var("LDAP3_ISSUE47_URL").unwrap();
    let bind_dn = env::var("LDAP3_ISSUE47_BIND_DN").unwrap();
    let bind_pw = env::var("LDAP3_ISSUE47_BIND_PW").unwrap();

    loop {
        println!("Establishing connection to {:?}...", url);

        let timeout = Duration::from_secs(5);
        let settings = LdapConnSettings::new()
            .set_conn_timeout(timeout)
            .set_no_tls_verify(true);

        let mut conn = LdapConn::with_settings(settings, url.as_str()).unwrap();
        println!("    Binding using {:?}...", bind_dn);
        let bind = conn.simple_bind(&bind_dn, &bind_pw).unwrap();

        println!("    Connection established. Dropping.");

        std::mem::drop(bind);
        std::mem::drop(conn);

        thread::sleep(Duration::from_millis(500));
    }
}
