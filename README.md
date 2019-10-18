# spike-rpm-versioning

## Demonstrate

### Clone repository

For more information on environment variables,
see [Environment Variables](https://github.com/Senzing/knowledge-base/blob/master/lists/environment-variables.md).

1. Set these environment variable values:

    ```console
    export GIT_ACCOUNT=docktermj
    export GIT_REPOSITORY=spike-rpm-versioning
    export GIT_ACCOUNT_DIR=~/${GIT_ACCOUNT}.git
    export GIT_REPOSITORY_DIR="${GIT_ACCOUNT_DIR}/${GIT_REPOSITORY}"
    ```

1. Follow steps in [clone-repository](https://github.com/docktermj/KnowledgeBase/blob/master/HowTo/clone-repository.md) to install the Git repository.

### Build packages

1. xxx

    ```console
    cd ${GIT_REPOSITORY_DIR}
    sudo make clean
    ```

1. xxx

    ```console
    cd ${GIT_REPOSITORY_DIR}
    make build
    ```

### docker formation

1. Identify location of package files.

    ```console
    export RPM_REPO_DIR=${GIT_REPOSITORY_DIR}/target/rpm
    export DEB_REPO_DIR=${GIT_REPOSITORY_DIR}/target/deb
    ```

1. Bring up docker formation.

    ```console
    cd ${GIT_REPOSITORY_DIR}
    sudo \
      RPM_REPO_DIR=${RPM_REPO_DIR} \
      DEB_REPO_DIR=${DEB_REPO_DIR} \
      docker-compose up
    ```

### yum

**Note:** This is the same demonstration as [apt](#apt)
but using `yum`.

1. In a new terminal window, shell into the centos image

    ```console
    sudo docker exec -it spike-centos /bin/bash
    ```

1. Add system packages.

    ```console
    yum install -y tree
    ```

1. Add the yum repository.

    ```console
    yum-config-manager --add-repo=http://spike-yum-repo
    yum --disablerepo="*" --enablerepo="spike-yum-repo" update
    yum --disablerepo="*" --enablerepo="spike-yum-repo" list available --showduplicates
    ```

1. Show that there is nothing in `/opt`.

    ```console
    $ tree /opt
    /opt

    0 directories, 0 files
    ```

1. Install `xyzzy-2.0` at patch level `0`.

    ```console
    yum install --nogpgcheck -y xyzzy-2.0-0
    ```

1. Verify installation of `2.0.0.txt`.

    ```console
    $ tree /opt
    /opt
    `-- xyzzy
        `-- xyzzy-2.0
            `-- data
                `-- 2.0.0.txt

    3 directories, 1 file
    ```

1. Install `xyzzy-2.1` at patch level `1`.

    ```console
    yum install --nogpgcheck -y xyzzy-2.1-1
    ```

1. Verify addition of `xyzzy-2.1` directory.

    ```console
    $ tree /opt
    /opt
    `-- xyzzy
        |-- xyzzy-2.0
        |   `-- data
        |       `-- 2.0.0.txt
        `-- xyzzy-2.1
            `-- data
                `-- 2.1.1.txt

    5 directories, 2 files
    ```

1. Install `xyzzy-2.1` at latest level.

    ```console
    yum install --nogpgcheck -y xyzzy-2.2
    ```

1. Verify addition of `xyzzy-2.2` directory.

    ```console
    $ tree /opt
    /opt
    `-- xyzzy
        |-- xyzzy-2.0
        |   `-- data
        |       `-- 2.0.0.txt
        |-- xyzzy-2.1
        |   `-- data
        |       `-- 2.1.1.txt
        `-- xyzzy-2.2
            `-- data
                `-- 2.2.2.txt
    ```

1. Update `xyzzy-2.0` from patch `0` to latest.

    ```console
    yum install --nogpgcheck -y xyzzy-2.0
    ```

1. Notice that `2.0.2.txt` exists and `2.0.0.txt` is gone.

    ```console
    $ tree /opt
    /opt
    `-- xyzzy
        |-- xyzzy-2.0
        |   `-- data
        |       `-- 2.0.2.txt
        |-- xyzzy-2.1
        |   `-- data
        |       `-- 2.1.1.txt
        `-- xyzzy-2.2
            `-- data
                `-- 2.2.2.txt
    ```

### apt

**Note:** This is the same demonstration as [yum](#yum)
but using `apt-get`.

1. In a new terminal window, shell into the debian image.

    ```console
    sudo docker exec -it spike-debian /bin/bash
    ```

1. Add system packages.

    ```console
    apt-get update
    apt-get install -y software-properties-common tree
    ```

1. Add the apt repository.

    ```console
    add-apt-repository 'deb http://spike-apt-repo trusty main'
    apt-get update --allow-unauthenticated
    ```

1. Show that there is nothing in `/opt`.

    ```console
    $ tree /opt
    /opt

    0 directories, 0 files
    ```

1. Install `xyzzy-2.0` at patch level `0`.

    ```console
    apt-get install --allow-unauthenticated -y xyzzy-2.0=0
    ```

1. Verify installation of `2.0.0.txt`.

    ```console
    $ tree /opt
    /opt
    `-- xyzzy
        `-- xyzzy-2.0
            `-- data
                `-- 2.0.0.txt

    3 directories, 1 file
    ```

1. Install `xyzzy-2.1` at patch level `1`.

    ```console
    apt-get install --allow-unauthenticated -y xyzzy-2.1=1
    ```

1. Verify addition of `xyzzy-2.1` directory.

    ```console
    $ tree /opt
    /opt
    `-- xyzzy
        |-- xyzzy-2.0
        |   `-- data
        |       `-- 2.0.0.txt
        `-- xyzzy-2.1
            `-- data
                `-- 2.1.1.txt

    5 directories, 2 files
    ```

1. Install `xyzzy-2.1` at latest level.

    ```console
    apt-get install --allow-unauthenticated -y xyzzy-2.2
    ```

1. Verify addition of `xyzzy-2.2` directory.

    ```console
    $ tree /opt
    /opt
    `-- xyzzy
        |-- xyzzy-2.0
        |   `-- data
        |       `-- 2.0.0.txt
        |-- xyzzy-2.1
        |   `-- data
        |       `-- 2.1.1.txt
        `-- xyzzy-2.2
            `-- data
                `-- 2.2.2.txt

    7 directories, 3 files
    ```

1. Update `xyzzy-2.0` from patch `0` to latest.

    ```console
    apt-get install --allow-unauthenticated -y xyzzy-2.0
    ```

1. Notice that `2.0.2.txt` exists and `2.0.0.txt` is gone.

    ```console
    $ tree /opt
    /opt
    `-- xyzzy
        |-- xyzzy-2.0
        |   `-- data
        |       `-- 2.0.2.txt
        |-- xyzzy-2.1
        |   `-- data
        |       `-- 2.1.1.txt
        `-- xyzzy-2.2
            `-- data
                `-- 2.2.2.txt

    7 directories, 3 files
    ```

### Cleanup

1. Bring down docker formation.

    ```console
    cd ${GIT_REPOSITORY_DIR}
    sudo \
      docker-compose down
    ```
