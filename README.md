# glusterfs-tools
GlusterFS management tools

usage
=====
rm-gluster-file.sh 
-----
    Description:
    	remove files in glusterfs server
    Usage:
    	./rm-gluster-file.sh FILE               # remove file and it's gfid file
    	./rm-gluster-file.sh -h or --help       # show this help info
    Note:
    	make sure current directory is brick directory

gfid-to-path.sh 
-----
    Usage:
    	gfid-to-path.sh BRICK_DIR GFID_FILE
    Note:
    	This command will find original file by GFID file
    
    	BRICK_DIR: glusterfs volume's brick path
    	GFID_FILE: gfid file path
