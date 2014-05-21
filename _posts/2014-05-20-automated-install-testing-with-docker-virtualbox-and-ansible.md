---
layout: post
title: Automated Install Testing with Docker, VirtualBox, and Ansible
categories: tech
tags: ansible deployment docker vagrant 
---

My current project at [ThoughtWorks] involves building a deployment automation framework for a client with large, complex infrastructure. After a lot of deliberation, the team decided to write install scripts using [Ansible]. 

Ansible is simple but powerful and made it easy to hit the ground running. Once we started writing Ansible install scripts (called "playbooks"), we went looking for a way to test them automatically that was deterministic and fast. We couldn't deploy to the same host repeatedly, because its state would change over time and become a "snowflake" (i.e. be unique and therefore unrepresentative of a production environment).

A typical way to accomplish this would be to spin up a virtual machine from an image. This has the advantage of making testing deterministic and repeatable, but the disadvantage of being slower. It also wastes a lot of RAM when you run multiple builds simultaneously. Each one needs its own copy of the OS in memory. The tradeoff of virtualization is generally worth it. But what if you could have the best of both worlds?

Enter [Docker]. Docker is a "containerization" framework that gives most of the benefit of virtual machines in an extremely lightweight way. It's marketed as a way to create "portable, self-sufficient containers from any application". The idea is that you can create server images with applications installed into them. Those images can be passed around and run everywhere from dev to CI to production with no changes, and hence no surprises.  Our project is a bit of a different case, however, because our focus is in creating install scripts which install into existing servers. We can't pass Docker images all the way from dev to production, but we can still benefit from Docker's speed, efficiency, and consistency during development and testing.

So how does this work? Docker is based on a lower-level virtualization technology called [LXC] (LinuX Containers). Since it only works on Linux, Docker makes the most sense if you are running Linux in production. But it poses no problem for those of us who develop on OS X (or Windows, I assume). Using a handy tool called [boot2docker], you can get a Docker server up and running in no time inside of a VirtualBox VM. This is by far the easiest way to install Docker, even on Linux. (Configuring it on a plain Linux distro can be a hassle.) If you prefer [Vagrant] for managing your VMs, it's also easy to set up Docker using Vagrant's [Docker Provisioner].

Once Docker is up and running, you can try it out with the <code>run</code> command:

{% highlight bash %}
docker run busybox ps
{% endhighlight %}

At this point, a docker container (rougly equivalent to a virtual machine) will be created from the "busybox" image, which will be downloaded if not present (many other OS images are also [available](https://github.com/dotcloud/docker/wiki/Public-docker-images)). It will run the <code>ps</code> command and then exit, showing the results. If you want a Docker Container to stick around for a while, you have to start a long-running process like a server. Since we are testing ansible-installs, we use <code>sshd</code>. Note, however, that docker containers do not have any persistent storage by default. Any changes you make will be lost when the process exits.

Hopefully that whetted your appetite a bit. According to its authors, Docker is [not yet ready for production], but it's definitely a technology to watch in the coming year. If you want to try it out yourself, there's a nice [interactive tutorial] to get you going.

[boot2docker]: http://docs.docker.io/installation/mac/
[windows]: http://docs.docker.io/installation/windows/
[ThoughtWorks]: http://www.thoughtworks.com
[Ansible]: http://www.ansible.com
[Docker]: http://docker.io
[LXC]: https://linuxcontainers.org/
[Vagrant]: http://www.vagrantup.com/
[interactive tutorial]: https://www.docker.io/gettingstarted/
[not yet ready for production]: https://www.docker.io/learn_more/

