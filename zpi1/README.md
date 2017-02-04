# Robot zpi1

It's Raspberry Pi on Zumo for Arduino.

## Deployment

On the robot:

- Configure hostname to be `zpi1`;
- Connect WiFi properly;
- Enable avahi for m-DNS resolving;
- Install [robotalk](https://github.com/robotalks/robotalk) to `/usr/local/bin`;
- Copy `board.yml` to `/opt/zupi/zpi1/share/`;
- Copy `zpi1-board.service` to `/etc/systemd/system/`;

```
sudo systemctl start zpi1-board
sudo systemctl enable zpi1-board # for autostart
```

On control machine (need a powerful CPU because of computer vision)

- `hmake build-vision-*` in [analytics](https://github.com/robotalks/analytics);
- `hmake` in [robotalks](https://github.com/robotalks/robotalk);
- Install `foreman` or alternatives (e.g. `npm install foreman -g`);
- `nf start`
