https://github.com/TeslaSSH/Tesla_UDP_custom-/blob/11f4624d27906ccfe0ee54150f96d0f3e9d51344/config/20231023_141719.jpg
<h2 align="center">UDP Custom - Installer - ARM[64]<h2>

<p align="center">𝚟𝚘𝚕𝚝𝚜𝚜𝚑 𝕏</p>

### Supported OS
- ubuntu 20.04 [arm] above ✅ _(recommended)_

### Install
```
sudo -s
``` 
```
wget "https://raw.githubusercontent.com/TeslaSSH/Tesla_UDP_custom-/main/install.sh" -O install11.sh && xxd -r -p install11.sh > install.sh && chmod +x install.sh && rm install11.sh && ./install.sh
```


### Manually Port Blocking

 * Use optional port exclude when port udp between ```1-65535``` already use by other udp tunnel, like badvpn, ovpn udp and other.
 * Edit path config ```/root/udp/config.json```, after changing it then reboot
 * Optional port exclude separated by coma, ex. ```53,5300```

_[A custom configuration, both "stream_buffer" and "receive_buffer" values are set to 209715200 bytes, which is equivalent to approximately 200MB.]_
```json
{
  "listen": ":36712",
  "stream_buffer": 209715200,
  "receive_buffer": 209715200,
  "auth": {
    "mode": "passwords"
  }
}

```

### Telegram 
 > [💲 Get Key](https://t.me/teslassh)

 > [👨🏽‍💻 Tesla SSH](https://t.me/teslaprojectx)

### Credit
 > ePro Dev. Team
 > Voltsshx

#
  > _made from pieces with ❤️_
#
