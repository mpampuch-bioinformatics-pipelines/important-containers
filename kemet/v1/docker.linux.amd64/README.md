# README

- Needs proper validation!
- Carveme not working (but may be optional for most purposes)

Made with 

```bash
wave \
  -f Dockerfile.wave.linux.amd64 \
  --context . \
  --platform linux/amd64 \
  --freeze \
  --build-repo docker.io/mpampuch/kemet_128b584_linux-amd64 \
  --await 60m \
  --log-level DEBUG
```
