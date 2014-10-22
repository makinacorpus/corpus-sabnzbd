{% set cfg = opts['ms_project'] %}
{% set data = cfg.data %}
{% set scfg = salt['mc_utils.json_dump'](cfg) %}


{% set pkgssettings = salt['mc_pkgs.settings']() %}
{% if grains['os_family'] in ['Debian'] %}
{% set dist = pkgssettings.udist %}
{% endif %}
{% if grains['os'] in ['Debian'] %}
{% set dist = pkgssettings.ubuntu_lts %}
{% endif %}
install-sabznbd:  
  pkgrepo.managed:
    - humanname:  sabppa
    - name: deb http://ppa.launchpad.net/jcfp/ppa/ubuntu {{dist}} main
    - dist: {{dist}}
    - file: /etc/apt/sources.list.d/sabnzbd.list
    - keyid: "0x98703123E0F52B2BE16D586EF13930B14BB9F05F"
    - keyserver: keyserver.ubuntu.com
  pkg.installed:
    - pkgs: [sabnzbdplus, sabnzbdplus-theme-smpl]
    - watch:
      - pkgrepo: install-sabznbd

dirs3:
  file.directory:
    - makedirs: true
    - watch:
      - pkg: install-sabznbd
    - names:
      - {{data.complete}}
      - {{data.incomplete}}
      - {{data.dirscan}}
      - {{data.nzbds}}
      - {{data.admind}}
      - {{data.cache}}
      - {{data.logs}}

config2:
  file.managed:
    - makedirs: true
    - source: salt://makina-projects/{{cfg.name}}/files/sabnzbd.ini
    - name: /etc/sabnzbd.ini
    - template: jinja
    - mode: 660
    - user: sabnzbd
    - group: "root"
    - watch:
      - pkg: install-sabznbd
    - defaults:
        cfg: |
             {{scfg}}

config1:
  file.managed:
    - makedirs: true
    - source: salt://makina-projects/{{cfg.name}}/files/default
    - name: /etc/default/sabnzbdplus
    - template: jinja
    - mode: 660
    - user: sabnzbd
    - group: "root"
    - watch:
      - pkg: install-sabznbd

    - defaults:
        cfg: |
             {{scfg}}

sy1:
  file.symlink:
    - makedirs: true
    - name: /var/lib/sabnzbd/downloads/complete
    - watch:
      - pkg: install-sabznbd
    - target: {{data.complete}}

sy3:
  file.symlink:
    - makedirs: true
    - name: /var/lib/sabnzbd/downloads/dirscan
    - target: {{data.dirscan}}
    - watch:
      - pkg: install-sabznbd

sy2:
  file.symlink:
    - makedirs: true
    - name: /var/lib/sabnzbd/downloads/incomplete
    - target: {{data.incomplete}}
    - watch:
      - pkg: install-sabznbd

sabnzbd:
  user.present:
    - home: /var/lib/sabnzbd

config:
  service.running:
    - name: sabnzbdplus
    - enable: True
    - reload: True
    - watch:
      - pkg: install-sabznbd
      - user: sabnzbd
      - file: sy1
      - file: sy2
      - file: sy3
      - file: dirs3
      - file: config1
      - file: config2


{% import "makina-states/services/http/nginx/init.sls" as nginx %}
include:
  - makina-states.services.http.nginx

# inconditionnaly reboot circus & nginx upon deployments
/bin/true:
  cmd.run:
    - watch_in:
      - mc_proxy: nginx-pre-conf-hook

{{ nginx.virtualhost(domain=cfg.fqdn, doc_root=cfg.data_root,
                     server_aliases=data.server_aliases,
                     vh_content_source=data.nginx_vhost,
                     cfg=cfg)}}
