use std::{env, thread, time::Duration};

use ldap3::{LdapConn, LdapConnSettings};

fn main() {
    let url = env::var("LDAP3_ISSUE47_URL").unwrap();

    loop {
        println!("Establishing connection to {:?}...", url);

        let timeout = Duration::from_secs(5);
        let settings = LdapConnSettings::new()
            .set_conn_timeout(timeout)
            .set_no_tls_verify(true);

        let conn = LdapConn::with_settings(settings, url.as_str()).unwrap();

        println!("    Connection established. Dropping.");

        std::mem::drop(conn);

        thread::sleep(Duration::from_millis(100));
    }
}
