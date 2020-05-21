use std::{env, thread, time::Duration};

use ldap3::{LdapConn, LdapConnAsync, LdapConnSettings};

#[tokio::main]
async fn main() -> Result<(), ldap3::result::LdapError> {
    let url = env::var("LDAP3_ISSUE47_URL").unwrap();

    loop {
        println!("Establishing connection to {:?}...", url);

        let timeout = Duration::from_secs(5);
        let settings = LdapConnSettings::new()
            .set_conn_timeout(timeout)
            .set_no_tls_verify(true);

        // Sync
        // let conn = LdapConn::with_settings(settings, url.as_str()).unwrap();
        // Async
        let (conn, ldap) = match LdapConnAsync::with_settings(settings, url.as_str()).await {
            Ok((conn, ldap)) => (conn, ldap),
            Err(e) => return Err(e),
        };
        let handle = tokio::spawn(async move { conn.drive().await.unwrap() });
        // handle.await.unwrap();

        println!("    Connection established. Dropping.");

        std::mem::drop(ldap);

        tokio::time::delay_for(Duration::from_millis(100)).await;
    }
}
