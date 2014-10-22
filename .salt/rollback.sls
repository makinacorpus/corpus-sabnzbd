


corpus-sabnzbd-rollback-faileproject-dir:
  cmd.run:
    - name: |
            if [ -d "/srv/projects/corpus-sabnzbd/archives/2014-10-22_21_41-18_60d787a6-6558-4946-9293-fd2ccaa5e1cd/project" ];then
              rsync -Aa --delete "/srv/projects/corpus-sabnzbd/project/" "/srv/projects/corpus-sabnzbd/archives/2014-10-22_21_41-18_60d787a6-6558-4946-9293-fd2ccaa5e1cd/project.failed/"
            fi;
    - user: corpus-sabnzbd-user

corpus-sabnzbd-rollback-project-dir:
  cmd.run:
    - name: |
            if [ -d "/srv/projects/corpus-sabnzbd/archives/2014-10-22_21_41-18_60d787a6-6558-4946-9293-fd2ccaa5e1cd/project" ];then
              rsync -Aa --delete "/srv/projects/corpus-sabnzbd/archives/2014-10-22_21_41-18_60d787a6-6558-4946-9293-fd2ccaa5e1cd/project/" "/srv/projects/corpus-sabnzbd/project/"
            fi;
    - user: corpus-sabnzbd-user
    - require:
      - cmd:  corpus-sabnzbd-rollback-faileproject-dir
