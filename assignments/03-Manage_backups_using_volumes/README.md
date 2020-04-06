# Manage backups using volumes

A container based on **mysql:latest** image, by default store the datafiles into the path **/var/lib/mysql**.

**Task 1)** Persist the MySQL datafiles in a **volume**

**Task 2)** Instantiate another container to mount the same volume as the MySQL one and, leveraging a **bind mount**, backup MySQL datafiles from the volume to your PC 
