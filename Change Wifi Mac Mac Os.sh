#!/usr/bin/env bash
read -p 'Step 1: Which device lined up would you like to change? (hit return for en0) ' ether_adapter

if [ -z $ether_adapter ]
then
  ether_adapter="en0"
fi

export ether_adapter=$ether_adapter

generate_and_set_new_mac_address() {
  mac=$( openssl rand -hex 6 | sed "s/\(..\)/\1:/g; s/./0/2; s/.$//")
  export mac=$mac
  echo "OK, we will change the mac address associated with: $ether_adapter"

  old_mac=$( ifconfig $ether_adapter | grep ether )

  echo "The old value was: $old_mac"
  sudo ifconfig $ether_adapter ether $mac

  new_mac=$( ifconfig $ether_adapter | grep ether )
  echo "The new value is: $new_mac"
}
echo $new_mac
echo $old_mac

while [ "$new_mac" == "$old_mac" ]
do
  echo "not the same"
  generate_and_set_new_mac_address
done

echo "Work is done my friend, Close now, and reconnect to your wifi network."
