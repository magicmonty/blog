title: Authentifizierung am AD mit CentOS 4
author: magicmonty
date: 2006-04-05 06:52
template: article.jade
category: Linux,Active Directory,CentOS,Authentication

Hier beschreibe ich, wie ich die Authentifizierung am Active Directory mit CentOS 4 hinbekommen habe.

Das folgende Howto habe ich mit Hilfe der Mini-Howtow’s von Mike Foley (unter http://www.yelof.com/pam-to-active-directory/index.html) und darkness (unter http://darkness.codefu.org/wordpress/2005/07/23/192) erstellt:

### Netzwerkbeschreibung

- Die Active Directory Domäne ist Domain.local
- Der Primary Domain Controller ist server.domain.local (192.168.0.1)
-  Netzwerk: 192.168.0.0/255.255.255.0
-  Linux-Distribution: CentOS 4.2

### Kerberos: /etc/krb5.conf:
    [logging]
    default = SYSLOG:NOTICE:DAEMON
    default = FILE:/var/log/krb5libs.log
    kdc = FILE:/var/log/krb5kdc.log
    admin_server = FILE:/var/log/kadmind.log
    
    [libdefaults]
    default_realm = DOMAIN.LOCAL
    default_etypes = des-cbc-crc des-cbc-md5
    default_etypes_des = des-cbc-crc des-cbc-md5
    dns_lookup_kdc = true
    clockskew = 300
    
    [realms]
    DOMAIN.LOCAL = {
        kdc = server.domain.local
    }
    
    [domain_realm]
    .domain.local = DOMAIN.LOCAL
    domain.local = DOMAIN.LOCAL
    .Domain.local = DOMAIN.LOCAL
    Domain.local = DOMAIN.LOCAL
    .Domain.Local = DOMAIN.LOCAL
    Domain.Local = DOMAIN.LOCAL
    .domain.Local = DOMAIN.LOCAL
    domain.Local = DOMAIN.LOCAL
    
    [kdc]
    profile = /var/kerberos/krb5kdc/kdc.conf
    
    [appdefaults]
    pam = {
        debug = false
        ticket_lifetime = 1d
        renew_lifetime = 1d
        forwardable = true
        proxiable = false
        retain_after_close = false
        minimum_uid = 0
        krb4_convert = false
    }

### /etc/nscd.conf:
    server-user             nscd
    debug-level             0
    paranoia                no
    
    enable-cache            passwd          yes
    positive-time-to-live   passwd          600
    negative-time-to-live   passwd          20
    suggested-size          passwd          211
    check-files             passwd          yes
    persistent              passwd          yes
    shared                  passwd          yes
    enable-cache            group           yes
    positive-time-to-live   group           3600
    negative-time-to-live   group           60
    suggested-size          group           211
    check-files             group           yes
    persistent              group           yes
    shared                  group           yes
    
    enable-cache            hosts           yes
    positive-time-to-live   hosts           3600
    negative-time-to-live   hosts           20
    suggested-size          hosts           211
    check-files             hosts           yes
    persistent              hosts           yes
    shared                  hosts           yes

Neues Verzeichnis anlegen (Benutzerverzeichnisse für die AD Domain):

* `mkdir /home/DOMAIN`
* `chmod 755 /home/DOMAIN`

Kerberos testen:

* `kinit Administrator@DOMAIN.LOCAL`
* Das sollte fehlerfrei durchlaufen
* beim Aufruf von `klist` sollte das entsprechende Ticket zu sehen sein

### Samba / Winbind: /etc/samba/smb.conf:
    [global]
        log file = /var/log/samba/%m.log
        load printers = yes
        idmap gid = 16777216-33554431
        idmap uid = 16777216-33554431
        socket options = TCP_NODELAY SO_RCVBUF=8192 SO_SNDBUF=8192
        client use spnego = yes
        encrypt passwords = yes
        realm = DOMAIN.LOCAL
        winbind use default domain = yes
        template shell = /bin/bash
        allow hosts = 192.168.0.0/255.255.255.0
        dns proxy = no
        writeable = yes
        printing = cups
        server string = Samba Server
        password server = server.domain.local
        template homedir = /home/%D/%U
        workgroup = DOMAIN
        valid users = @Domänen-Admins,@Domänen-Benutzer
        printcap name = /etc/printcap
        security = ads
        max log size = 50
        
    [Share1]
        path = /srv/share1
        writeable = yes
        valid users = @Domänen-Admins,@Domänen-Benutzer
        
    [Share2]
        path = /srv/share2
        writeable = yes
        valid users = @Domänen-Benutzer

smb und winbind neustarten:

* `/sbin/service smb restart`
* `/sbin/service winbind restart`

smb und winbind in die Start-Konfiguration eintragen:

* `/sbin/chkconfig –level 345 smb on`
* `/sbin/chkconfig –level 345 winbind on`

### /etc/nsswitch.conf
    passwd:     files winbind
    shadow:     files winbind
    group:      files winbind
    hosts:      files dns
    bootparams: nisplus [NOTFOUND=return] files
    ethers:     files
    netmasks:   files
    networks:   files
    protocols:  files winbind
    rpc:        files
    services:   files winbind
    netgroup:   files winbind
    publickey:  nisplus
    automount:  files
    aliases:    files nisplus

Samba zur Domain joinen: `net ads join -U administrator`

Neustart, dann test, ob die entsprechenden Werte ankommen:

* `wbinfo -u` (sollte alle AD-Benutzer anzeigen)
* `wbinfo -g` (sollte alle AD-Gruppen anzeigen)
* `getent passwd` (sollte sowohl die lokalen als auch die AD-Benutzer anzeigen)
* `getent group` (sollte sowohl die lokalen als auch die AD-Gruppen anzeigen)

PAM (vorher von den entsprechenden Dateien ein Backup machen und eine Konsole auflassen)

### /etc/pam.d/login
    #%PAM-1.0auth       required     pam_securetty.soauth       required     pam_stack.so service=system-authauth       required     pam_nologin.soaccount    required     pam_stack.so service=system-authpassword   required     pam_stack.so service=system-authsession    required     pam_stack.so service=system-authsession    optional     pam_console.sosession    required     pam_mkhomedir.so skel=/etc/skel/ umask=0077

### /etc/pam.d/gdm
    #%PAM-1.0
    auth       required     pam_env.so
    auth       required     pam_stack.so service=system-auth
    auth       required     pam_nologin.so
    account    required     pam_stack.so service=system-auth
    password   required     pam_stack.so service=system-auth
    session    required     pam_stack.so service=system-auth
    session    optional     pam_console.so
    session    required     pam_mkhomedir.so skel=/etc/skel/ umask=0077

### /etc/pam.d/system-auth
    #%PAM-1.0
    # This file is auto-generated.
    # User changes will be destroyed the next time authconfig is run.
    auth        required      /lib/security/$ISA/pam_env.so
    auth        sufficient    /lib/security/$ISA/pam_unix.so likeauth nullok
    auth        sufficient    /lib/security/$ISA/pam_winbind.so use_first_pass
    auth        required      /lib/security/$ISA/pam_deny.so
    
    account     sufficient    /lib/security/$ISA/pam_succeed_if.so uid < 100
    account     required      /lib/security/$ISA/pam_unix.so
    account     [default=bad success=ok user_unknown=ignore] /lib/security/$ISA/pam_winbind.so
    
    password    requisite     /lib/security/$ISA/pam_cracklib.so retry=3
    password    sufficient    /lib/security/$ISA/pam_unix.so nullok use_authtok md5 shadow
    password    sufficient    /lib/security/$ISA/pam_winbind.so use_authok
    password    required      /lib/security/$ISA/pam_deny.so
    
    session     required      /lib/security/$ISA/pam_limits.so
    session     required      /lib/security/$ISA/pam_unix.so
    session     optional      /lib/security/$ISA/pam_mkhomedir.so

Auf einer anderen Konsole testen, ob ein Login mit einem AD-Benutzer möglich ist (entweder per DOMAIN\Benutzername oder nur per Benutzername)

* es sollte automatisch unter `/home/DOMAIN/` ein Benutzerverzeichnis angelegt werden
* Hinweis: Bei Benutzernamen mit Leerzeichen hat Linux Probleme, also wenn Vor- und Nachname als Benutzername gewünscht sind, am Besten mit einem Punkt (Vorname.Nachname) oder einem Unterstrich (Vorname_Nachname) trennen.

__Wenn das Login funktioniert (!!!)__ (auch von Lokalen Benutzern, insbesondere root)

* Neustart, damit auch der GDM die neue PAM-Konfiguration lesen kann

Danach sollte die Authentifizierung per AD problemlos laufen ;-)