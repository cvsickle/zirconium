# LocalSend

To clear up any firewall issues with LocalSend, allow port `53317` in the firewall rules.

```bash
sudo firewall-cmd --permanent --add-port=53317/tcp
sudo firewall-cmd --permanent --add-port=53317/udp
sudo firewall-cmd --reload
```
