# Installing k3s

```bash
curl -sfL https://get.k3s.io | sh -
```

# FsNotify issue

If you encounter the following error: `fsnotify watcher: too many open files`,
you can increase the number of open files by running the following command:

```bash
sudo sysctl fs.inotify.max_user_watches=524288
sudo sysctl fs.inotify.max_user_instances=1024
# and to make it permanent
echo 'fs.inotify.max_user_watches=524288' | sudo tee -a /etc/sysctl.d/99-inotify.conf
echo 'fs.inotify.max_user_instances=1024' | sudo tee -a /etc/sysctl.d/99-inotify.conf
```

Then reboot the system or reload the sysctl configuration:

```bash
sudo sysctl -p /etc/sysctl.d/99-inotify.conf
```

# Enabling metallb in k3s

By default, k3s comes with a built-in service load balancer called `servicelb`. However, if you want to use MetalLB instead, you need to disable the built-in load balancer.

```yaml
# /etc/rancher/k3s/config.yaml
disable:
  - servicelb
```

or 

```bash
sudo tee /etc/rancher/k3s/config.yaml << EOF
disable:
  - servicelb
EOF
```

Then restart k3s

```bash
sudo systemctl restart k3s
```
