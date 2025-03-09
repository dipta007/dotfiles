Init YADM script - [private link](https://gist.github.com/dipta007/a68276b44fd9fa42f8746d6dfb2e8390)


## Public Version:
```
###########
# Install yadm
###########
mkdir -p ~/.local/bin && curl -fLo ~/.local/bin/yadm https://github.com/yadm-dev/yadm/raw/master/yadm && chmod a+x ~/.local/bin/yadm && export PATH=$PATH:$HOME/.local/bin

##########
# SETUP BW
##########
export BW_CLIENTID={BITWARDEN_CLIENT_ID}
export BW_CLIENTSECRET={BITWARDEN_CLIENT_SECRET}
export BW_PASSWORD={BITWARDEN_PASSWORD}
```
