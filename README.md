### Goal...

Here's the problem I wanted to solve... 

I periodically experiment with [Rust](https://www.rust-lang.org) (on my Mac), and occasionally want to compile a binary that works on RedHat. But unlike [Go](https://go.dev), you can't (at least yet) compile for just-anything on your working platform.

So in the past, I'd installed a VirtualBox instance of CentOS, fired that up, git-cloned the code, and then compiled from CentOS.

With our docker experimentation, I wanted to try this via docker.

---

### Usage...

- make a `cent_os_stuff` directory, and cd into that.

- `git clone git@github.com:birkin/rust-mac-centos-docker-experimentation.git ./code_on_laptop`

    Sorry about the naming -- the docker-compose file needs that `code_on_laptop` naming. I was experimenting; I'll clean this up at some point.

- `cd` into your `code_on_laptop` directory

- in the terminal, run `docker-compose run --rm shell`

    This builds the image, if necessary, then creates a container, and then puts you into bash (in the container, in the `code_on_container` container directory (which is mapped to yor `code_on_laptop` directory).

- to confirm you have rust installed: `rustc -V`

---

### Notes...

Some fun learning things about this, for me...

- Check out this line in the Dockerfile:

        RUN curl --proto '=https' --tlsv1.2 -sSf -t 0 https://sh.rustup.rs | sh -s -- -y

    The canonical way to get rust installed on linux is: 

        RUN curl --proto '=https' --tlsv1.2 -sSf -t 0 https://sh.rustup.rs | sh` 

    However, that gives you interactive prompts, which I didn't want for the Dockerfile.

    Adding that ` -s -- -y` on at the end allows that command to be run while passing in the `-y` argument to force `yes`. Cool! Who knew? (besides Joe! 🙂)

- My goal was really to get `docker-compose up` to get me into an interactive bash shell in the container, but I couldn't quite get that to work. I could get the container to stay up by using a few different commands in the docker-compose file, and then in a different terminal window I could connect to the container -- but not directly from my original terminal window. The `docker-compose run --rm shell` gives me the one-line command.

    From skimming, `docker-compose up` sets up networking that `docker-compose run` doesn't. The `run` apparently, is really made for quick one-off access to the container. But this is fine for my purposes. 

- The `--rm` in `docker-compose run --rm shell` makes the container disappear as soon as you exit from the interactive bash session. But that's ok, cuz it's super-quick to start up, and any work you've done in the `code_on_container` directory persists, because of the volume setup. Note, after I exit from the shell, I still run `docker-compose down` to clean up the 'network' that the docker-compose file creates (maybe there's a way to eliminate the creation, since I don't need it).

- Finally, just a note that the "shell" in `docker-compose run --rm shell` defines the 'service' you want access to (I have a "shell" service defined in the docker-compose file) -- so if I had a django-service and a solr-service defined in the docker-compose file, I could specify which service I wanted access to in the `run` command. (Just clarifying that the `shell` in the run command is not really directly related to the fact that I end up in bash.)

---