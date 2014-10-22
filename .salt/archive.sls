

corpus-sabnzbd-sav-project-dir:
  cmd.run:
    - name: |
            if [ ! -d "/srv/projects/corpus-sabnzbd/archives/2014-10-22_21_41-18_60d787a6-6558-4946-9293-fd2ccaa5e1cd/project" ];then
              mkdir -p "/srv/projects/corpus-sabnzbd/archives/2014-10-22_21_41-18_60d787a6-6558-4946-9293-fd2ccaa5e1cd/project";
            fi;
            rsync -Aa --delete "/srv/projects/corpus-sabnzbd/project/" "/srv/projects/corpus-sabnzbd/archives/2014-10-22_21_41-18_60d787a6-6558-4946-9293-fd2ccaa5e1cd/project/"
    - user: root
