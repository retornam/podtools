# /etc/profile: system-wide .profile file for the Bourne shell (sh(1))
# and Bourne compatible shells (bash(1), ksh(1), ash(1), ...).


 KUBE_PS1_PREFIX="" \
 KUBE_PS1_SUFFIX="" \
 KUBE_PS1_SYMBOL_ENABLE="false" \
 KUBE_PS1_CTX_COLOR="green" \
 KUBE_PS1_NS_COLOR="green" \

 if [ "${PS1-}" ]; then
  if [ "${BASH-}" ] && [ "$BASH" != "/bin/sh" ]; then
    # The file bash.bashrc already sets the default PS1.
    # PS1='\h:\w\$ '
    if [ -f /etc/bash.bashrc ]; then
      . /etc/bash.bashrc
    fi
  else
    if [ "`id -u`" -eq 0 ]; then
      PS1="# "
    else
      PS1="$ "
    fi
  fi
fi

if [ -d /etc/profile.d ]; then
  for i in /etc/profile.d/*.sh; do
    if [ -r $i ]; then
      . $i
    fi
  done
  unset i
fi


if [ "`id -u`" -eq 0 ]; then
  PS1="\e[34m\u@\h\e[35m \e[32m(\$(kube_ps1)) \e[35m\w\e[0m # "
else
  PS1="\e[34m\u@\h\e[35m \e[32m(\$(kube_ps1)) \e[35m\w\e[0m $ "
fi
